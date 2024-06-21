import 'package:app_financas2/Utils/formatador.dart';
import 'package:app_financas2/main.dart';
import 'package:app_financas2/pages/config_page.dart';
import 'package:app_financas2/pages/lancamentos_geral_page.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:time_machine/time_machine.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../objetcs/cartao.dart';
import '../objetcs/lancamento.dart';
import '../pages/lancamentos_mes_page.dart';

class MainController extends GetxController {
  RxInt maisAntiga =
      lancamentosBox.isEmpty ? 1.obs : RxInt(lancamentosBox.values.first.data);
  RxInt maisPraFrente =
      lancamentosBox.isEmpty ? 1.obs : RxInt(lancamentosBox.values.first.data);
  RxInt diferencaMeses = 0.obs;
  RxDouble faturaMesAtual = 0.0.obs;
  RxDouble saldoMesAtual = 0.0.obs;
  RxBool mostraBottomAppbar = true.obs;

  var indiceCliente = 0.obs;
  Rx<Widget> clienteTela = const LancamentosGeralPage().obs;
  RxList<Widget> widgetsCliente = <Widget>[].obs;
  RxInt indexMesSelecionado = 0.obs;

  Rx<DateTime> dataComparacaoSelecionada =
      DateTime(DateTime.now().year, DateTime.now().month).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    widgetsCliente.value = [
      const LancamentosGeralPage(),
      const LancamentosMesPage(),
      const ConfigPage(),
    ];

    clienteTela = widgetsCliente[0].obs;
    initializeDateFormatting();
  }

  atualizaTudo() {}

  Future<void> clienteMenuTapped(int index) async {
    indiceCliente.value = index;
    clienteTela.value = widgetsCliente.elementAt(indiceCliente.value);
  }

  calculaDatas() {
    if (lancamentosBox.isEmpty) {
      diferencaMeses.value = 7;
      return false;
    }

    maisAntiga = RxInt(lancamentosBox.values.first.data);
    maisPraFrente = RxInt(lancamentosBox.values.first.data);
    for (var x in lancamentosBox.values) {
      if (DateTime.fromMillisecondsSinceEpoch(x.data)
          .isBefore(DateTime.fromMillisecondsSinceEpoch(maisAntiga.value))) {
        maisAntiga.value = x.data;
      }

      if (LocalDate.dateTime(DateTime.fromMillisecondsSinceEpoch(x.data))
              .addMonths(x.parcelas)
              .compareTo(LocalDate.dateTime(
                  DateTime.fromMillisecondsSinceEpoch(maisPraFrente.value))) >
          0) {
        maisPraFrente.value = DateTime.parse(
                LocalDate.dateTime(DateTime.fromMillisecondsSinceEpoch(x.data))
                    .addMonths(x.parcelas)
                    .toDateTimeUnspecified()
                    .toString())
            .millisecondsSinceEpoch;
      }
    }

    diferencaMeses.value = int.parse(
        (DateTime.fromMillisecondsSinceEpoch(maisPraFrente.value)
                    .difference(
                        DateTime.fromMillisecondsSinceEpoch(maisAntiga.value))
                    .inDays /
                30)
            .ceil()
            .toString());
  }

// Função para calcular o valor de cada parcela
  double calcularValorPorParcela(double valorTotal, int parcelas) {
    return (valorTotal / (parcelas == 0 ? 1 : parcelas));
  }

// Função principal para calcular o valor total do mês
  double somaDoMes(int mesCalc, {bool saldo = false}) {
    double valor = 0.0;
    if (lancamentosBox.isEmpty) return 0.0;

    for (var lancamento in lancamentosBox.values) {
      if (incluiLancamentoNoMes(
              lancamento, DateTime.fromMillisecondsSinceEpoch(mesCalc)) ||
          lancamento.fixo) {
        double valorPorParcela =
            calcularValorPorParcela(lancamento.valorTotal, lancamento.parcelas);

        if (saldo) {
          valor += lancamento.ganho ? valorPorParcela : -valorPorParcela;
        } else {
          if (!lancamento.ganho) valor += valorPorParcela;
        }
      }
    }
    return valor;
  }

  LocalDate calcDataInicialCobranca(Lancamento lancamento) {
    LocalDate dataLancamento = LocalDate.dateTime(
        DateTime.fromMillisecondsSinceEpoch(lancamento.data));

    if (dataLancamento.dayOfMonth >=
            (int.parse(lancamento.cartao.vencimento!) - 7) &&
        lancamento.ganho == false &&
        lancamento.parcelas > 0) {
      dataLancamento = dataLancamento.addMonths(1);
    }
    return dataLancamento;
  }

  calcDataFinalCobranca(Lancamento lancamento) {
    LocalDate dataInicial = calcDataInicialCobranca(lancamento);
    return dataInicial.addMonths(lancamento.parcelas -
        (lancamento.parcelas > 0 ? 1 : lancamento.parcelas));
  }

  incluiLancamentoNoMes(Lancamento lancamento, DateTime dataComparacao) {
    LocalDate dataSelecionada = LocalDate.dateTime(dataComparacao);
    LocalDate dataInicial = calcDataInicialCobranca(lancamento);
    LocalDate dataFinal = calcDataFinalCobranca(lancamento);
    LocalDate dataSelecionadaComparacao =
        LocalDate(dataSelecionada.year, dataSelecionada.monthOfYear, 1);
    LocalDate dataInicialComparacao =
        LocalDate(dataInicial.year, dataInicial.monthOfYear, 1);
    LocalDate dataFinalComparacao =
        LocalDate(dataFinal.year, dataFinal.monthOfYear, 1);

    if (dataInicialComparacao <= dataSelecionadaComparacao &&
        (dataFinalComparacao >= dataSelecionadaComparacao || lancamento.fixo)) {
      return true;
    }
    return false;
  }

  int parcelaAtual(Lancamento lancamento, DateTime dataAtual) {
    DateTime dataLancamento =
        calcDataInicialCobranca(lancamento).toDateTimeUnspecified();
    int mesesDiferenca = ((dataAtual.year - dataLancamento.year) * 12 +
        dataAtual.month -
        dataLancamento.month);

    if (mesesDiferenca < 0) {
      // A data atual é antes da data de lançamento
      return 0;
    }

    int parcelaAtual = mesesDiferenca + 1;

    if (parcelaAtual > lancamento.parcelas) {
      // A data atual é depois da última parcela
      return lancamento.parcelas;
    }

    return parcelaAtual;
  }

// Função para criar o widget do cartão de lançamento
  Widget createLancamentoCard(
      int index, Lancamento lancamento, Function onDelete, DateTime data) {
    return Card(
      elevation: 2,
      child: ListTile(
        textColor: lancamento.ganho ? Colors.green : null,
        onLongPress: () {
          Get.dialog(CupertinoAlertDialog(
              actions: [
                CupertinoDialogAction(
                  child: const Text("Deletar lançamento"),
                  onPressed: () {
                    onDelete(index);
                  },
                )
              ],
              title: Text(lancamento.descricao),
              content: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "Valor Total: ${Formatador.double2real(lancamento.valorTotal)}"),
                    Text(
                        "Parcelas: ${lancamento.parcelas}x de ${Formatador.double2real(calcularValorPorParcela(lancamento.valorTotal, lancamento.parcelas))}"),
                    Text("Cartão: ${lancamento.cartao.name}"),
                    Text(
                        "Data do Lançamento: ${Formatador.milis2simpleDateTime(lancamento.data, ano: true)}")
                  ],
                ),
              )));
        },
        dense: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                lancamento.descricao,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 45),
            Text(Formatador.milis2simpleDateTime(lancamento.data, ano: true)),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Total ${Formatador.double2real(lancamento.valorTotal)}",
                  style:
                      TextStyle(color: lancamento.ganho ? Colors.green : null),
                ),
              ],
            ),
            lancamento.fixo
                ? Container()
                : Text(
                    "${Formatador.double2real(lancamento.valorTotal / (lancamento.parcelas == 0 ? 1 : lancamento.parcelas))} (${parcelaAtual(lancamento, data)}/${lancamento.parcelas})",
                  ),
          ],
        ),
      ),
    );
  }

// Função principal para gerar a lista de widgets
  Widget historicoWidget({bool filtraMes = false}) {
    DateTime dataComparacao = dataComparacaoSelecionada.value;
    List<Widget> widgets = [];

    for (int i = 0; i < lancamentosBox.length; i++) {
      Lancamento lancamento = lancamentosBox.values.elementAt(i);
      bool exibirLancamento =
          (!filtraMes || incluiLancamentoNoMes(lancamento, dataComparacao)) &&
              !lancamento.fixo;

      if (exibirLancamento) {
        widgets.add(createLancamentoCard(i, lancamento, (index) {
          lancamentosBox.deleteAt(index);
          atualizaTudo();
        }, dataComparacaoSelecionada.value));
      }
    }

    return widgets.isEmpty
        ? const Center(
            child: Text("Nenhum lançamento disponível"),
          )
        : ScrollConfiguration(
            behavior: _ScrollbarBehaviorHorizontal(),
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: widgets.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return widgets.reversed.elementAt(index);
              },
            ),
          );
  }

  Sla(BuildContext context) {
    RxList<Widget> listaWidgets = <Widget>[].obs;

    for (Cartao cartao in cartoesBox.values) {
      var tcValor = TextEditingController(text: "0");
      RxDouble valorTotal = 0.0.obs;

      listaWidgets.add(Card(
        child: CupertinoTextFormFieldRow(
          style: CupertinoTheme.of(context).textTheme.textStyle,
          onTap: () {
            tcValor.selection =
                TextSelection.collapsed(offset: tcValor.text.length);
          },
          prefix: const Text("Valor"),
          controller: tcValor,
          textAlign: TextAlign.end,
          keyboardType: const TextInputType.numberWithOptions(),
          onChanged: (newValue) {
            if (newValue.isEmpty) newValue = "0";

            valorTotal.value = double.parse(newValue.removeAllWhitespace
                .replaceAll(".", "")
                .replaceAll(",", ".")
                .replaceAll("R\$", ""));
            calculaSaldoManual();
          },
          inputFormatters: <TextInputFormatter>[
            CurrencyTextInputFormatter.simpleCurrency(locale: 'pt')
          ],
        ),
      ));
    }
    ;
  }

  calcSaldoDoMesManual(BuildContext context) {
    RxDouble saldoManual = 0.0.obs;

    Get.dialog(CupertinoAlertDialog(
      title: Text(
          "Saldo de ${(DateFormat.MMMM("PT").format(dataComparacaoSelecionada.value).capitalizeFirst)} / ${dataComparacaoSelecionada.value.year}"),
      content: Column(
        children: [],
      ),
    ));
  }

  calculaSaldoManual() {}

  mesesDisponiveis(BuildContext context) {
    calculaDatas();

    var mesCalc = LocalDate.dateTime(
        DateTime.fromMillisecondsSinceEpoch(maisAntiga.value));

    for (int i = 0; i < diferencaMeses.value; i++) {
      if (DateTime(
              mesCalc.addMonths(i).year, mesCalc.addMonths(i).monthOfYear) ==
          DateTime(DateTime.now().year, DateTime.now().month)) {
        indexMesSelecionado.value = i;
      }
    }

    return Obx(
      () => ScrollConfiguration(
        behavior: _ScrollbarBehaviorVertical(),
        child: ScrollablePositionedList.builder(
          initialAlignment: 0.2,
          initialScrollIndex: indexMesSelecionado.value,
          itemScrollController: ItemScrollController(),
          scrollOffsetController: ScrollOffsetController(),
          itemPositionsListener: ItemPositionsListener.create(),
          scrollOffsetListener: ScrollOffsetListener.create(),
          scrollDirection: Axis.horizontal,
          itemCount: diferencaMeses.value + 1,
          itemBuilder: (BuildContext context, int i) {
            var dataComparacao = DateTime(
                mesCalc.addMonths(i).year, mesCalc.addMonths(i).monthOfYear);
            var comparacao = dataComparacao == dataComparacaoSelecionada.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Card(
                elevation: comparacao ? 5 : 0.2,
                child: InkWell(
                  onTap: () {
                    indexMesSelecionado.value = i;
                    dataComparacaoSelecionada.value = DateTime(
                        mesCalc.addMonths(i).year,
                        mesCalc.addMonths(i).monthOfYear);
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: comparacao ? 15.0 : 8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${(DateFormat.MMM("pt").format(mesCalc.addMonths(i).toDateTimeUnspecified())).capitalizeFirst} ${mesCalc.addMonths(i).year}",
                            style: TextStyle(
                                fontWeight:
                                    comparacao ? FontWeight.bold : null),
                          ),
                          Text(
                            Formatador.double2real(somaDoMes(
                              mesCalc
                                  .addMonths(i)
                                  .toDateTimeUnspecified()
                                  .millisecondsSinceEpoch,
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ScrollbarBehaviorVertical extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return CupertinoScrollbar(
      controller: details.controller,
      scrollbarOrientation: ScrollbarOrientation.top,
      child: child,
    );
  }
}

class _ScrollbarBehaviorHorizontal extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return CupertinoScrollbar(
      controller: details.controller,
      scrollbarOrientation: ScrollbarOrientation.right,
      child: child,
    );
  }
}

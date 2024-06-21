import 'package:app_financas2/Utils/formatador.dart';
import 'package:app_financas2/main.dart';
import 'package:app_financas2/pages/lancamentos_geral_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:time_machine/time_machine.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../objetcs/lancamento.dart';
import '../pages/lancamentos_mes_page.dart';

class MainController extends GetxController {
  RxInt maisAntiga =
      lancamentosBox.isEmpty ? 1.obs : RxInt(lancamentosBox.values.first.data);
  RxInt maisPraFrente =
      lancamentosBox.isEmpty ? 1.obs : RxInt(lancamentosBox.values.first.data);
  RxInt diferencaMeses = 0.obs;
  RxDouble valorMesAtual = 0.0.obs;
  RxDouble saldoMesAtual = 0.0.obs;

  var indiceCliente = 0.obs;
  late Rx<Widget> clienteTela;
  RxList<Widget> widgetsCliente = <Widget>[].obs;
  RxInt indexMesSelecionado = 0.obs;
  RxDouble valorLimiteUtilizado = 0.0.obs;

  Rx<DateTime> dataComparacaoSelecionada =
      DateTime(DateTime.now().year, DateTime.now().month).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    calculaMesAtual();
    calculaLimiteTotalUtilizado();
    widgetsCliente.value = [
      const LancamentosGeralPage(),
      const LancamentosMesPage(),
    ];

    clienteTela = widgetsCliente[0].obs;
    initializeDateFormatting();
  }

  atualizaTudo() {
    calculaMesAtual();
    calculaLimiteTotalUtilizado();
  }

  Future<void> clienteMenuTapped(int index) async {
    indiceCliente.value = index;
    clienteTela.value = widgetsCliente.elementAt(indiceCliente.value);
  }

  calculaLimiteTotalUtilizado() {
    if (lancamentosBox.isEmpty) {
      valorLimiteUtilizado.value = 0.0;
      return false;
    }

    double valor = 0;
    for (Lancamento x in lancamentosBox.values) {
      if (DateTime(
                  LocalDate.dateTime(
                          DateTime.fromMillisecondsSinceEpoch(x.data))
                      .addMonths(x.parcelas)
                      .year,
                  LocalDate.dateTime(
                          DateTime.fromMillisecondsSinceEpoch(x.data))
                      .addMonths(x.parcelas)
                      .monthOfYear,
                  1)
              .compareTo(DateTime(DateTime.now().year, DateTime.now().month)) >=
          0) {
        if (x.ganho) {
          valor += (x.valorTotal / (x.parcelas == 0 ? 1 : x.parcelas)) *
              LocalDate.difference(
                LocalDate(
                    LocalDate.dateTime(
                            DateTime.fromMillisecondsSinceEpoch(x.data))
                        .addMonths(x.parcelas)
                        .year,
                    LocalDate.dateTime(
                            DateTime.fromMillisecondsSinceEpoch(x.data))
                        .addMonths(x.parcelas)
                        .monthOfYear,
                    1),
                LocalDate(DateTime.now().year, DateTime.now().month, 1),
              ).months;
        }
      }
    }

    valorLimiteUtilizado.value = valor + valorMesAtual.value;
  }

  calculaMesAtual() {
    valorMesAtual.value = 0.0;
    saldoMesAtual.value = 0.0;
    if (lancamentosBox.isEmpty) {
      return;
    }

    for (Lancamento x in lancamentosBox.values) {
      if (DateTime(DateTime.fromMillisecondsSinceEpoch(x.data).year,
                      DateTime.fromMillisecondsSinceEpoch(x.data).month)
                  .compareTo(
                      DateTime(DateTime.now().year, DateTime.now().month)) <
              0 &&
          DateTime(
                      LocalDate.dateTime(
                              DateTime.fromMillisecondsSinceEpoch(x.data))
                          .addMonths(x.parcelas)
                          .year,
                      LocalDate.dateTime(
                              DateTime.fromMillisecondsSinceEpoch(x.data))
                          .addMonths(x.parcelas)
                          .monthOfYear,
                      1)
                  .compareTo(
                      DateTime(DateTime.now().year, DateTime.now().month)) >=
              0) {
        valorMesAtual.value += x.valorTotal / x.parcelas;
        saldoMesAtual.value -= x.valorTotal / x.parcelas;
        if (x.ganho) {
          saldoMesAtual.value +=
              x.valorTotal / (x.parcelas == 0 ? 1 : x.parcelas);
        }
      }
    }
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

  /*double somaDoMesANTIGA(LocalDate mesCalc, {bool saldo = false}) {
    double valor = 0.0;
    if (lancamentosBox.isEmpty) return 0.0;
    for (Lancamento x in lancamentosBox.values) {
      if ((x.ganho
              ? DateTime(DateTime.fromMillisecondsSinceEpoch(x.data).year, DateTime.fromMillisecondsSinceEpoch(x.data).month, 1).compareTo(DateTime(mesCalc.year, mesCalc.monthOfYear, 1)) <=
                  0
              : DateTime(DateTime.fromMillisecondsSinceEpoch(x.data).year, DateTime.fromMillisecondsSinceEpoch(x.data).month, 1).compareTo(DateTime(mesCalc.year, mesCalc.monthOfYear, 1)) <
                  0) &&
          ((x.ganho
                  ? DateTime(
                              LocalDate.dateTime(DateTime.fromMillisecondsSinceEpoch(x.data))
                                  .addMonths(x.parcelas)
                                  .year,
                              LocalDate.dateTime(DateTime.fromMillisecondsSinceEpoch(x.data))
                                  .addMonths(x.parcelas)
                                  .monthOfYear,
                              1)
                          .compareTo(
                              DateTime(mesCalc.year, mesCalc.monthOfYear, 1)) >
                      0
                  : DateTime(
                              LocalDate.dateTime(DateTime.fromMillisecondsSinceEpoch(x.data))
                                  .addMonths(x.parcelas)
                                  .year,
                              LocalDate.dateTime(DateTime.fromMillisecondsSinceEpoch(x.data))
                                  .addMonths(x.parcelas)
                                  .monthOfYear,
                              1)
                          .compareTo(DateTime(mesCalc.year, mesCalc.monthOfYear, 1)) >=
                      0) ||
              x.fixo)) {
        if (saldo) {
          x.ganho
              ? valor += x.valorTotal / (x.parcelas == 0 ? 1 : x.parcelas)
              : valor -= x.valorTotal / (x.parcelas == 0 ? 1 : x.parcelas);
        } else {
          !x.ganho
              ? valor += x.valorTotal / (x.parcelas == 0 ? 1 : x.parcelas)
              : null;
        }
      }
    }
    return valor;
  }*/

  // Função para verificar se a data do lançamento está dentro do intervalo do mês calculado
  bool isWithinMonth(LocalDate mesCalc, int data, bool ganho, int parcelas) {
    DateTime dataLancamento = DateTime.fromMillisecondsSinceEpoch(data);
    DateTime dataInicial =
        DateTime(dataLancamento.year, dataLancamento.month, 1);
    DateTime dataFinal = dataLancamento.add(Duration(days: 30 * parcelas));
    DateTime dataFinalAjustada = DateTime(dataFinal.year, dataFinal.month, 1);

    DateTime mesCalcInicio = DateTime(mesCalc.year, mesCalc.monthOfYear, 1);

    if (ganho) {
      return dataInicial.compareTo(mesCalcInicio) <= 0 &&
          dataFinalAjustada.compareTo(mesCalcInicio) > 0;
    } else {
      return dataInicial.compareTo(mesCalcInicio) < 0 &&
          dataFinalAjustada.compareTo(mesCalcInicio) >= 0;
    }
  }

// Função para calcular o valor de cada parcela
  double calcularValorPorParcela(double valorTotal, int parcelas) {
    return (valorTotal / (parcelas == 0 ? 1 : parcelas));
  }

// Função principal para calcular o valor total do mês
  double somaDoMes(LocalDate mesCalc, {bool saldo = false}) {
    double valor = 0.0;
    if (lancamentosBox.isEmpty) return 0.0;

    DateTime mesCalcInicio = DateTime(mesCalc.year, mesCalc.monthOfYear, 1);

    for (var lancamento in lancamentosBox.values) {
      if (isWithinMonth(mesCalc, lancamento.data, lancamento.ganho,
              lancamento.parcelas) ||
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

  // Função para verificar se a data está dentro do intervalo desejado
  bool isDateWithinRange(
      int data, bool ganho, DateTime dataComparacao, int parcelas) {
    DateTime dataLancamento = DateTime.fromMillisecondsSinceEpoch(data);
    DateTime dataInicial =
        DateTime(dataLancamento.year, dataLancamento.month, 1);
    DateTime dataFinal = DateTime(
      LocalDate.dateTime(dataLancamento).addMonths(parcelas).year,
      LocalDate.dateTime(dataLancamento).addMonths(parcelas).monthOfYear,
    );

    if (ganho) {
      return dataInicial.compareTo(dataComparacao) <= 0 &&
          dataFinal.compareTo(dataComparacao) > 0;
    } else {
      return (dataInicial.compareTo(dataComparacao) < 0 || parcelas == 0) &&
          dataFinal.compareTo(dataComparacao) >= 0;
    }
  }

  int parcelaAtual(int data, int parcelas, DateTime dataAtual) {
    DateTime dataLancamento = DateTime.fromMillisecondsSinceEpoch(data);
    int mesesDiferenca = ((dataAtual.year - dataLancamento.year) * 12 +
        dataAtual.month -
        dataLancamento.month);

    if (mesesDiferenca < 0) {
      // A data atual é antes da data de lançamento
      return 0;
    }

    int parcelaAtual = mesesDiferenca + 1;

    if (parcelaAtual > parcelas) {
      // A data atual é depois da última parcela
      return parcelas;
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
          onDelete(index);
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
                    "${Formatador.double2real(lancamento.valorTotal / (lancamento.parcelas == 0 ? 1 : lancamento.parcelas))} (${parcelaAtual(lancamento.data, lancamento.parcelas, data)}/${lancamento.parcelas})",
                  ),
          ],
        ),
      ),
    );
  }


// Função principal para gerar a lista de widgets
  Widget historicoWidget({bool filtraMes = false}) {
    if (lancamentosBox.isEmpty) {
      return const Text("Sem lançamentos");
    }

    DateTime dataComparacao = dataComparacaoSelecionada.value;
    List<Widget> widgets = [];

    for (int i = 0; i < lancamentosBox.length; i++) {
      var lancamento = lancamentosBox.values.elementAt(i);
      bool exibirLancamento = !filtraMes ||
          isDateWithinRange(lancamento.data, lancamento.ganho, dataComparacao,
              lancamento.parcelas) ||
          lancamento.fixo;

      if (exibirLancamento && (!lancamento.ganho || filtraMes)) {
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
      () => SizedBox(
        height: 100,
        child: Stack(
          children: [
            ScrollConfiguration(
              behavior: _ScrollbarBehaviorVertical(),
              child: Stack(
                children: [
                  ScrollablePositionedList.builder(
                    initialAlignment: 0.2,
                    initialScrollIndex: indexMesSelecionado.value,
                    itemScrollController: ItemScrollController(),
                    scrollOffsetController: ScrollOffsetController(),
                    itemPositionsListener: ItemPositionsListener.create(),
                    scrollOffsetListener: ScrollOffsetListener.create(),
                    scrollDirection: Axis.horizontal,
                    itemCount: diferencaMeses.value + 1,
                    itemBuilder: (BuildContext context, int i) {
                      var dataComparacao = DateTime(mesCalc.addMonths(i).year,
                          mesCalc.addMonths(i).monthOfYear);
                      var comparacao =
                          dataComparacao == dataComparacaoSelecionada.value;
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: comparacao ? 15.0 : 8),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${(DateFormat.MMM("pt").format(mesCalc.addMonths(i).toDateTimeUnspecified())).capitalizeFirst} ${mesCalc.addMonths(i).year}",
                                      style: TextStyle(
                                          fontWeight: comparacao
                                              ? FontWeight.bold
                                              : null),
                                    ),
                                    Text(
                                      Formatador.double2real(somaDoMes(
                                          mesCalc.addMonths(i),
                                          saldo: true)),
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
                  IgnorePointer(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(250),
                              right: Radius.circular(250)),
                          color: Colors.transparent,
                          border: Border.symmetric(
                              vertical: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  width: 45,
                                  strokeAlign: BorderSide.strokeAlignOutside))),
                    ),
                  )
                ],
              ),
            ),
          ],
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: child,
      ),
    );
  }
}

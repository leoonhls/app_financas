import 'package:app_financas2/main.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../Utils/formatador.dart';
import '../objetcs/calc_manual_fatura.dart';
import 'main_controller.dart';

class CalcManualController extends GetxController {
  RxDouble valorSaldoManual = 0.0.obs;
  late List<TextEditingController> controllers;

  geraTextControllerSaldoManual() {
    controllers = List.generate(cartoesBox.length, (i) {
      return TextEditingController(
          text: Formatador.double2real(Get.find<MainController>()
              .somaDoMesCartao(
                  Get.find<MainController>()
                      .dataComparacaoSelecionada
                      .value
                      .millisecondsSinceEpoch,
                  cartoesBox.values.elementAt(i))));
    });
  }

  createFaturasEditaveis(BuildContext context) {
    List<Widget> lista = [];
    int i = 0;
    for (TextEditingController textController in controllers) {
      double slaa = 0.0;
      for (CalcManualFatura calcManualFatura in calcManualFaturasBox.values) {
        DateTime dataCalcManualFatura = DateTime(
            DateTime.fromMillisecondsSinceEpoch(calcManualFatura.data!).year,
            DateTime.fromMillisecondsSinceEpoch(calcManualFatura.data!).month);

        print(Get.find<MainController>().dataComparacaoSelecionada.value);
        print(dataCalcManualFatura);

        if (dataCalcManualFatura.isAtSameMomentAs(
                Get.find<MainController>().dataComparacaoSelecionada.value) &&
            calcManualFatura.cartao!.name ==
                cartoesBox.values.elementAt(i).name) {
          slaa = calcManualFatura.valor!;
        }
      }

      lista.add(Column(
        children: [
          CupertinoTextFormFieldRow(
            style: CupertinoTheme.of(context).textTheme.textStyle,
            onTap: () {
              textController.selection =
                  TextSelection.collapsed(offset: textController.text.length);
            },
            prefix: Text(cartoesBox.values.elementAt(i).name),
            controller: textController,
            textAlign: TextAlign.end,
            keyboardType: const TextInputType.numberWithOptions(),
            onChanged: (newValue) {
              if (newValue.isEmpty) newValue = "0";
              saldoMesManual();
            },
            inputFormatters: <TextInputFormatter>[
              CurrencyTextInputFormatter.simpleCurrency(
                locale: 'pt',
              )
            ],
          ),
          Text("Slaa = $slaa")
        ],
      ));
      i++;
    }
    return lista;
  }

  saldoMesManual() {
    valorSaldoManual.value = 0.0;
    for (TextEditingController textController in controllers) {
      if (textController.text.isEmpty) textController.text = "0";
      valorSaldoManual.value -= double.parse(textController
          .text.removeAllWhitespace
          .replaceAll(".", "")
          .replaceAll(",", ".")
          .replaceAll("R\$", ""));
    }
    double valor = Get.find<MainController>().calcGanhoMes(
        Get.find<MainController>()
            .dataComparacaoSelecionada
            .value
            .millisecondsSinceEpoch);
    valorSaldoManual.value += valor;
  }

  regFaturas() {
    calcManualFaturasBox.clear();
    for (int i = 0; i < cartoesBox.values.length; i++) {
      calcManualFaturasBox.add(CalcManualFatura.novo(
          data: DateTime.now().millisecondsSinceEpoch,
          cartao: cartoesBox.values.elementAt(i),
          valor: double.parse(controllers
              .elementAt(i)
              .text
              .replaceAll("R\$", "")
              .replaceAll(".", "")
              .replaceAll(",", ".")
              .removeAllWhitespace)));
    }
    Get.snackbar(
      "Registrado",
      "${calcManualFaturasBox.values.length}",
    );

    for (CalcManualFatura calcManualFatura in calcManualFaturasBox.values) {
      print("${calcManualFatura.cartao!.name} == ${calcManualFatura.valor}");
    }
  }
}

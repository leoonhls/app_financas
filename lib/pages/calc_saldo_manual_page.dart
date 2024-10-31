import 'package:app_financas2/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Utils/formatador.dart';
import '../controller/calc_manual_fatura_controller.dart';

class CalcSaldoManualPage extends GetView<CalcManualController> {
  const CalcSaldoManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CalcManualController());
    controller.geraTextControllerSaldoManual();
    controller.saldoMesManual();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "Saldo de ${(DateFormat.MMMM("PT").format(Get.find<MainController>().dataComparacaoSelecionada.value).capitalizeFirst)} / ${Get.find<MainController>().dataComparacaoSelecionada.value.year}"),
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Inserir faturas:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Column(
                  children: controller.createFaturasEditaveis(context),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Obx(
                    () => Text(
                      "Saldo total: ${Formatador.double2real(controller.valorSaldoManual.value)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
                Card(
                  child: TextButton(
                    child: const Text("Registrar"),
                    onPressed: () {
                      controller.regFaturas();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:app_financas2/Utils/formatador.dart';
import 'package:app_financas2/controller/main_controller.dart';
import 'package:app_financas2/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:time_machine/time_machine.dart';

class LancamentosMesPage extends GetView<MainController> {
  const LancamentosMesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    controller.mostraBottomAppbar.value = true;

    return ValueListenableBuilder(
      valueListenable: lancamentosBox.listenable(),
      builder: (BuildContext context, Box<dynamic> value, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
              preferredSize: const Size(100, 120),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(20)),
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: controller.mesesDisponiveis(context),
                ),
              )),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      controller.calcSaldoDoMesManual(context);

                    },
                    title: const Text("Calcular saldo:"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Lançamentos:"),
                        Text(
                          Formatador.double2real(controller.somaDoMes(
                              controller.dataComparacaoSelecionada.value
                                  .millisecondsSinceEpoch,
                              saldo: true)),
                          style: TextStyle(
                              color: controller
                                      .somaDoMes(
                                          controller.dataComparacaoSelecionada
                                              .value.millisecondsSinceEpoch,
                                          saldo: true)
                                      .isNegative
                                  ? Colors.red
                                  : Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20.0, left: 20, right: 20),
                    child: Card(
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${(DateFormat.MMMM("PT").format(controller.dataComparacaoSelecionada.value))} ${controller.dataComparacaoSelecionada.value.year}",
                              ),
                              Text(
                                Formatador.double2real(controller.somaDoMes(
                                  controller.dataComparacaoSelecionada.value
                                      .millisecondsSinceEpoch,
                                )),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 50.0,
                          ),
                          child: controller.historicoWidget(filtraMes: true),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

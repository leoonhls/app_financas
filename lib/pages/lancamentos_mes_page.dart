import 'package:app_financas2/Utils/formatador.dart';
import 'package:app_financas2/controller/main_controller.dart';
import 'package:app_financas2/main.dart';
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
    return ValueListenableBuilder(
      valueListenable: lancamentosBox.listenable(),
      builder: (BuildContext context, Box<dynamic> value, Widget? child) {
        return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: controller.mesesDisponiveis(context),
              ),

              Expanded(
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(top: 16.0),
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
                                  LocalDate.dateTime(
                                      controller.dataComparacaoSelecionada.value),
                                  saldo: true)),
                              style: TextStyle(
                                  color: controller
                                          .somaDoMes(
                                              LocalDate.dateTime(controller
                                                  .dataComparacaoSelecionada
                                                  .value),
                                              saldo: true)
                                          .isNegative
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: controller.historicoWidget(filtraMes: true),
                      ),
                    ),
                  ),
                ),
              ),
            ],
        );
      },
    );
  }
}

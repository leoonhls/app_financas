import 'package:app_financas2/Utils/formatador.dart';
import 'package:app_financas2/controller/main_controller.dart';
import 'package:app_financas2/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'add_lancamento_page.dart';

class LancamentosGeralPage extends GetView<MainController> {
  const LancamentosGeralPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    controller.calculaLimiteTotalUtilizado();
    controller.calculaMesAtual();
    return ValueListenableBuilder(
      valueListenable: lancamentosBox.listenable(),
      builder: (BuildContext context, Box<dynamic> value, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    child: Obx(
                      () => ListTile(
                        title: Text(
                            "Mês atual (${(DateFormat.MMM("PT").format(DateTime.now())).capitalizeFirst}): ${Formatador.double2real(controller.valorMesAtual.value)}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Saldo: ${Formatador.double2real(controller.saldoMesAtual.value)}"),
                            Text(
                                "Limite total utilizado: ${Formatador.double2real(controller.valorLimiteUtilizado.value)}"),
                          ],
                        ),
                        trailing: InkWell(
                            onTap: () {
                              Get.delete<MainController>(force: true);
                              Get.put(MainController());
                              Get.to(() => const AddLancamento());
                            },
                            child:  const Card(margin: EdgeInsets.all(0), elevation: 10, child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.plus_one),
                            ))),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 500,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ListTile(
                      title: const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Histórico",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: controller.historicoWidget(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

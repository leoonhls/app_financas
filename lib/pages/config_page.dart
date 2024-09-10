import 'package:app_financas2/controller/config_controller.dart';
import 'package:app_financas2/controller/main_controller.dart';
import 'package:app_financas2/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConfigPage extends GetView<ConfigController> {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<MainController>().mostraBottomAppbar.value = false;
    Get.put(ConfigController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: cartoesBox.listenable(),
                builder:
                    (BuildContext context, Box<dynamic> value, Widget? child) {
                  return controller.cartoesCadastrados();
                },
              ),
              ValueListenableBuilder(
                valueListenable: cartoesBox.listenable(),
                builder:
                    (BuildContext context, Box<dynamic> value, Widget? child) {
                  return controller.lancamentosFixos();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

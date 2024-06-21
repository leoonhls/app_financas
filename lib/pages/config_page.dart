import 'package:app_financas2/controller/config_controller.dart';
import 'package:app_financas2/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigPage extends GetView<ConfigController> {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<MainController>().mostraBottomAppbar.value = false;
    Get.put(ConfigController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all( 20.0),
        child: Column(
          children: [
            controller.cartoesCadastrados(),
            controller.lancamentosFixos()
          ],
        ),
      ),
    );
  }
}

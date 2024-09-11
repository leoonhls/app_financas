import 'package:app_financas2/controller/main_controller.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends GetView<MainController> {
  const MainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    var padding = (MediaQuery.of(context).size.width - 250) / 2;
    return Obx(
      () => Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 20, left: padding, right: padding),
          child: CustomNavigationBar(
            iconSize: 30.0,
            selectedColor: Colors.white,
            strokeColor: Colors.white,
            unSelectedColor: Colors.grey[600],
            backgroundColor: Colors.black,
            borderRadius: const Radius.circular(40.0),
            blurEffect: true,
            opacity: 0.8,
            items: [
              CustomNavigationBarItem(
                icon: const Icon(Icons.workspaces_rounded),
              ),
              CustomNavigationBarItem(
                icon: const Icon(Icons.calendar_month),
              ),
              CustomNavigationBarItem(
                icon: const Icon(Icons.settings),
              ),
            ],
            currentIndex: controller.indiceCliente.value,
            onTap: controller.clienteMenuTapped,
            isFloating: true,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          shadowColor: Colors.deepPurple.withAlpha(150),
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            "Controle de Gastos",
          ),
        ),
        body: controller.clienteTela(),
      ),
    );
  }
}

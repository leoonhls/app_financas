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
      () => SafeArea(
        child: Scaffold(
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
            centerTitle: true,

            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Padding(
              padding: EdgeInsets.only(top: 17.0),
              child: Text("Controle de Gastos",
                  style: TextStyle(
                      fontFamily: "Josefin Sans",
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
            ),
          ),
          body: controller.clienteTela(),
        ),
      ),
    );
  }
}

import 'package:app_financas2/controller/main_controller.dart';
import 'package:app_financas2/main.dart';
import 'package:app_financas2/objetcs/cartao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../Utils/formatador.dart';

class ConfigController extends GetxController {
  Widget lancamentosFixos() {
    RxList<Widget> listaWidgets = <Widget>[].obs;

    for (int i = 0; i < lancamentosBox.length; i++) {
      if (lancamentosBox.values.elementAt(i).fixo) {
        listaWidgets.add(Card(
            elevation: 2,
            child: Get.find<MainController>().createLancamentoCard(i,
                lancamentosBox.values.elementAt(i), onDelete, DateTime.now())));
      }
    }

    return Card(
      child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Lançamentos Fixos"),
              InkWell(onTap: () {}, child: const Icon(Icons.add))
            ],
          ),
          subtitle: ValueListenableBuilder(
            valueListenable: cartoesBox.listenable(),
            builder: (BuildContext context, Box<dynamic> value, Widget? child) {
              return Column(
                children: listaWidgets.isNotEmpty
                    ? listaWidgets
                    : [
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text("Sem lançamentos fixos cadastrados"),
                        )
                      ],
              );
            },
          )),
    );
  }

  Widget cartoesCadastrados() {
    RxList<Widget> listaWidgets = <Widget>[].obs;

    for (Cartao cartao in cartoesBox.values) {
      listaWidgets.add(Card(
        elevation: 2,
        child: ListTile(
          onLongPress: () {
            Get.dialog(CupertinoAlertDialog(
                actions: [
                  CupertinoDialogAction(
                    child: const Text("Deletar Cartão"),
                    onPressed: () {
                      cartoesBox.delete(cartao.key);
                    },
                  )
                ],
                title: Text(cartao.name!),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Tipo do Cartão: ${cartao.tipo}"),
                    Text("Dia de Vencimento: ${cartao.vencimento}")
                  ],
                )));
          },
          dense: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  cartao.name!,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 45),
              Text(cartao.tipo!),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("Dia de vencimento: ${cartao.vencimento}"),
                ],
              ),
            ],
          ),
        ),
      ));
    }

    return Card(
      child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Cartões"),
              InkWell(onTap: () {}, child: const Icon(Icons.add))
            ],
          ),
          subtitle: ValueListenableBuilder(
            valueListenable: cartoesBox.listenable(),
            builder: (BuildContext context, Box<dynamic> value, Widget? child) {
              return Column(
                children: listaWidgets.isNotEmpty
                    ? listaWidgets
                    : [
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text("Sem cartões cadastrados"),
                        )
                      ],
              );
            },
          )),
    );
  }
}

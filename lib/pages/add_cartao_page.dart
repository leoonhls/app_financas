import 'package:app_financas2/objetcs/lancamento.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/add_cartao_controller.dart';

class AddCartaoPage extends GetView<AddCartaoController> {
  final Lancamento? editLancamento;
  final int? indexOfDelete;
  const AddCartaoPage({super.key, this.editLancamento, this.indexOfDelete});

  @override
  Widget build(BuildContext context) {
    Get.put(AddCartaoController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        title: Text(controller.titulo.value),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              child: CupertinoTextFormFieldRow(
                maxLength: 25,
                style: CupertinoTheme.of(context).textTheme.textStyle,
                prefix: const Text("Descrição"),
                controller: controller.tcDescricao,
                textAlign: TextAlign.end,
              ),
            ),
            Card(
              child: CupertinoTextFormFieldRow(
                maxLength: 2,
                style: CupertinoTheme.of(context).textTheme.textStyle,
                prefix: const Text("Data de Vencimento"),
                controller: controller.tcVencimento,
                textAlign: TextAlign.end,
                keyboardType: TextInputType.number,
                onChanged: (newValue) {
                  if (newValue.isEmpty) newValue = "0";

                  newValue = newValue.removeAllWhitespace
                      .replaceAll(".", "")
                      .replaceAll(",", "");
                },
              ),
            ),
            Card(
              child: CupertinoTextFormFieldRow(
                maxLength: 2,
                style: CupertinoTheme.of(context).textTheme.textStyle,
                prefix: const Text("Dias para Fechamento"),
                controller: controller.tcDiasFechamento,
                textAlign: TextAlign.end,
                keyboardType: TextInputType.number,
              ),
            ),
            Card(
              child: TextButton(
                child: const Text("Adicionar"),
                onPressed: () {
                  controller.regCartao(indexDelete: indexOfDelete);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

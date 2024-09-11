import 'package:app_financas2/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../objetcs/cartao.dart';

class AddCartaoController extends GetxController {
  RxString titulo = "Novo Cartao".obs;
  RxString valorParcelas = "".obs;
  var tcDescricao = TextEditingController(text: "");
  var tcVencimento = TextEditingController(text: "");
  var tcDiasFechamento = TextEditingController(text: "");

  regCartao({int? indexDelete}) {
    if (tcDescricao.text.isEmpty ||
        tcVencimento.text.isEmpty ||
        tcDiasFechamento.text.isEmpty) {
      Get.snackbar("Erro", "Complete todos os dados de lançamento",
          backgroundColor: Colors.red.withOpacity(0.4));
    } else {
      if (indexDelete != null) {
        lancamentosBox.deleteAt(indexDelete);
      }
      cartoesBox.delete(populaEdicaoLancamento);
      cartoesBox.add(Cartao.novo(
        name: tcDescricao.text,
        vencimento: tcVencimento.text,
        diasFechamento: tcDiasFechamento.text,
        tipo: 'Crédito',
      ));
      Get.snackbar(
        "Registrado",
        "Cartão: ${tcDescricao.text}\nVencimento: ${tcVencimento.text}\nDias anteriores para fechamento: ${tcDiasFechamento.text}",
        duration: const Duration(seconds: 5),
      );
    }
  }

  populaEdicaoLancamento(Cartao? cartao) async {
    if (cartao != null) {
      titulo.value = "Editar Cartão";
      tcDescricao.text = cartao.name!;
      tcVencimento.text = cartao.vencimento!;
      tcDiasFechamento.text = cartao.diasFechamento!;
    }
  }
}

import 'package:app_financas2/pages/add_lancamento_page.dart';
import 'package:app_financas2/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/formatador.dart';
import '../main.dart';
import '../objetcs/cartao.dart';
import '../objetcs/lancamento.dart';

class AddLancamentoController extends GetxController {
  RxBool ganho = false.obs;
  RxBool fixo = false.obs;
  RxString valorParcelas = "".obs;

  var tcDescricao = TextEditingController(text: "");
  var tcValor = TextEditingController(text: "0");
  RxDouble valorTotal = 0.0.obs;
  var tcParcelas = TextEditingController(text: "0");
  Rx<Cartao> cartaoSelecionado = Cartao().obs;
  RxInt dataSelecionada = DateTime.now().millisecondsSinceEpoch.obs;

  @override
  void onInit() {
    calculaValorParcela();
    super.onInit();
  }

  calculaValorParcela() {
    if (tcValor.text.isEmpty) tcValor.text = "0";
    if (tcParcelas.text.isEmpty) tcParcelas.text = "0";

    valorParcelas.value =
        (valorTotal.value / double.parse(tcParcelas.text)).toString();
    if (tcParcelas.text == "0") {
      valorParcelas.value = valorTotal.value.toString();
    }
  }

  regLancamento() {
    if (tcDescricao.text.isEmpty ||
        tcParcelas.text.isEmpty ||
        valorTotal.value.toString() == "0" ||
        cartaoSelecionado.value.name == null) {
      Get.snackbar("Erro", "Complete todos os dados de lançamento",
          backgroundColor: Colors.red.withOpacity(0.4));
    } else {
      lancamentosBox.add(Lancamento(
          descricao: tcDescricao.text,
          parcelas: int.parse(tcParcelas.text),
          data: dataSelecionada.value,
          valorTotal: valorTotal.value,
          cartao: cartaoSelecionado.value,
          ganho: ganho.value,
          fixo: fixo.value));
      Get.snackbar(
        "Registrado",
        "Cartão: ${cartaoSelecionado.value.name}\nDescrição: ${tcDescricao.text} em ${Formatador.milis2simpleDateTime(dataSelecionada.value, ano: true)}\nValor Total: ${Formatador.double2real(valorTotal.value)}\nParcelas: ${tcParcelas.text}x",
        duration: const Duration(seconds: 5),
      );
      Get.offAll(const MainPage());
      Get.to(const AddLancamento());
    }
  }
}

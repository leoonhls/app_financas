import 'package:app_financas2/Utils/formatador.dart';
import 'package:app_financas2/objetcs/lancamento.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scroll_wheel_date_picker/scroll_wheel_date_picker.dart';

import '../controller/add_lancamento_controller.dart';
import '../main.dart';

class AddLancamento extends GetView<AddLancamentoController> {
  const AddLancamento({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddLancamentoController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Lançamento"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                Card(
                  child: Obx(
                    () => CheckboxListTile(
                        title: const Text("Ganho"),
                        value: controller.ganho.value,
                        onChanged: (a) {
                          controller.ganho.value = a!;
                        }),
                  ),
                ),
                Card(
                  child: Obx(
                    () => CheckboxListTile(
                        title: const Text("Fixo"),
                        value: controller.fixo.value,
                        onChanged: (a) {
                          controller.fixo.value = a!;
                          controller.valorParcelas.value = "0";
                          controller.tcParcelas.text = "0";
                        }),
                  ),
                ),
                Card(
                  child: PromptedChoice<String>.single(
                    value: controller.cartaoSelecionado.value.name,
                    title: "Cartão",
                    dividerBuilder: (value) {
                      return const Divider(
                        height: 2,
                        indent: 40,
                        endIndent: 40,
                      );
                    },
                    itemCount: cartoesBox.length,
                    itemBuilder: (state, i) {
                      return InkWell(
                        child: Center(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(cartoesBox.values.elementAt(i).name)),
                        ),
                        onTap: () {
                          state.select(cartoesBox.values.elementAt(i).name);
                          controller.cartaoSelecionado.value =
                              cartoesBox.values.elementAt(i);
                        },
                      );
                    },
                    promptDelegate: ChoicePrompt.delegateBottomSheet(),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: ScrollWheelDatePicker(
                      onSelectedItemChanged: (a) {
                        controller.dataSelecionada.value =
                            a.millisecondsSinceEpoch;
                      },
                      theme: CurveDatePickerTheme(
                        overlay: ScrollWheelDatePickerOverlay.highlight,
                        overAndUnderCenterOpacity: 0.2,
                      ),
                    ),
                  ),
                ),
                Card(
                  child: CupertinoTextFormFieldRow(
                    style: CupertinoTheme.of(context).textTheme.textStyle,
                    prefix: const Text("Descrição"),
                    controller: controller.tcDescricao,
                    textAlign: TextAlign.end,
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Card(
                        child: CupertinoTextFormFieldRow(
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                          onTap: () {
                            controller.tcValor.selection =
                                TextSelection.collapsed(
                                    offset: controller.tcValor.text.length);
                          },
                          prefix: const Text("Valor"),
                          controller: controller.tcValor,
                          textAlign: TextAlign.end,
                          keyboardType: const TextInputType.numberWithOptions(),
                          onChanged: (newValue) {
                            if (newValue.isEmpty) newValue = "0";

                            controller.valorTotal.value = double.parse(newValue
                                .removeAllWhitespace
                                .replaceAll(".", "")
                                .replaceAll(",", ".")
                                .replaceAll("R\$", ""));
                            controller.calculaValorParcela();
                          },
                          inputFormatters: <TextInputFormatter>[
                            CurrencyTextInputFormatter.simpleCurrency(
                                locale: 'pt')
                          ],
                        ),
                      ),
                    ),
                    controller.fixo.value
                        ? Container()
                        : Flexible(
                            child: Card(
                              child: CupertinoTextFormFieldRow(
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .textStyle,
                                onTap: () {
                                  controller.tcParcelas.selection =
                                      TextSelection.collapsed(
                                          offset: controller
                                              .tcParcelas.text.length);
                                },
                                prefix: const Text("Parcelas"),
                                controller: controller.tcParcelas,
                                textAlign: TextAlign.end,
                                keyboardType: TextInputType.number,
                                onChanged: (newValue) {
                                  if (newValue.isNotEmpty) {
                                    controller.tcParcelas.text = newValue;
                                  } else {
                                    controller.tcParcelas.text = "0";
                                  }

                                  controller.calculaValorParcela();
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                  TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                      newValue = newValue.copyWith(
                                          text: newValue.text
                                              .replaceAll(',', '.')
                                              .replaceAll(
                                                  RegExp(r'^0+(?=.)'), ''));

                                      return newValue;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
                controller.fixo.value
                    ? Container()
                    : Card(
                        child: ListTile(
                          dense: true,
                          title: const Text("Valor por Parcela"),
                          trailing: Obx(() => Text(Formatador.double2real(
                              double.parse(controller.valorParcelas.value)))),
                        ),
                      ),
                Card(
                  child: TextButton(
                    child: const Text("Adicionar"),
                    onPressed: () {
                      controller.regLancamento();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

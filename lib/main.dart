import 'package:app_financas2/controller/main_controller.dart';
import 'package:app_financas2/objetcs/cartao.dart';
import 'package:app_financas2/objetcs/lancamento.dart';
import 'package:app_financas2/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';


late Box cartoesBox;
late Box lancamentosBox;
late Box lancamentosGanhosBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter<Cartao>(CartaoAdapter());
  Hive.registerAdapter<Lancamento>(LancamentoAdapter());



  cartoesBox = await Hive.openBox<Cartao>("cartoes");
  lancamentosBox = await Hive.openBox<Lancamento>('lancamentos');

  if (lancamentosBox.isEmpty) {
    lancamentosBox.add(Lancamento(
        descricao: "Arraste para excluir",
        parcelas: 1,
        data: DateTime.now().millisecondsSinceEpoch,
        valorTotal: 100,
        cartao: Cartao.novo(name: "Teste", tipo: "Teste", vencimento: "teste"), ganho: false, fixo: false));
  }

  await cartoesBox.clear();

  cartoesBox.addAll(<Cartao>[
    Cartao.novo(name: "Nubank", tipo: "Crédito", vencimento: "09"),
    Cartao.novo(name: "Banco do Brasil", tipo: "Crédito", vencimento: "09"),
    Cartao.novo(name: "Mercado Pago", tipo: "Crédito", vencimento: "20")
  ]);

  Get.put(MainController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(useMaterial3: true ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      title: 'Controle de Gastos',
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

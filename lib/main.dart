import 'package:app_financas2/controller/main_controller.dart';
import 'package:app_financas2/objetcs/cartao.dart';
import 'package:app_financas2/objetcs/lancamento.dart';
import 'package:app_financas2/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import necessário para localizações
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box cartoesBox;
late Box lancamentosBox;
late Box lancamentosGanhosBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  //Hive.deleteBoxFromDisk("lancamentos");

  Hive.registerAdapter<Cartao>(CartaoAdapter());
  Hive.registerAdapter<Lancamento>(LancamentoAdapter());

  cartoesBox = await Hive.openBox<Cartao>("cartoes");
  lancamentosBox = await Hive.openBox<Lancamento>('lancamentos');

  if (lancamentosBox.isEmpty) {
    lancamentosBox.add(Lancamento(
        descricao: "Segure para excluir",
        parcelas: 1,
        data: DateTime.now().millisecondsSinceEpoch,
        valorTotal: 100,
        cartao: Cartao.novo(
            name: "Teste",
            tipo: "Teste",
            vencimento: "9",
            diasFechamento: "15"),
        ganho: false,
        fixo: false,
        moduloFaturaInclusa: 0));
  }

  await cartoesBox.clear();

  cartoesBox.addAll(<Cartao>[
    Cartao.novo(
        name: "Nubank", tipo: "Crédito", vencimento: "09", diasFechamento: "7"),
    Cartao.novo(
        name: "Banco do Brasil",
        tipo: "Crédito",
        vencimento: "09",
        diasFechamento: "15"),
    Cartao.novo(
        name: "Mercado Pago",
        tipo: "Crédito",
        vencimento: "20",
        diasFechamento: "7")
  ]);

  Get.put(MainController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Define o local padrão como português do Brasil
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('pt', 'PT'),
      ],
      fallbackLocale: const Locale('pt', 'BR'),
      // Adiciona os delegados de localização para resolver o erro
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData.dark(useMaterial3: true),
      title: 'Controle de Gastos',
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

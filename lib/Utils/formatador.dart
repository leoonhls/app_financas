import 'package:intl/intl.dart';

class Formatador {

  static String double2real(double input,
      {String? symbol = 'R\$', String? moeda = 'Real'}) {
    final formatCurrency =
    NumberFormat.currency(locale: 'pt-br', name: moeda, symbol: symbol);
    return formatCurrency.format(input);
  }

  static String milis2simpleDateTime(int time, {ano = false}) {
    var formato = DateFormat('dd/MM${ano ? "/yyyy" : ""}');
    var date = DateTime.fromMillisecondsSinceEpoch(time);
    return formato.format(date);
  }

}


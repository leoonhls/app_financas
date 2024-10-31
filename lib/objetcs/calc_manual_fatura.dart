import 'package:hive/hive.dart';

import 'cartao.dart';

part 'calc_manual_fatura.g.dart';

@HiveType(typeId: 3)
class CalcManualFatura extends HiveObject {
  @HiveField(0)
  int? data;

  @HiveField(1)
  double? valor;

  @HiveField(2)
  Cartao? cartao;

  CalcManualFatura();

  CalcManualFatura.novo({
    required this.data,
    required this.valor,
    required this.cartao,
  });
}

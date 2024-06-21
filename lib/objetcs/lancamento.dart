import 'package:hive/hive.dart';

import 'cartao.dart';

part 'lancamento.g.dart';

@HiveType(typeId: 2)
class Lancamento {
  Lancamento({
    required this.descricao,
    required this.parcelas,
    required this.data,
    required this.valorTotal,
    required this.cartao,
    required this.ganho,
    required this.fixo,
  });

  @HiveField(0)
  String descricao;

  @HiveField(1)
  int parcelas;

  @HiveField(2)
  int data;

  @HiveField(3)
  double valorTotal;

  @HiveField(4)
  Cartao cartao;

  @HiveField(5)
  bool ganho;

  @HiveField(6)
  bool fixo;

}

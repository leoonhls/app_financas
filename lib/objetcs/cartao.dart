import 'package:hive/hive.dart';

part 'cartao.g.dart';

@HiveType(typeId: 1)
class Cartao extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? tipo;

  @HiveField(2)
  String? vencimento;

  Cartao();

  Cartao.novo({
    required this.name,
    required this.tipo,
    required this.vencimento,
  });
}

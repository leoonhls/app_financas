// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartao.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartaoAdapter extends TypeAdapter<Cartao> {
  @override
  final int typeId = 1;

  @override
  Cartao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cartao()
      ..name = fields[0] as String?
      ..tipo = fields[1] as String?
      ..vencimento = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, Cartao obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.tipo)
      ..writeByte(2)
      ..write(obj.vencimento);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

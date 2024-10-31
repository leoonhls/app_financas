// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calc_manual_fatura.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalcManualFaturaAdapter extends TypeAdapter<CalcManualFatura> {
  @override
  final int typeId = 3;

  @override
  CalcManualFatura read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalcManualFatura()
      ..data = fields[0] as int?
      ..valor = fields[1] as double?
      ..cartao = fields[2] as Cartao?;
  }

  @override
  void write(BinaryWriter writer, CalcManualFatura obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.valor)
      ..writeByte(2)
      ..write(obj.cartao);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalcManualFaturaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

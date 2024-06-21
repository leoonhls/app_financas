// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lancamento.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LancamentoAdapter extends TypeAdapter<Lancamento> {
  @override
  final int typeId = 2;

  @override
  Lancamento read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lancamento(
      descricao: fields[0] as String,
      parcelas: fields[1] as int,
      data: fields[2] as int,
      valorTotal: fields[3] as double,
      cartao: fields[4] as Cartao,
      ganho: fields[5] as bool,
      fixo: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Lancamento obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.descricao)
      ..writeByte(1)
      ..write(obj.parcelas)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.valorTotal)
      ..writeByte(4)
      ..write(obj.cartao)
      ..writeByte(5)
      ..write(obj.ganho)
      ..writeByte(6)
      ..write(obj.fixo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LancamentoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductionAdapter extends TypeAdapter<Production> {
  @override
  final int typeId = 2;

  @override
  Production read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Production(
      id: fields[0] as String?,
      date: fields[1] as DateTime?,
      productName: fields[2] as String,
      materialQuantities: (fields[3] as Map).cast<String, double>(),
      processHours: (fields[4] as Map).cast<String, double>(),
      desiredMargin: fields[5] as double,
      status: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Production obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.materialQuantities)
      ..writeByte(4)
      ..write(obj.processHours)
      ..writeByte(5)
      ..write(obj.desiredMargin)
      ..writeByte(6)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

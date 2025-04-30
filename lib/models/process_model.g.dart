// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ManufacturingProcessAdapter extends TypeAdapter<ManufacturingProcess> {
  @override
  final int typeId = 1;

  @override
  ManufacturingProcess read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ManufacturingProcess(
      id: fields[0] as String?,
      name: fields[1] as String,
      laborCostPerHour: fields[2] as double,
      energyCostPerHour: fields[3] as double,
      otherCostsPerHour: fields[4] as double,
      description: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ManufacturingProcess obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.laborCostPerHour)
      ..writeByte(3)
      ..write(obj.energyCostPerHour)
      ..writeByte(4)
      ..write(obj.otherCostsPerHour)
      ..writeByte(5)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManufacturingProcessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_ward_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuranWardAdapter extends TypeAdapter<QuranWard> {
  @override
  final int typeId = 1;

  @override
  QuranWard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuranWard(
      dailyReadPages: fields[0] as int,
      dailyMemorizeAyat: fields[1] as int,
      currentReadPage: fields[2] as int,
      currentMemorizedAyah: fields[3] as int,
      lastUpdated: fields[4] as DateTime,
      readSurahName: fields[5] as String,
      memorizeSurahName: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuranWard obj) {
    writer
      ..writeByte(7) // ← عدد الحقول الجديدة
      ..writeByte(0)
      ..write(obj.dailyReadPages)
      ..writeByte(1)
      ..write(obj.dailyMemorizeAyat)
      ..writeByte(2)
      ..write(obj.currentReadPage)
      ..writeByte(3)
      ..write(obj.currentMemorizedAyah)
      ..writeByte(4)
      ..write(obj.lastUpdated)
      ..writeByte(5)
      ..write(obj.readSurahName)
      ..writeByte(6)
      ..write(obj.memorizeSurahName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranWardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

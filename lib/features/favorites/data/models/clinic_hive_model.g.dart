part of 'clinic_hive_model.dart';

class ClinicHiveModelAdapter extends TypeAdapter<ClinicHiveModel> {
  @override
  final int typeId = 1;

  @override
  ClinicHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClinicHiveModel(
      clinicId: fields[0] as String,
      clinicName: fields[1] as String,
      clinicLogoUrl: fields[2] as String,
      clinicDescription: fields[3] as String,
      clinicLocation: fields[4] as String,
      clinicAverageRating: fields[5] as double,
      clinicRatingCount: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ClinicHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.clinicId)
      ..writeByte(1)
      ..write(obj.clinicName)
      ..writeByte(2)
      ..write(obj.clinicLogoUrl)
      ..writeByte(3)
      ..write(obj.clinicDescription)
      ..writeByte(4)
      ..write(obj.clinicLocation)
      ..writeByte(5)
      ..write(obj.clinicAverageRating)
      ..writeByte(6)
      ..write(obj.clinicRatingCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClinicHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

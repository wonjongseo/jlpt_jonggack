// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_word.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyWordAdapter extends TypeAdapter<MyWord> {
  @override
  final int typeId = 1;

  @override
  MyWord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyWord(
      word: fields[0] as String,
      mean: fields[1] as String,
      yomikata: fields[3] as String?,
      examples: (fields[6] as List?)?.cast<Example>(),
      isManuelSave: fields[5] as bool?,
      isGrammar: fields[7] == null ? false : fields[7] as bool,
      connectionWays: fields[8] as String?,
      description: fields[9] as String?,
    )
      ..isKnown = fields[2] as bool
      ..createdAt = fields[4] as DateTime?
      ..category = fields[10] as BookCategory?;
  }

  @override
  void write(BinaryWriter writer, MyWord obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.mean)
      ..writeByte(3)
      ..write(obj.yomikata)
      ..writeByte(2)
      ..write(obj.isKnown)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.isManuelSave)
      ..writeByte(6)
      ..write(obj.examples)
      ..writeByte(7)
      ..write(obj.isGrammar)
      ..writeByte(8)
      ..write(obj.connectionWays)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyWordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

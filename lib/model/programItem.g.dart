// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'programItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgramItem _$ProgramItemFromJson(Map<String, dynamic> json) {
  return ProgramItem()
    ..award = json['award'] as String
    ..title = json['title'] as String
    ..year = json['year'] as String
    ..campus = json['campus'] as String;
}

Map<String, dynamic> _$ProgramItemToJson(ProgramItem instance) =>
    <String, dynamic>{
      'award': instance.award,
      'title': instance.title,
      'year': instance.year,
      'campus': instance.campus,
    };

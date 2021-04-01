// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedModel _$FeedModelFromJson(Map<String, dynamic> json) {
  return FeedModel()
    ..post_id = json['post_id'] as String
    ..description = json['description'] as String
    ..post_by = json['post_by'] as String
    ..view_count = json['view_count'] as String
    ..createdAt = json['createdAt'] as String
    ..post_thumbnail_small = json['post_thumbnail_small'] as String
    ..post_thumbnail = json['post_thumbnail'] as String
    ..post_category = json['post_category'] as String
    ..tags = json['tags'] as String;
}

Map<String, dynamic> _$FeedModelToJson(FeedModel instance) => <String, dynamic>{
      'post_id': instance.post_id,
      'description': instance.description,
      'post_by': instance.post_by,
      'view_count': instance.view_count,
      'createdAt': instance.createdAt,
      'post_thumbnail_small': instance.post_thumbnail_small,
      'post_thumbnail': instance.post_thumbnail,
      'post_category': instance.post_category,
      'tags': instance.tags,
    };

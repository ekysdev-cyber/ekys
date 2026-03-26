// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContentItemModelImpl _$$ContentItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$ContentItemModelImpl(
  id: json['id'] as String,
  subtopicId: json['subtopicId'] as String,
  type: json['type'] as String,
  title: json['title'] as String,
  bodyMd: json['bodyMd'] as String?,
  frontText: json['frontText'] as String?,
  audioUrl: json['audioUrl'] as String?,
  durationSec: (json['durationSec'] as num?)?.toInt(),
  difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
  orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$$ContentItemModelImplToJson(
  _$ContentItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'subtopicId': instance.subtopicId,
  'type': instance.type,
  'title': instance.title,
  'bodyMd': instance.bodyMd,
  'frontText': instance.frontText,
  'audioUrl': instance.audioUrl,
  'durationSec': instance.durationSec,
  'difficulty': instance.difficulty,
  'orderIndex': instance.orderIndex,
  'tags': instance.tags,
};

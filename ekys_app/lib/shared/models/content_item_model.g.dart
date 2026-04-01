// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContentItemModelImpl _$$ContentItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$ContentItemModelImpl(
  id: json['id'] as String,
  subtopicId: json['subtopic_id'] as String,
  type: json['type'] as String,
  title: json['title'] as String,
  bodyMd: json['body_md'] as String?,
  frontText: json['front_text'] as String?,
  audioUrl: json['audio_url'] as String?,
  durationSec: (json['duration_sec'] as num?)?.toInt(),
  difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
  orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$$ContentItemModelImplToJson(
  _$ContentItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'subtopic_id': instance.subtopicId,
  'type': instance.type,
  'title': instance.title,
  'body_md': instance.bodyMd,
  'front_text': instance.frontText,
  'audio_url': instance.audioUrl,
  'duration_sec': instance.durationSec,
  'difficulty': instance.difficulty,
  'order_index': instance.orderIndex,
  'tags': instance.tags,
};

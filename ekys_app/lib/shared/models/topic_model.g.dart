// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TopicModelImpl _$$TopicModelImplFromJson(Map<String, dynamic> json) =>
    _$TopicModelImpl(
      id: json['id'] as String,
      parentId: json['parent_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
      subtopics:
          (json['subtopics'] as List<dynamic>?)
              ?.map((e) => SubtopicModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TopicModelImplToJson(_$TopicModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
      'order_index': instance.orderIndex,
      'subtopics': instance.subtopics,
    };

_$SubtopicModelImpl _$$SubtopicModelImplFromJson(Map<String, dynamic> json) =>
    _$SubtopicModelImpl(
      id: json['id'] as String,
      topicId: json['topic_id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$SubtopicModelImplToJson(_$SubtopicModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topic_id': instance.topicId,
      'title': instance.title,
      'slug': instance.slug,
      'order_index': instance.orderIndex,
    };

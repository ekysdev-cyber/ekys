// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TopicModelImpl _$$TopicModelImplFromJson(Map<String, dynamic> json) =>
    _$TopicModelImpl(
      id: json['id'] as String,
      parentId: json['parentId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
      subtopics:
          (json['subtopics'] as List<dynamic>?)
              ?.map((e) => SubtopicModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TopicModelImplToJson(_$TopicModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
      'orderIndex': instance.orderIndex,
      'subtopics': instance.subtopics,
    };

_$SubtopicModelImpl _$$SubtopicModelImplFromJson(Map<String, dynamic> json) =>
    _$SubtopicModelImpl(
      id: json['id'] as String,
      topicId: json['topicId'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$SubtopicModelImplToJson(_$SubtopicModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topicId': instance.topicId,
      'title': instance.title,
      'slug': instance.slug,
      'orderIndex': instance.orderIndex,
    };

import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_model.freezed.dart';
part 'topic_model.g.dart';

@freezed
class TopicModel with _$TopicModel {
  const factory TopicModel({
    required String id,
    String? parentId,
    required String title,
    String? description,
    String? icon,
    @Default(0) int orderIndex,
    @Default([]) List<SubtopicModel> subtopics,
  }) = _TopicModel;

  factory TopicModel.fromJson(Map<String, dynamic> json) =>
      _$TopicModelFromJson(json);
}

@freezed
class SubtopicModel with _$SubtopicModel {
  const factory SubtopicModel({
    required String id,
    required String topicId,
    required String title,
    required String slug,
    @Default(0) int orderIndex,
  }) = _SubtopicModel;

  factory SubtopicModel.fromJson(Map<String, dynamic> json) =>
      _$SubtopicModelFromJson(json);
}

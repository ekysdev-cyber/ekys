import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_item_model.freezed.dart';
part 'content_item_model.g.dart';

@freezed
class ContentItemModel with _$ContentItemModel {
  const factory ContentItemModel({
    required String id,
    @JsonKey(name: 'subtopic_id') required String subtopicId,
    required String type, // 'summary', 'flashcard', 'audio_note'
    required String title,
    @JsonKey(name: 'body_md') String? bodyMd,
    @JsonKey(name: 'front_text') String? frontText,
    @JsonKey(name: 'audio_url') String? audioUrl,
    @JsonKey(name: 'duration_sec') int? durationSec,
    @Default(1) int difficulty,
    @JsonKey(name: 'order_index') @Default(0) int orderIndex,
    @Default([]) List<String> tags,
  }) = _ContentItemModel;

  factory ContentItemModel.fromJson(Map<String, dynamic> json) =>
      _$ContentItemModelFromJson(json);
}

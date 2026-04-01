import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    required String id,
    @JsonKey(name: 'subtopic_id') required String subtopicId,
    @JsonKey(name: 'question_text') required String questionText,
    required List<OptionModel> options,
    @JsonKey(name: 'correct_index') required int correctIndex,
    String? explanation,
    @Default(1) int difficulty,
    String? source,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}

@freezed
class OptionModel with _$OptionModel {
  const factory OptionModel({
    required String label,
    required String text,
  }) = _OptionModel;

  factory OptionModel.fromJson(Map<String, dynamic> json) =>
      _$OptionModelFromJson(json);
}

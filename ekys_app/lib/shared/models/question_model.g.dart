// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionModelImpl _$$QuestionModelImplFromJson(Map<String, dynamic> json) =>
    _$QuestionModelImpl(
      id: json['id'] as String,
      subtopicId: json['subtopic_id'] as String,
      questionText: json['question_text'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => OptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      correctIndex: (json['correct_index'] as num).toInt(),
      explanation: json['explanation'] as String?,
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      source: json['source'] as String?,
    );

Map<String, dynamic> _$$QuestionModelImplToJson(_$QuestionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subtopic_id': instance.subtopicId,
      'question_text': instance.questionText,
      'options': instance.options,
      'correct_index': instance.correctIndex,
      'explanation': instance.explanation,
      'difficulty': instance.difficulty,
      'source': instance.source,
    };

_$OptionModelImpl _$$OptionModelImplFromJson(Map<String, dynamic> json) =>
    _$OptionModelImpl(
      label: json['label'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$$OptionModelImplToJson(_$OptionModelImpl instance) =>
    <String, dynamic>{'label': instance.label, 'text': instance.text};

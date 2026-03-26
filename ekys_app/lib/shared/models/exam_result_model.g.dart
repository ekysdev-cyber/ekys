// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExamResultModelImpl _$$ExamResultModelImplFromJson(
  Map<String, dynamic> json,
) => _$ExamResultModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  examId: json['examId'] as String,
  answers: Map<String, int?>.from(json['answers'] as Map),
  score: (json['score'] as num).toDouble(),
  correctCt: (json['correctCt'] as num).toInt(),
  wrongCt: (json['wrongCt'] as num).toInt(),
  emptyCt: (json['emptyCt'] as num).toInt(),
  durationS: (json['durationS'] as num).toInt(),
  takenAt: json['takenAt'] == null
      ? null
      : DateTime.parse(json['takenAt'] as String),
);

Map<String, dynamic> _$$ExamResultModelImplToJson(
  _$ExamResultModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'examId': instance.examId,
  'answers': instance.answers,
  'score': instance.score,
  'correctCt': instance.correctCt,
  'wrongCt': instance.wrongCt,
  'emptyCt': instance.emptyCt,
  'durationS': instance.durationS,
  'takenAt': instance.takenAt?.toIso8601String(),
};

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam_result_model.freezed.dart';
part 'exam_result_model.g.dart';

@freezed
class ExamResultModel with _$ExamResultModel {
  const factory ExamResultModel({
    required String id,
    required String userId,
    required String examId,
    required Map<String, int?> answers,
    required double score,
    required int correctCt,
    required int wrongCt,
    required int emptyCt,
    required int durationS,
    DateTime? takenAt,
  }) = _ExamResultModel;

  factory ExamResultModel.fromJson(Map<String, dynamic> json) =>
      _$ExamResultModelFromJson(json);
}

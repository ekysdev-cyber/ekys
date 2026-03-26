// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExamResultModel _$ExamResultModelFromJson(Map<String, dynamic> json) {
  return _ExamResultModel.fromJson(json);
}

/// @nodoc
mixin _$ExamResultModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get examId => throw _privateConstructorUsedError;
  Map<String, int?> get answers => throw _privateConstructorUsedError;
  double get score => throw _privateConstructorUsedError;
  int get correctCt => throw _privateConstructorUsedError;
  int get wrongCt => throw _privateConstructorUsedError;
  int get emptyCt => throw _privateConstructorUsedError;
  int get durationS => throw _privateConstructorUsedError;
  DateTime? get takenAt => throw _privateConstructorUsedError;

  /// Serializes this ExamResultModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExamResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExamResultModelCopyWith<ExamResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamResultModelCopyWith<$Res> {
  factory $ExamResultModelCopyWith(
    ExamResultModel value,
    $Res Function(ExamResultModel) then,
  ) = _$ExamResultModelCopyWithImpl<$Res, ExamResultModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String examId,
    Map<String, int?> answers,
    double score,
    int correctCt,
    int wrongCt,
    int emptyCt,
    int durationS,
    DateTime? takenAt,
  });
}

/// @nodoc
class _$ExamResultModelCopyWithImpl<$Res, $Val extends ExamResultModel>
    implements $ExamResultModelCopyWith<$Res> {
  _$ExamResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExamResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? examId = null,
    Object? answers = null,
    Object? score = null,
    Object? correctCt = null,
    Object? wrongCt = null,
    Object? emptyCt = null,
    Object? durationS = null,
    Object? takenAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            examId: null == examId
                ? _value.examId
                : examId // ignore: cast_nullable_to_non_nullable
                      as String,
            answers: null == answers
                ? _value.answers
                : answers // ignore: cast_nullable_to_non_nullable
                      as Map<String, int?>,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as double,
            correctCt: null == correctCt
                ? _value.correctCt
                : correctCt // ignore: cast_nullable_to_non_nullable
                      as int,
            wrongCt: null == wrongCt
                ? _value.wrongCt
                : wrongCt // ignore: cast_nullable_to_non_nullable
                      as int,
            emptyCt: null == emptyCt
                ? _value.emptyCt
                : emptyCt // ignore: cast_nullable_to_non_nullable
                      as int,
            durationS: null == durationS
                ? _value.durationS
                : durationS // ignore: cast_nullable_to_non_nullable
                      as int,
            takenAt: freezed == takenAt
                ? _value.takenAt
                : takenAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExamResultModelImplCopyWith<$Res>
    implements $ExamResultModelCopyWith<$Res> {
  factory _$$ExamResultModelImplCopyWith(
    _$ExamResultModelImpl value,
    $Res Function(_$ExamResultModelImpl) then,
  ) = __$$ExamResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String examId,
    Map<String, int?> answers,
    double score,
    int correctCt,
    int wrongCt,
    int emptyCt,
    int durationS,
    DateTime? takenAt,
  });
}

/// @nodoc
class __$$ExamResultModelImplCopyWithImpl<$Res>
    extends _$ExamResultModelCopyWithImpl<$Res, _$ExamResultModelImpl>
    implements _$$ExamResultModelImplCopyWith<$Res> {
  __$$ExamResultModelImplCopyWithImpl(
    _$ExamResultModelImpl _value,
    $Res Function(_$ExamResultModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExamResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? examId = null,
    Object? answers = null,
    Object? score = null,
    Object? correctCt = null,
    Object? wrongCt = null,
    Object? emptyCt = null,
    Object? durationS = null,
    Object? takenAt = freezed,
  }) {
    return _then(
      _$ExamResultModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        examId: null == examId
            ? _value.examId
            : examId // ignore: cast_nullable_to_non_nullable
                  as String,
        answers: null == answers
            ? _value._answers
            : answers // ignore: cast_nullable_to_non_nullable
                  as Map<String, int?>,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double,
        correctCt: null == correctCt
            ? _value.correctCt
            : correctCt // ignore: cast_nullable_to_non_nullable
                  as int,
        wrongCt: null == wrongCt
            ? _value.wrongCt
            : wrongCt // ignore: cast_nullable_to_non_nullable
                  as int,
        emptyCt: null == emptyCt
            ? _value.emptyCt
            : emptyCt // ignore: cast_nullable_to_non_nullable
                  as int,
        durationS: null == durationS
            ? _value.durationS
            : durationS // ignore: cast_nullable_to_non_nullable
                  as int,
        takenAt: freezed == takenAt
            ? _value.takenAt
            : takenAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExamResultModelImpl implements _ExamResultModel {
  const _$ExamResultModelImpl({
    required this.id,
    required this.userId,
    required this.examId,
    required final Map<String, int?> answers,
    required this.score,
    required this.correctCt,
    required this.wrongCt,
    required this.emptyCt,
    required this.durationS,
    this.takenAt,
  }) : _answers = answers;

  factory _$ExamResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamResultModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String examId;
  final Map<String, int?> _answers;
  @override
  Map<String, int?> get answers {
    if (_answers is EqualUnmodifiableMapView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_answers);
  }

  @override
  final double score;
  @override
  final int correctCt;
  @override
  final int wrongCt;
  @override
  final int emptyCt;
  @override
  final int durationS;
  @override
  final DateTime? takenAt;

  @override
  String toString() {
    return 'ExamResultModel(id: $id, userId: $userId, examId: $examId, answers: $answers, score: $score, correctCt: $correctCt, wrongCt: $wrongCt, emptyCt: $emptyCt, durationS: $durationS, takenAt: $takenAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamResultModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.examId, examId) || other.examId == examId) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.correctCt, correctCt) ||
                other.correctCt == correctCt) &&
            (identical(other.wrongCt, wrongCt) || other.wrongCt == wrongCt) &&
            (identical(other.emptyCt, emptyCt) || other.emptyCt == emptyCt) &&
            (identical(other.durationS, durationS) ||
                other.durationS == durationS) &&
            (identical(other.takenAt, takenAt) || other.takenAt == takenAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    examId,
    const DeepCollectionEquality().hash(_answers),
    score,
    correctCt,
    wrongCt,
    emptyCt,
    durationS,
    takenAt,
  );

  /// Create a copy of ExamResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamResultModelImplCopyWith<_$ExamResultModelImpl> get copyWith =>
      __$$ExamResultModelImplCopyWithImpl<_$ExamResultModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamResultModelImplToJson(this);
  }
}

abstract class _ExamResultModel implements ExamResultModel {
  const factory _ExamResultModel({
    required final String id,
    required final String userId,
    required final String examId,
    required final Map<String, int?> answers,
    required final double score,
    required final int correctCt,
    required final int wrongCt,
    required final int emptyCt,
    required final int durationS,
    final DateTime? takenAt,
  }) = _$ExamResultModelImpl;

  factory _ExamResultModel.fromJson(Map<String, dynamic> json) =
      _$ExamResultModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get examId;
  @override
  Map<String, int?> get answers;
  @override
  double get score;
  @override
  int get correctCt;
  @override
  int get wrongCt;
  @override
  int get emptyCt;
  @override
  int get durationS;
  @override
  DateTime? get takenAt;

  /// Create a copy of ExamResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExamResultModelImplCopyWith<_$ExamResultModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

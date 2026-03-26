// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ContentItemModel _$ContentItemModelFromJson(Map<String, dynamic> json) {
  return _ContentItemModel.fromJson(json);
}

/// @nodoc
mixin _$ContentItemModel {
  String get id => throw _privateConstructorUsedError;
  String get subtopicId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'summary', 'flashcard', 'audio_note'
  String get title => throw _privateConstructorUsedError;
  String? get bodyMd => throw _privateConstructorUsedError;
  String? get frontText => throw _privateConstructorUsedError;
  String? get audioUrl => throw _privateConstructorUsedError;
  int? get durationSec => throw _privateConstructorUsedError;
  int get difficulty => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  /// Serializes this ContentItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContentItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentItemModelCopyWith<ContentItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentItemModelCopyWith<$Res> {
  factory $ContentItemModelCopyWith(
    ContentItemModel value,
    $Res Function(ContentItemModel) then,
  ) = _$ContentItemModelCopyWithImpl<$Res, ContentItemModel>;
  @useResult
  $Res call({
    String id,
    String subtopicId,
    String type,
    String title,
    String? bodyMd,
    String? frontText,
    String? audioUrl,
    int? durationSec,
    int difficulty,
    int orderIndex,
    List<String> tags,
  });
}

/// @nodoc
class _$ContentItemModelCopyWithImpl<$Res, $Val extends ContentItemModel>
    implements $ContentItemModelCopyWith<$Res> {
  _$ContentItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContentItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subtopicId = null,
    Object? type = null,
    Object? title = null,
    Object? bodyMd = freezed,
    Object? frontText = freezed,
    Object? audioUrl = freezed,
    Object? durationSec = freezed,
    Object? difficulty = null,
    Object? orderIndex = null,
    Object? tags = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            subtopicId: null == subtopicId
                ? _value.subtopicId
                : subtopicId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            bodyMd: freezed == bodyMd
                ? _value.bodyMd
                : bodyMd // ignore: cast_nullable_to_non_nullable
                      as String?,
            frontText: freezed == frontText
                ? _value.frontText
                : frontText // ignore: cast_nullable_to_non_nullable
                      as String?,
            audioUrl: freezed == audioUrl
                ? _value.audioUrl
                : audioUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            durationSec: freezed == durationSec
                ? _value.durationSec
                : durationSec // ignore: cast_nullable_to_non_nullable
                      as int?,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as int,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContentItemModelImplCopyWith<$Res>
    implements $ContentItemModelCopyWith<$Res> {
  factory _$$ContentItemModelImplCopyWith(
    _$ContentItemModelImpl value,
    $Res Function(_$ContentItemModelImpl) then,
  ) = __$$ContentItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String subtopicId,
    String type,
    String title,
    String? bodyMd,
    String? frontText,
    String? audioUrl,
    int? durationSec,
    int difficulty,
    int orderIndex,
    List<String> tags,
  });
}

/// @nodoc
class __$$ContentItemModelImplCopyWithImpl<$Res>
    extends _$ContentItemModelCopyWithImpl<$Res, _$ContentItemModelImpl>
    implements _$$ContentItemModelImplCopyWith<$Res> {
  __$$ContentItemModelImplCopyWithImpl(
    _$ContentItemModelImpl _value,
    $Res Function(_$ContentItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContentItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subtopicId = null,
    Object? type = null,
    Object? title = null,
    Object? bodyMd = freezed,
    Object? frontText = freezed,
    Object? audioUrl = freezed,
    Object? durationSec = freezed,
    Object? difficulty = null,
    Object? orderIndex = null,
    Object? tags = null,
  }) {
    return _then(
      _$ContentItemModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        subtopicId: null == subtopicId
            ? _value.subtopicId
            : subtopicId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        bodyMd: freezed == bodyMd
            ? _value.bodyMd
            : bodyMd // ignore: cast_nullable_to_non_nullable
                  as String?,
        frontText: freezed == frontText
            ? _value.frontText
            : frontText // ignore: cast_nullable_to_non_nullable
                  as String?,
        audioUrl: freezed == audioUrl
            ? _value.audioUrl
            : audioUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        durationSec: freezed == durationSec
            ? _value.durationSec
            : durationSec // ignore: cast_nullable_to_non_nullable
                  as int?,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as int,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentItemModelImpl implements _ContentItemModel {
  const _$ContentItemModelImpl({
    required this.id,
    required this.subtopicId,
    required this.type,
    required this.title,
    this.bodyMd,
    this.frontText,
    this.audioUrl,
    this.durationSec,
    this.difficulty = 1,
    this.orderIndex = 0,
    final List<String> tags = const [],
  }) : _tags = tags;

  factory _$ContentItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentItemModelImplFromJson(json);

  @override
  final String id;
  @override
  final String subtopicId;
  @override
  final String type;
  // 'summary', 'flashcard', 'audio_note'
  @override
  final String title;
  @override
  final String? bodyMd;
  @override
  final String? frontText;
  @override
  final String? audioUrl;
  @override
  final int? durationSec;
  @override
  @JsonKey()
  final int difficulty;
  @override
  @JsonKey()
  final int orderIndex;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'ContentItemModel(id: $id, subtopicId: $subtopicId, type: $type, title: $title, bodyMd: $bodyMd, frontText: $frontText, audioUrl: $audioUrl, durationSec: $durationSec, difficulty: $difficulty, orderIndex: $orderIndex, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.subtopicId, subtopicId) ||
                other.subtopicId == subtopicId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.bodyMd, bodyMd) || other.bodyMd == bodyMd) &&
            (identical(other.frontText, frontText) ||
                other.frontText == frontText) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl) &&
            (identical(other.durationSec, durationSec) ||
                other.durationSec == durationSec) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    subtopicId,
    type,
    title,
    bodyMd,
    frontText,
    audioUrl,
    durationSec,
    difficulty,
    orderIndex,
    const DeepCollectionEquality().hash(_tags),
  );

  /// Create a copy of ContentItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentItemModelImplCopyWith<_$ContentItemModelImpl> get copyWith =>
      __$$ContentItemModelImplCopyWithImpl<_$ContentItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentItemModelImplToJson(this);
  }
}

abstract class _ContentItemModel implements ContentItemModel {
  const factory _ContentItemModel({
    required final String id,
    required final String subtopicId,
    required final String type,
    required final String title,
    final String? bodyMd,
    final String? frontText,
    final String? audioUrl,
    final int? durationSec,
    final int difficulty,
    final int orderIndex,
    final List<String> tags,
  }) = _$ContentItemModelImpl;

  factory _ContentItemModel.fromJson(Map<String, dynamic> json) =
      _$ContentItemModelImpl.fromJson;

  @override
  String get id;
  @override
  String get subtopicId;
  @override
  String get type; // 'summary', 'flashcard', 'audio_note'
  @override
  String get title;
  @override
  String? get bodyMd;
  @override
  String? get frontText;
  @override
  String? get audioUrl;
  @override
  int? get durationSec;
  @override
  int get difficulty;
  @override
  int get orderIndex;
  @override
  List<String> get tags;

  /// Create a copy of ContentItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentItemModelImplCopyWith<_$ContentItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TopicModel _$TopicModelFromJson(Map<String, dynamic> json) {
  return _TopicModel.fromJson(json);
}

/// @nodoc
mixin _$TopicModel {
  String get id => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;
  List<SubtopicModel> get subtopics => throw _privateConstructorUsedError;

  /// Serializes this TopicModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopicModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopicModelCopyWith<TopicModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicModelCopyWith<$Res> {
  factory $TopicModelCopyWith(
    TopicModel value,
    $Res Function(TopicModel) then,
  ) = _$TopicModelCopyWithImpl<$Res, TopicModel>;
  @useResult
  $Res call({
    String id,
    String? parentId,
    String title,
    String? description,
    String? icon,
    int orderIndex,
    List<SubtopicModel> subtopics,
  });
}

/// @nodoc
class _$TopicModelCopyWithImpl<$Res, $Val extends TopicModel>
    implements $TopicModelCopyWith<$Res> {
  _$TopicModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopicModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? orderIndex = null,
    Object? subtopics = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            subtopics: null == subtopics
                ? _value.subtopics
                : subtopics // ignore: cast_nullable_to_non_nullable
                      as List<SubtopicModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TopicModelImplCopyWith<$Res>
    implements $TopicModelCopyWith<$Res> {
  factory _$$TopicModelImplCopyWith(
    _$TopicModelImpl value,
    $Res Function(_$TopicModelImpl) then,
  ) = __$$TopicModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? parentId,
    String title,
    String? description,
    String? icon,
    int orderIndex,
    List<SubtopicModel> subtopics,
  });
}

/// @nodoc
class __$$TopicModelImplCopyWithImpl<$Res>
    extends _$TopicModelCopyWithImpl<$Res, _$TopicModelImpl>
    implements _$$TopicModelImplCopyWith<$Res> {
  __$$TopicModelImplCopyWithImpl(
    _$TopicModelImpl _value,
    $Res Function(_$TopicModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopicModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? orderIndex = null,
    Object? subtopics = null,
  }) {
    return _then(
      _$TopicModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        subtopics: null == subtopics
            ? _value._subtopics
            : subtopics // ignore: cast_nullable_to_non_nullable
                  as List<SubtopicModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicModelImpl implements _TopicModel {
  const _$TopicModelImpl({
    required this.id,
    this.parentId,
    required this.title,
    this.description,
    this.icon,
    this.orderIndex = 0,
    final List<SubtopicModel> subtopics = const [],
  }) : _subtopics = subtopics;

  factory _$TopicModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicModelImplFromJson(json);

  @override
  final String id;
  @override
  final String? parentId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? icon;
  @override
  @JsonKey()
  final int orderIndex;
  final List<SubtopicModel> _subtopics;
  @override
  @JsonKey()
  List<SubtopicModel> get subtopics {
    if (_subtopics is EqualUnmodifiableListView) return _subtopics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subtopics);
  }

  @override
  String toString() {
    return 'TopicModel(id: $id, parentId: $parentId, title: $title, description: $description, icon: $icon, orderIndex: $orderIndex, subtopics: $subtopics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            const DeepCollectionEquality().equals(
              other._subtopics,
              _subtopics,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    parentId,
    title,
    description,
    icon,
    orderIndex,
    const DeepCollectionEquality().hash(_subtopics),
  );

  /// Create a copy of TopicModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicModelImplCopyWith<_$TopicModelImpl> get copyWith =>
      __$$TopicModelImplCopyWithImpl<_$TopicModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicModelImplToJson(this);
  }
}

abstract class _TopicModel implements TopicModel {
  const factory _TopicModel({
    required final String id,
    final String? parentId,
    required final String title,
    final String? description,
    final String? icon,
    final int orderIndex,
    final List<SubtopicModel> subtopics,
  }) = _$TopicModelImpl;

  factory _TopicModel.fromJson(Map<String, dynamic> json) =
      _$TopicModelImpl.fromJson;

  @override
  String get id;
  @override
  String? get parentId;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get icon;
  @override
  int get orderIndex;
  @override
  List<SubtopicModel> get subtopics;

  /// Create a copy of TopicModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicModelImplCopyWith<_$TopicModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubtopicModel _$SubtopicModelFromJson(Map<String, dynamic> json) {
  return _SubtopicModel.fromJson(json);
}

/// @nodoc
mixin _$SubtopicModel {
  String get id => throw _privateConstructorUsedError;
  String get topicId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;

  /// Serializes this SubtopicModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubtopicModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubtopicModelCopyWith<SubtopicModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubtopicModelCopyWith<$Res> {
  factory $SubtopicModelCopyWith(
    SubtopicModel value,
    $Res Function(SubtopicModel) then,
  ) = _$SubtopicModelCopyWithImpl<$Res, SubtopicModel>;
  @useResult
  $Res call({
    String id,
    String topicId,
    String title,
    String slug,
    int orderIndex,
  });
}

/// @nodoc
class _$SubtopicModelCopyWithImpl<$Res, $Val extends SubtopicModel>
    implements $SubtopicModelCopyWith<$Res> {
  _$SubtopicModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubtopicModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topicId = null,
    Object? title = null,
    Object? slug = null,
    Object? orderIndex = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            topicId: null == topicId
                ? _value.topicId
                : topicId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubtopicModelImplCopyWith<$Res>
    implements $SubtopicModelCopyWith<$Res> {
  factory _$$SubtopicModelImplCopyWith(
    _$SubtopicModelImpl value,
    $Res Function(_$SubtopicModelImpl) then,
  ) = __$$SubtopicModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String topicId,
    String title,
    String slug,
    int orderIndex,
  });
}

/// @nodoc
class __$$SubtopicModelImplCopyWithImpl<$Res>
    extends _$SubtopicModelCopyWithImpl<$Res, _$SubtopicModelImpl>
    implements _$$SubtopicModelImplCopyWith<$Res> {
  __$$SubtopicModelImplCopyWithImpl(
    _$SubtopicModelImpl _value,
    $Res Function(_$SubtopicModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubtopicModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topicId = null,
    Object? title = null,
    Object? slug = null,
    Object? orderIndex = null,
  }) {
    return _then(
      _$SubtopicModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        topicId: null == topicId
            ? _value.topicId
            : topicId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubtopicModelImpl implements _SubtopicModel {
  const _$SubtopicModelImpl({
    required this.id,
    required this.topicId,
    required this.title,
    required this.slug,
    this.orderIndex = 0,
  });

  factory _$SubtopicModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubtopicModelImplFromJson(json);

  @override
  final String id;
  @override
  final String topicId;
  @override
  final String title;
  @override
  final String slug;
  @override
  @JsonKey()
  final int orderIndex;

  @override
  String toString() {
    return 'SubtopicModel(id: $id, topicId: $topicId, title: $title, slug: $slug, orderIndex: $orderIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubtopicModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, topicId, title, slug, orderIndex);

  /// Create a copy of SubtopicModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubtopicModelImplCopyWith<_$SubtopicModelImpl> get copyWith =>
      __$$SubtopicModelImplCopyWithImpl<_$SubtopicModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubtopicModelImplToJson(this);
  }
}

abstract class _SubtopicModel implements SubtopicModel {
  const factory _SubtopicModel({
    required final String id,
    required final String topicId,
    required final String title,
    required final String slug,
    final int orderIndex,
  }) = _$SubtopicModelImpl;

  factory _SubtopicModel.fromJson(Map<String, dynamic> json) =
      _$SubtopicModelImpl.fromJson;

  @override
  String get id;
  @override
  String get topicId;
  @override
  String get title;
  @override
  String get slug;
  @override
  int get orderIndex;

  /// Create a copy of SubtopicModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubtopicModelImplCopyWith<_$SubtopicModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

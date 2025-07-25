// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  displayName: json['displayName'] as String,
  email: json['email'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  profilePhoto: json['profilePhoto'] as String?,
  portfolios:
      (json['portfolios'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'displayName': instance.displayName,
  'email': instance.email,
  'createdAt': instance.createdAt.toIso8601String(),
  'profilePhoto': instance.profilePhoto,
  'portfolios': instance.portfolios,
};

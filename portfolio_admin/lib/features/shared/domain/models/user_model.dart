import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String displayName;
  final String email;
  final DateTime createdAt;
  final String? profilePhoto;
  final List<String> portfolios;

  const UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.createdAt,
    this.profilePhoto,
    required this.portfolios,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? displayName,
    String? email,
    DateTime? createdAt,
    String? profilePhoto,
    List<String>? portfolios,
  }) {
    return UserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      portfolios: portfolios ?? this.portfolios,
    );
  }

  @override
  List<Object?> get props => [
    id,
    displayName,
    email,
    createdAt,
    profilePhoto,
    portfolios,
  ];
}

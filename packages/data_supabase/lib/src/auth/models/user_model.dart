import 'package:domain/auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_model.g.dart';

@JsonSerializable(createToJson: false)
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.role,
    super.avatarUrl,
  });

  factory UserModel.fromSupabaseUser(User supabaseUser) {
    final metaData = supabaseUser.userMetadata ?? {};
    return UserModel(
      id: supabaseUser.id,
      username: metaData['username'] as String? ?? '',
      role: metaData['role'] as String? ?? 'user',
      avatarUrl: metaData['avatar_url'] as String?,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @JsonKey(name: 'avatar_url')
  @override
  String? get avatarUrl;
}

import 'dart:io';

import 'package:core/constants.dart';
import 'package:core/errors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../post.dart';

class SupabasePostRemoteDataSourceImpl implements PostRemoteDataSource {
  SupabasePostRemoteDataSourceImpl({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  @override
  Future<List<PostDisplayModel>> getPosts({
    required int offset,
    required int limit,
  }) async {
    try {
      if (_supabaseClient.auth.currentUser == null) {
        throw const AuthenticationException(
          message: 'User is not authenticated',
        );
      }

      final to = offset + limit - 1;
      final postMap = await _supabaseClient
          .from(Views.postDisplayView)
          .select()
          .order('post_created_at', ascending: false)
          .range(offset, to);
      return postMap.map((post) => PostDisplayModel.fromJson(post)).toList();
    } on PostgrestException catch (e) {
      if (e.code == PostgresErrors.insufficientPrivilege) {
        throw PermissionException(message: e.message);
      }
      throw DatabaseException(message: e.message);
    } on AuthenticationException {
      rethrow;
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }
}

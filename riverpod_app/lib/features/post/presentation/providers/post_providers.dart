import 'package:data_supabase/post.dart';
import 'package:domain/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/supabase_providers.dart';

part 'post_providers.g.dart';

@riverpod
PostRemoteDataSource postRemoteDataSource(Ref ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return SupabasePostRemoteDataSourceImpl(supabaseClient: supabaseClient);
}

@riverpod
PostRepository postRepository(Ref ref) {
  final postRemoteDataSource = ref.watch(postRemoteDataSourceProvider);
  return PostRepositoryImpl(postRemoteDataSource: postRemoteDataSource);
}

@riverpod
GetPostsUseCase getPostsUseCase(Ref ref) {
  return GetPostsUseCase(ref.watch(postRepositoryProvider));
}

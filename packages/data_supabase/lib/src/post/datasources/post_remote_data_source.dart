import '../../../post.dart';

abstract interface class PostRemoteDataSource {
  Future<List<PostDisplayModel>> getPosts({
    required int offset,
    required int limit,
  });
}

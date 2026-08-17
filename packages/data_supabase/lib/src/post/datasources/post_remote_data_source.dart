import 'dart:io';

import 'package:domain/post.dart';
import '../../../post.dart';

abstract interface class PostRemoteDataSource {
  Future<List<PostDisplayModel>> getPosts({
    required int offset,
    required int limit,
  });

  Future<PostDisplayModel> createPosts({
    required String title,
    required String content,
    String? postId,
    String? imageUrl,
  });

  Future<ImageUploadResult> uploadPostImage({
    required File image,
    String? postId,
  });

  Future<PostDisplayModel> getPostDetail({required String postId});

  Future<List<CommentDisplayModel>> getComments({
    required String postId,
    required int offset,
    required int limit,
  });
}

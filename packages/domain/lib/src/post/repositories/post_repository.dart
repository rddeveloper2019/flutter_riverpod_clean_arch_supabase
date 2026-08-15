import 'dart:io';

import 'package:core/errors.dart';
import 'package:fpdart/fpdart.dart';

import '../../../post.dart';
import '../dto/image_upload_result.dart';

abstract interface class PostRepository {
  Future<Either<Failure, List<PostDisplay>>> getPosts({
    required int offset,
    required int limit,
  });

  Future<Either<Failure, PostDisplay>> createPosts({
    String? postId,
    required String title,
    required String content,
    String? imageUrl,
  });

  Future<Either<Failure, ImageUploadResult>> uploadPostImage({
    required File image,
    String? postId,
  });
}

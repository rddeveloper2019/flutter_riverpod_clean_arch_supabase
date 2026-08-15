import 'dart:io';

import 'package:domain/auth.dart';
import 'package:domain/post.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/presentation_failure_exception.dart';
import '../providers/post_providers.dart';

final createPostMutation = Mutation<PostDisplay>();

Future<PostDisplay> runCreatePost({
  required WidgetRef ref,
  required String title,
  required String content,
  File? image,
}) async {
  return await createPostMutation.run(ref, (tsx) async {
    final uploadImageUseCase = tsx.get(uploadPostImageUseCaseProvider);
    final createPostUseCase = tsx.get(createPostUseCaseProvider);

    String? postId;
    String? imageUrl;
    if (image != null) {
      final uploadResult = await uploadImageUseCase(
        UploadPostImageParams(image: image, postId: postId),
      );
      uploadResult.fold(
        (failure) => throw PresentationFailureException(failure),
        (result) {
          postId = result.postId;
          imageUrl = result.imageUrl;
        },
      );
    }

    await Future.delayed(const Duration(seconds: 1));

    final createPostResult = await createPostUseCase(
      CreatePostParams(
        title: title,
        content: content,
        postId: postId,
        imageUrl: imageUrl,
      ),
    );

    return createPostResult.fold(
      (failure) => throw PresentationFailureException(failure),
      (created) => created,
    );
  });
}

import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../post.dart';

class CreatePostParams extends Equatable {
  const CreatePostParams({
    required this.title,
    required this.content,
    this.imageUrl,
    this.postId,
  });

  final String? postId;
  final String title;
  final String content;
  final String? imageUrl;

  @override
  List<Object?> get props => [postId, title, content, imageUrl];
}

class CreatePostUseCase implements UseCase<PostDisplay, CreatePostParams> {
  CreatePostUseCase(this._postRepository);

  final PostRepository _postRepository;

  @override
  Future<Either<Failure, PostDisplay>> call(CreatePostParams params) async {
    return await _postRepository.createPosts(
      postId: params.postId,
      title: params.title,
      content: params.content,
      imageUrl: params.imageUrl,
    );
  }
}

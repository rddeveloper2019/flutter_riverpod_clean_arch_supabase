import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../post.dart';

class GetCommentsParams extends Equatable {
  const GetCommentsParams({
    required this.offset,
    required this.postId,
    this.limit = 10,
  });

  final String postId;
  final int offset;
  final int limit;

  @override
  List<Object> get props => [postId, offset, limit];
}

class GetCommentsUseCase
    implements UseCase<List<CommentDisplay>, GetCommentsParams> {
  GetCommentsUseCase(this._postRepository);

  final PostRepository _postRepository;

  @override
  Future<Either<Failure, List<CommentDisplay>>> call(
    GetCommentsParams params,
  ) async {
    return await _postRepository.getComments(
      postId: params.postId,
      offset: params.offset,
      limit: params.limit,
    );
  }
}

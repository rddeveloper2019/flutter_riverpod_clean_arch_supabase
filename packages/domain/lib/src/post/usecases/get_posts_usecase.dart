import 'package:core/src/errors/failures.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import '../../../post.dart';

class GetPostsParams extends Equatable {
  const GetPostsParams({required this.offset, this.limit = 10});

  final int offset;
  final int limit;

  @override
  List<Object> get props => [offset, limit];
}

class GetPostsUseCase implements UseCase<List<PostDisplay>, GetPostsParams> {
  GetPostsUseCase(this._postRepository);

  final PostRepository _postRepository;

  @override
  Future<Either<Failure, List<PostDisplay>>> call(GetPostsParams params) async {
    return await _postRepository.getPosts(
      offset: params.offset,
      limit: params.limit,
    );
  }
}

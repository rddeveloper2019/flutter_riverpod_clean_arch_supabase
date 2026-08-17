import 'package:domain/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/presentation_failure_exception.dart';
import '../../../../core/errors/unexpected_failure.dart';
import '../providers/post_providers.dart';
import 'comment_list_state.dart';

part 'comment_list_controller.g.dart';

const _commentsPageSize = 10;

@riverpod
class CommentListController extends _$CommentListController {
  @override
  Future<CommentListState> build(String postId) async {
    final useCase = ref.watch(getCommentsUseCaseProvider);
    final result = await useCase(
      GetCommentsParams(offset: 0, postId: postId, limit: _commentsPageSize),
    );

    return result.fold(
      (failure) => throw PresentationFailureException(failure),
      (comments) {
        return CommentListState(
          comments: comments,
          status: CommentListStatus.loaded,
          hasReachedMax: comments.length < _commentsPageSize,
        );
      },
    );
  }

  bool _isRefreshBlocked(CommentListState current) {
    return current.status == CommentListStatus.fetchingNextPage ||
        current.status == CommentListStatus.refreshing ||
        current.status == CommentListStatus.refilling;
  }

  Future<void> refresh() async {
    final snapshot = state.value;
    if (snapshot == null || state.isLoading) return;
    if (_isRefreshBlocked(snapshot)) return;

    state = AsyncData(snapshot.copyWith(status: CommentListStatus.refreshing));

    try {
      await Future.delayed(const Duration(seconds: 1));
      if (!ref.mounted) return;

      final useCase = ref.read(getCommentsUseCaseProvider);
      final result = await useCase(
        GetCommentsParams(offset: 0, postId: postId, limit: _commentsPageSize),
      );

      if (!ref.mounted) return;
      final latest = state.value;
      if (latest == null) return;

      state = AsyncData(
        result.fold(
          (failure) => latest.copyWith(
            status: CommentListStatus.loaded,
            transientFailure: () => failure,
          ),
          (comments) => latest.copyWith(
            comments: comments,
            hasReachedMax: comments.length < _commentsPageSize,
            status: CommentListStatus.loaded,
          ),
        ),
      );
    } catch (e, st) {
      if (!ref.mounted) return;
      final latest = state.value;
      if (latest == null) return;

      state = AsyncData(
        latest.copyWith(
          status: CommentListStatus.loaded,
          transientFailure: () => logUnexpectedFailure(e, st),
        ),
      );
    }
  }

  Future<void> fetchNextPage() async {
    final snapshot = state.value;
    if (snapshot == null || state.isLoading) return;

    if (snapshot.hasReachedMax || _isRefreshBlocked(snapshot)) return;

    state = AsyncData(
      snapshot.copyWith(status: CommentListStatus.fetchingNextPage),
    );

    try {
      await Future.delayed(const Duration(seconds: 1));
      if (!ref.mounted) return;

      final useCase = ref.read(getCommentsUseCaseProvider);

      final result = await useCase(
        GetCommentsParams(
          offset: snapshot.comments.length,
          postId: postId,
          limit: _commentsPageSize,
        ),
      );
      if (!ref.mounted) return;
      final latest = state.value;
      if (latest == null) return;

      state = AsyncData(
        result.fold(
          (failure) => latest.copyWith(
            status: CommentListStatus.loaded,
            transientFailure: () => failure,
          ),

          (newComments) => latest.copyWith(
            comments: [...latest.comments, ...newComments],
            hasReachedMax: newComments.length < _commentsPageSize,
            status: CommentListStatus.loaded,
          ),
        ),
      );
    } catch (e, st) {
      if (!ref.mounted) return;
      final latest = state.value;
      if (latest == null) return;

      state = AsyncData(
        latest.copyWith(
          status: CommentListStatus.loaded,
          transientFailure: () => logUnexpectedFailure(e, st),
        ),
      );
    }
  }

  void consumeTransientFailure() {
    if (!ref.mounted) return;
    final latest = state.value;
    if (latest == null) return;
    state = AsyncData(latest.copyWith(transientFailure: () => null));
  }
}

import 'package:domain/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/unexpected_failure.dart';
import '../providers/post_providers.dart';
import 'post_list_state.dart';

part 'post_list_controller.g.dart';

const _pageSize = 5;

@riverpod
class PostListController extends _$PostListController {
  @override
  Future<PostListState> build() async {
    final useCase = ref.watch(getPostsUseCaseProvider);
    final result = await useCase(
      const GetPostsParams(offset: 0, limit: _pageSize),
    );

    return result.fold(
      (failure) =>
          PostListState(failure: failure, status: PostListStatus.failure),
      (posts) => PostListState(
        status: PostListStatus.loaded,
        posts: posts,
        hasReachedMax: posts.length < _pageSize,
      ),
    );
  }

  Future<void> fetchNextPage() async {
    final snapshot = state.value;
    if (snapshot == null || state.isLoading) return;

    final isBusy =
        snapshot.hasReachedMax ||
        snapshot.status == PostListStatus.fetchingNextPage ||
        snapshot.status == PostListStatus.refilling ||
        snapshot.status == PostListStatus.refreshing;

    if (isBusy) return;
    state = AsyncData(
      snapshot.copyWith(status: PostListStatus.fetchingNextPage),
    );

    try {
      await Future.delayed(const Duration(seconds: 1));
      if (!ref.mounted) return;

      final useCase = ref.read(getPostsUseCaseProvider);

      final result = await useCase(
        GetPostsParams(offset: snapshot.posts.length, limit: _pageSize),
      );
      if (!ref.mounted) return;
      final latest = state.value;
      if (latest == null) return;

      final newState = result.fold(
        (failure) => latest.copyWith(
          status: PostListStatus.loaded,
          transientFailure: () => failure,
        ),

        (newPosts) => latest.copyWith(
          posts: [...latest.posts, ...newPosts],
          hasReachedMax: newPosts.length < _pageSize,
          status: PostListStatus.loaded,
        ),
      );

      state = AsyncData(newState);
    } catch (e, st) {
      if (!ref.mounted) return;
      final latest = state.value;
      if (latest == null) return;

      state = AsyncData(
        latest.copyWith(
          status: PostListStatus.loaded,
          transientFailure: () => logUnexpectedFailure(e, st),
        ),
      );
    }
  }

  Future<void> refresh() async {
    final snapshot = state.value;
    if (snapshot == null || state.isLoading) return;

    final isBusy =
        snapshot.hasReachedMax ||
        snapshot.status == PostListStatus.fetchingNextPage ||
        snapshot.status == PostListStatus.refilling ||
        snapshot.status == PostListStatus.refreshing;

    if (isBusy) return;
    state = AsyncData(snapshot.copyWith(status: PostListStatus.refreshing));

    try {
      await Future.delayed(const Duration(seconds: 1));
      if (!ref.mounted) return;

      final useCase = ref.read(getPostsUseCaseProvider);

      final result = await useCase(
        const GetPostsParams(offset: 0, limit: _pageSize),
      );
      if (!ref.mounted) return;
      final latest = state.value;
      if (latest == null) return;

      final newState = result.fold(
        (failure) => latest.copyWith(
          status: PostListStatus.loaded,
          transientFailure: () => failure,
        ),
        (posts) => latest.copyWith(
          posts: posts,
          hasReachedMax: posts.length < _pageSize,
          status: PostListStatus.loaded,
        ),
      );

      state = AsyncData(newState);
    } catch (e, st) {
      if (!ref.mounted) return;
      final latest = state.value;
      if (latest == null) return;

      state = AsyncData(
        latest.copyWith(
          status: PostListStatus.loaded,
          transientFailure: () => logUnexpectedFailure(e, st),
        ),
      );
    }
  }
}

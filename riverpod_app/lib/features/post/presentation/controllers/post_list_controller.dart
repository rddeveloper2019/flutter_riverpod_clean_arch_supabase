import 'dart:async';

import 'package:domain/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/bus/global_event.dart';
import '../../../../core/bus/global_event_bus_provider.dart';
import '../../../../core/errors/unexpected_failure.dart';
import '../providers/post_providers.dart';
import 'post_list_state.dart';

part 'post_list_controller.g.dart';

const _pageSize = 5;

@riverpod
class PostListController extends _$PostListController {
  @override
  Future<PostListState> build() async {
    final bus = ref.watch(globalEventBusProvider);
    final sub = bus.stream.listen(_onGlobalEvent);

    ref.onDispose(sub.cancel);
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

  void consumeTransientFailure() {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(transientFailure: () => null));
  }

  bool shouldDeferGlobalEvent(PostListState current) {
    if (current.status == PostListStatus.fetchingNextPage) return false;
    return current.status == PostListStatus.refreshing ||
        current.status == PostListStatus.refilling;
  }

  void _onGlobalEvent(GlobalEvent event) {
    final current = state.value;
    if (current == null) return;
    if (shouldDeferGlobalEvent(current)) return;

    switch (event) {
      case PostCreatedDispatched(post: final post):
        prependNewPost(post);
        requestScrollToTp();
      case _:
    }
  }

  void prependNewPost(PostDisplay post) {
    final current = state.value;
    if (current == null) return;
    if (current.posts.any((p) => p.postId == post.postId)) return;
    state = AsyncData(current.copyWith(posts: [post, ...current.posts]));
  }

  void requestScrollToTp() {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        scrollToTopEventId: () => DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  void consumeScrollEvent() {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(scrollToTopEventId: () => null));
  }
}

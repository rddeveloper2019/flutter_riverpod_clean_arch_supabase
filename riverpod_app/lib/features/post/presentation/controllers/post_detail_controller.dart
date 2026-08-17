import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/bus/global_event.dart';
import '../../../../core/bus/global_event_bus_provider.dart';
import '../../../../core/errors/presentation_failure_exception.dart';
import '../../../../core/errors/unexpected_failure.dart';
import '../providers/post_providers.dart';
import 'post_detail_state.dart';

part 'post_detail_controller.g.dart';

@riverpod
class PostDetailController extends _$PostDetailController {
  @override
  Future<PostDetailState> build(String postId) async {
    final useCase = ref.watch(getPostDetailUseCaseProvider);
    final result = await useCase(postId);
    return result.fold(
          (failure) => throw PresentationFailureException(failure),
          (post) => PostDetailState(post: post),
    );
  }

  Future<void> refresh() async {
    final snapshot = state.value;
    if (snapshot == null || state.isRefreshing) return;

    state = AsyncData(
      snapshot.copyWith(isRefreshing: true, transientFailure: () => null),
    );

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (!ref.mounted) return;

      final useCase = ref.watch(getPostDetailUseCaseProvider);
      final result = await useCase(postId);
      if (!ref.mounted) return;
      final latest = state.value;
      if (latest == null) return;

      state = AsyncData(
        result.fold(
              (failure) =>
              latest.copyWith(
                isRefreshing: false,
                transientFailure: () => failure,
              ),

              (post) {
            ref
                .read(globalEventBusProvider)
                .add(PostUpdatedDispatched(post: post));
            return latest.copyWith(
              post: post,
              isRefreshing: false,
              transientFailure: () => null,
            );
          },
        ),
      );
    } catch (e, st) {
      if (!ref.mounted) return;
      final latest = state.value;
      if (latest == null) return;

      state = AsyncData(
        latest.copyWith(
          isRefreshing: false,
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

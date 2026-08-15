import 'package:core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/presentation_failure_exception.dart';
import '../../../../core/widgets/async_error_retry.dart';
import '../controllers/post_list_controller.dart';
import '../controllers/post_list_state.dart';
import '../widgets/post_card.dart';

class PostPage extends ConsumerStatefulWidget {
  const PostPage({super.key});

  @override
  ConsumerState<PostPage> createState() => _PostPageState();
}

class _PostPageState extends ConsumerState<PostPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    ref.read(postListControllerProvider.notifier).fetchNextPage();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(postListControllerProvider.notifier).fetchNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<PostListState>>(postListControllerProvider, (
      prev,
      next,
    ) {
      final prevFailure = prev?.value?.transientFailure;
      final nextFailure = next.value?.transientFailure;
      final didFail = prevFailure == null && nextFailure != null;

      if (didFail) {
        if (!mounted) return;
        showErrorSnackBar(context, message: nextFailure.message);
        ref.read(postListControllerProvider.notifier).consumeTransientFailure();
      }
    });

    final asyncState = ref.watch(postListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: asyncState.when(
        error: (e, s) => AsyncErrorRetryCentered(
          message: presentationFailureMessage(e),
          onRetry: () => ref.invalidate(postListControllerProvider),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (PostListState state) {
          switch (state.status) {
            case PostListStatus.failure:
              return AsyncErrorRetryCentered(
                message: state.failure?.message ?? 'Unknown Error',
                onRetry: () => ref.invalidate(postListControllerProvider),
              );

            case _:
              if (state.posts.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async => await ref
                      .read(postListControllerProvider.notifier)
                      .refresh(),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: const Center(
                            child: Text(
                              'There are no posts yet. \nLog in with an admin account to create a first post!',
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => await ref
                    .read(postListControllerProvider.notifier)
                    .refresh(),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: state.hasReachedMax
                      ? state.posts.length
                      : state.posts.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= state.posts.length) {
                      return (state.status == PostListStatus.fetchingNextPage)
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : const SizedBox.shrink();
                    }

                    final post = state.posts[index];

                    return PostCard(post: post);
                  },
                ),
              );
          }
        },
      ),
    );
  }
}

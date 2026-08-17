import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils.dart';
import 'package:domain/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/router/route_constants.dart';
import '../../../../core/errors/presentation_failure_exception.dart';
import '../../../../core/widgets/async_error_retry.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/comment_list_controller.dart';
import '../controllers/comment_list_state.dart';
import '../controllers/post_detail_controller.dart';
import '../controllers/post_detail_state.dart';
import '../controllers/post_list_controller.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  const PostDetailPage({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(commentListControllerProvider(widget.postId).notifier)
          .fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(postDetailControllerProvider(widget.postId));
    final commentsAsync = ref.watch(
      commentListControllerProvider(widget.postId),
    );

    ref.listen<AsyncValue<PostDetailState>>(
      postDetailControllerProvider(widget.postId),
      (prev, next) {
        final prevFailure = prev?.value?.transientFailure;
        final nextFailure = next.value?.transientFailure;
        final didFail = prevFailure == null && nextFailure != null;

        if (didFail) {
          if (!mounted) return;
          showErrorSnackBar(context, message: nextFailure.message);
          ref
              .read(postDetailControllerProvider(widget.postId).notifier)
              .consumeTransientFailure();
        }
      },
    );

    ref.listen<AsyncValue<CommentListState>>(
      commentListControllerProvider(widget.postId),
      (prev, next) {
        final prevFailure = prev?.value?.transientFailure;
        final nextFailure = next.value?.transientFailure;
        final didFail = prevFailure == null && nextFailure != null;

        if (didFail) {
          if (!mounted) return;
          showErrorSnackBar(context, message: nextFailure.message);
          ref
              .read(commentListControllerProvider(widget.postId).notifier)
              .consumeTransientFailure();
        }
      },
    );

    return postAsync.when(
      error: (e, st) => AsyncErrorRetryScaffold(
        message: presentationFailureMessage(e),
        onRetry: () {
          ref.invalidate(postDetailControllerProvider(widget.postId));
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (detail) {
        final post = detail.post;
        return Scaffold(
          appBar: AppBar(
            title: Text(post.title, style: const TextStyle(fontSize: 18)),
          ),
          body: _buildContent(
            context,
            detail: detail,
            commentsAsync: commentsAsync,
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required PostDetailState detail,
    required AsyncValue<CommentListState> commentsAsync,
  }) {
    final post = detail.post;
    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(postDetailControllerProvider(widget.postId).notifier)
            .refresh();
        await ref
            .read(commentListControllerProvider(widget.postId).notifier)
            .refresh();
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(child: _buildPostDetail(context, post)),
          const SliverToBoxAdapter(child: Divider(height: 1)),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: CommentListView(
              commentsAsync: commentsAsync,
              postId: post.postId,
              onRetry: () {
                ref.invalidate(commentListControllerProvider(widget.postId));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostDetail(BuildContext context, PostDisplay post) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  final currentUserId = ref
                      .read(authControllerProvider)
                      .user
                      ?.id;
                  if (currentUserId != post.authorId) {
                    context.goNamed(
                      RouteNames.userDetail,
                      pathParameters: {'userId': post.authorId},
                    );
                  }
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey.shade300,
                  child: post.authorAvatarUrl == null
                      ? const Icon(Icons.person, size: 22, color: Colors.white)
                      : ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: post.authorAvatarUrl!,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(strokeWidth: 2),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error_outline, size: 22),
                            fit: BoxFit.cover,
                            width: 44,
                            height: 44,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.authorUsername),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(post.postCreatedAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: post.imageUrl!,
                placeholder: (context, url) => AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(color: Colors.grey.shade200),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.image_not_supported_outlined),
                fit: BoxFit.cover,
              ),
            ),

          const SizedBox(height: 24),
          Text(post.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),

          Text(
            post.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  post.currentUserLiked
                      ? Icons.thumb_up
                      : Icons.thumb_up_alt_outlined,
                  color: post.currentUserLiked
                      ? Theme.of(context).primaryColor
                      : null,
                ),
              ),
              Text(post.likesCount.toString()),
              const SizedBox(width: 16),
              const Icon(Icons.mode_comment_outlined, size: 24),
              const SizedBox(width: 12),
              Text(post.commentsCount.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

class CommentListView extends StatelessWidget {
  const CommentListView({
    super.key,
    required this.postId,
    required this.commentsAsync,
    required this.onRetry,
  });

  final String postId;
  final AsyncValue<CommentListState> commentsAsync;
  final void Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

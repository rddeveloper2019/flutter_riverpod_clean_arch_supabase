import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/router/route_constants.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class PostCard extends ConsumerWidget {
  const PostCard({
    super.key,
    required this.post,
    this.onToggleLike,
    this.isToggleLikePending = false,
  });

  final PostDisplay post;
  final void Function()? onToggleLike;
  final bool isToggleLikePending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(
      authControllerProvider.select((AuthState state) {
        return state.user?.id;
      }),
    );
    return InkWell(
      onTap: () {
        context.pushNamed(
          RouteNames.postDetail,
          pathParameters: {'postId': post.postId},
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  if (currentUserId != post.authorId) {
                    context.pushNamed(
                      RouteNames.userDetail,
                      pathParameters: {'userId': post.authorId},
                    );
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blueGrey,
                      child: post.authorAvatarUrl == null
                          ? const Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.white,
                            )
                          : ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: post.authorAvatarUrl!,
                                placeholder: (BuildContext ctx, String url) =>
                                    const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                errorWidget:
                                    (
                                      BuildContext ctx,
                                      String url,
                                      Object error,
                                    ) => const Icon(
                                      Icons.error_outline,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.authorUsername,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            DateFormat(
                              'dd.MM.yyyy HH:mm',
                            ).format(post.postCreatedAt),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(post.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (post.imageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(8),
                  child: CachedNetworkImage(
                    height: 180,
                    width: double.infinity,
                    imageUrl: post.imageUrl!,
                    placeholder: (BuildContext ctx, String url) =>
                        Container(height: 180, color: Colors.grey[200]),
                    errorWidget: (BuildContext ctx, String url, Object error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                post.content,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      post.currentUserLiked
                          ? Icons.thumb_up
                          : Icons.thumb_up_alt_outlined,
                      color: post.currentUserLiked
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text("${post.likesCount}"),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.comment_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Text("${post.commentsCount}"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

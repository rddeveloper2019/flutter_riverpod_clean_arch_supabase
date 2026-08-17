import 'package:core/errors.dart';
import 'package:domain/post.dart';
import 'package:equatable/equatable.dart';

class PostDetailState extends Equatable {
  const PostDetailState({
    required this.post,
    this.isRefreshing = false,
    this.transientFailure,
  });

  final PostDisplay post;
  final bool isRefreshing;
  final Failure? transientFailure;

  @override
  List<Object?> get props => [post, isRefreshing, transientFailure];

  PostDetailState copyWith({
    PostDisplay? post,
    bool? isRefreshing,
    Failure? Function()? transientFailure,
  }) {
    return PostDetailState(
      post: post ?? this.post,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      transientFailure: transientFailure != null
          ? transientFailure()
          : this.transientFailure,
    );
  }
}

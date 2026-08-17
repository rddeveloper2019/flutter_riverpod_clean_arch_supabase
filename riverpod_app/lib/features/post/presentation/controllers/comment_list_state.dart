import 'package:core/errors.dart';
import 'package:domain/post.dart';
import 'package:equatable/equatable.dart';

enum CommentListStatus {
  initial,
  loaded,
  fetchingNextPage,
  refreshing,
  refilling,
}

class CommentListState extends Equatable {
  const CommentListState({
    this.status = CommentListStatus.initial,
    this.comments = const [],
    this.hasReachedMax = false,
    this.transientFailure,
  });

  final CommentListStatus status;
  final List<CommentDisplay> comments;
  final bool hasReachedMax;
  final Failure? transientFailure;

  @override
  List<Object?> get props => [
    status,
    comments,
    hasReachedMax,
    transientFailure,
  ];

  CommentListState copyWith({
    CommentListStatus? status,
    List<CommentDisplay>? comments,
    bool? hasReachedMax,
    Failure? Function()? transientFailure,
  }) {
    return CommentListState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      transientFailure: transientFailure != null
          ? transientFailure()
          : this.transientFailure,
    );
  }
}

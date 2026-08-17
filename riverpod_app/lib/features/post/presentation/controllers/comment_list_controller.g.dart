// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CommentListController)
final commentListControllerProvider = CommentListControllerFamily._();

final class CommentListControllerProvider
    extends $AsyncNotifierProvider<CommentListController, CommentListState> {
  CommentListControllerProvider._({
    required CommentListControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'commentListControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$commentListControllerHash();

  @override
  String toString() {
    return r'commentListControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CommentListController create() => CommentListController();

  @override
  bool operator ==(Object other) {
    return other is CommentListControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$commentListControllerHash() =>
    r'6f8867ee6c72893e697cf36d35ff87a540f43506';

final class CommentListControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CommentListController,
          AsyncValue<CommentListState>,
          CommentListState,
          FutureOr<CommentListState>,
          String
        > {
  CommentListControllerFamily._()
    : super(
        retry: null,
        name: r'commentListControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CommentListControllerProvider call(String postId) =>
      CommentListControllerProvider._(argument: postId, from: this);

  @override
  String toString() => r'commentListControllerProvider';
}

abstract class _$CommentListController
    extends $AsyncNotifier<CommentListState> {
  late final _$args = ref.$arg as String;
  String get postId => _$args;

  FutureOr<CommentListState> build(String postId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<CommentListState>, CommentListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CommentListState>, CommentListState>,
              AsyncValue<CommentListState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

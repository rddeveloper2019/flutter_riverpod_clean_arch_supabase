// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyNotifier)
final myProvider = MyNotifierFamily._();

final class MyNotifierProvider
    extends $AsyncNotifierProvider<MyNotifier, PostDetailState> {
  MyNotifierProvider._({
    required MyNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'myProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$myNotifierHash();

  @override
  String toString() {
    return r'myProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MyNotifier create() => MyNotifier();

  @override
  bool operator ==(Object other) {
    return other is MyNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$myNotifierHash() => r'89c95aa53e354f8763b30e3ba725e1fc03321376';

final class MyNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          MyNotifier,
          AsyncValue<PostDetailState>,
          PostDetailState,
          FutureOr<PostDetailState>,
          String
        > {
  MyNotifierFamily._()
    : super(
        retry: null,
        name: r'myProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MyNotifierProvider call(String postId) =>
      MyNotifierProvider._(argument: postId, from: this);

  @override
  String toString() => r'myProvider';
}

abstract class _$MyNotifier extends $AsyncNotifier<PostDetailState> {
  late final _$args = ref.$arg as String;
  String get postId => _$args;

  FutureOr<PostDetailState> build(String postId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PostDetailState>, PostDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PostDetailState>, PostDetailState>,
              AsyncValue<PostDetailState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

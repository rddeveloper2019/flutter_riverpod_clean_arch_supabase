// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(postRemoteDataSource)
final postRemoteDataSourceProvider = PostRemoteDataSourceProvider._();

final class PostRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          PostRemoteDataSource,
          PostRemoteDataSource,
          PostRemoteDataSource
        >
    with $Provider<PostRemoteDataSource> {
  PostRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<PostRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PostRemoteDataSource create(Ref ref) {
    return postRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostRemoteDataSource>(value),
    );
  }
}

String _$postRemoteDataSourceHash() =>
    r'df8e53cd44cf277651609957a473fe4d135592f7';

@ProviderFor(postRepository)
final postRepositoryProvider = PostRepositoryProvider._();

final class PostRepositoryProvider
    extends $FunctionalProvider<PostRepository, PostRepository, PostRepository>
    with $Provider<PostRepository> {
  PostRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postRepositoryHash();

  @$internal
  @override
  $ProviderElement<PostRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PostRepository create(Ref ref) {
    return postRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostRepository>(value),
    );
  }
}

String _$postRepositoryHash() => r'a1e714599b10bb5c5b435ed6b93dbb9e99ee5e96';

@ProviderFor(getPostsUseCase)
final getPostsUseCaseProvider = GetPostsUseCaseProvider._();

final class GetPostsUseCaseProvider
    extends
        $FunctionalProvider<GetPostsUseCase, GetPostsUseCase, GetPostsUseCase>
    with $Provider<GetPostsUseCase> {
  GetPostsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPostsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPostsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPostsUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetPostsUseCase create(Ref ref) {
    return getPostsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPostsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPostsUseCase>(value),
    );
  }
}

String _$getPostsUseCaseHash() => r'34e794f751dbe2b7d32d1178b530a1cd729a3f27';

@ProviderFor(createPostUseCase)
final createPostUseCaseProvider = CreatePostUseCaseProvider._();

final class CreatePostUseCaseProvider
    extends
        $FunctionalProvider<
          CreatePostUseCase,
          CreatePostUseCase,
          CreatePostUseCase
        >
    with $Provider<CreatePostUseCase> {
  CreatePostUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createPostUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createPostUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreatePostUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreatePostUseCase create(Ref ref) {
    return createPostUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreatePostUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreatePostUseCase>(value),
    );
  }
}

String _$createPostUseCaseHash() => r'fcdfac967f7ab5330bfb69bc8c4014f3941b0889';

@ProviderFor(uploadPostImageUseCase)
final uploadPostImageUseCaseProvider = UploadPostImageUseCaseProvider._();

final class UploadPostImageUseCaseProvider
    extends
        $FunctionalProvider<
          UploadPostImageUseCase,
          UploadPostImageUseCase,
          UploadPostImageUseCase
        >
    with $Provider<UploadPostImageUseCase> {
  UploadPostImageUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadPostImageUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadPostImageUseCaseHash();

  @$internal
  @override
  $ProviderElement<UploadPostImageUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UploadPostImageUseCase create(Ref ref) {
    return uploadPostImageUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UploadPostImageUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UploadPostImageUseCase>(value),
    );
  }
}

String _$uploadPostImageUseCaseHash() =>
    r'ed46d918ffab849666ffef70c066d15f2d1f4d43';

import 'package:domain/auth.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/presentation_failure_exception.dart';
import '../providers/auth_providers.dart';

final loginMutation = Mutation<void>();

final signupMutation = Mutation<void>();

Future<void> runLogin({
  required WidgetRef ref,
  required String email,
  required String password,
}) async {
  await loginMutation.run(ref, (tsx) async {
    final useCase = tsx.get(loginUseCaseProvider);
    final result = await useCase(LoginParams(email: email, password: password));
    result.fold(
      (failure) => throw PresentationFailureException(failure),
      (_) => null,
    );
  });
}

Future<void> runSignup({
  required WidgetRef ref,
  required String email,
  required String password,
  required String username,
}) async {
  await signupMutation.run(ref, (tsx) async {
    final useCase = tsx.get(signupUseCaseProvider);
    final result = await useCase(
      SignupParams(email: email, password: password, username: username),
    );
    result.fold(
      (failure) => throw PresentationFailureException(failure),
      (_) => null,
    );
  });
}

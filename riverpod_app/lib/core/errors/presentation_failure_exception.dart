import 'package:core/errors.dart';

class PresentationFailureException implements Exception {
  PresentationFailureException(this.failure);

  final Failure failure;

  @override
  String toString() {
    return failure.message;
  }
}

String presentationFailureMessage(Object error) {
  if (error is PresentationFailureException) return error.failure.message;
  if (error is Failure) return error.message;
  return error.toString();
}

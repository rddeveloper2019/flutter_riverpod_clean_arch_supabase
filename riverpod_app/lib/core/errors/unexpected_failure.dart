import 'package:core/errors.dart';
import 'package:flutter/foundation.dart';

Failure logUnexpectedFailure(Object error, StackTrace stackTrace) {
  debugPrint('Unexpected error: $error\$stackTrace');
  if (kDebugMode) {
    return UnknownFailure(message: '$error');
  }
  return const UnknownFailure();
}

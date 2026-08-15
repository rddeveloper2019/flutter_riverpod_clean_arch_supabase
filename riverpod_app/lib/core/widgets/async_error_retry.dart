import 'package:flutter/material.dart';

class AsyncErrorRetryBody extends StatelessWidget {
  const AsyncErrorRetryBody({
    super.key,
    required this.message,
    required this.onRetry,
    this.spacing = 16,
    this.retryLabel = 'Retry',
  });

  final String message;
  final void Function() onRetry;
  final double spacing;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message, textAlign: TextAlign.center),
        SizedBox(height: spacing),
        ElevatedButton(onPressed: onRetry, child: Text(retryLabel)),
      ],
    );
  }
}

class AsyncErrorRetryCentered extends StatelessWidget {
  const AsyncErrorRetryCentered({
    super.key,
    required this.message,
    required this.onRetry,
    this.spacing = 16,
    this.retryLabel = 'Retry',
    this.padding = const EdgeInsets.all(20),
  });

  final String message;
  final void Function() onRetry;
  final double spacing;
  final EdgeInsets padding;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: AsyncErrorRetryBody(
          message: message,
          onRetry: onRetry,
          retryLabel: retryLabel,
          spacing: spacing,
        ),
      ),
    );
  }
}

class AsyncErrorRetryScaffold extends StatelessWidget {
  const AsyncErrorRetryScaffold({
    super.key,
    required this.message,
    required this.onRetry,
    this.spacing = 16,
    this.retryLabel = 'Retry',
    this.padding = const EdgeInsets.all(20),
    this.appBar,
  });

  final String message;
  final void Function() onRetry;
  final PreferredSizeWidget? appBar;
  final double spacing;
  final EdgeInsets padding;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: AsyncErrorRetryCentered(
        message: message,
        onRetry: onRetry,
        spacing: spacing,
        padding: padding,
        retryLabel: retryLabel,
      ),
    );
  }
}

class AsyncErrorRetrySliver extends StatelessWidget {
  const AsyncErrorRetrySliver({
    super.key,
    required this.message,
    required this.onRetry,
    this.spacing = 16,
    this.retryLabel = 'Retry',
    this.padding = const EdgeInsets.all(20),
    this.appBar,
  });

  final String message;
  final void Function() onRetry;
  final PreferredSizeWidget? appBar;
  final double spacing;
  final EdgeInsets padding;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Padding(
        padding: padding,
        child: AsyncErrorRetryBody(
          message: message,
          onRetry: onRetry,
          retryLabel: retryLabel,
          spacing: spacing,
        ),
      ),
    );
  }
}

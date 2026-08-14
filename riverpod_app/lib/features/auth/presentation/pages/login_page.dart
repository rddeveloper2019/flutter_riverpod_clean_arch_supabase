import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/utils.dart';
import 'package:string_validator/string_validator.dart' as validator;

import '../../../../core/config/router/route_constants.dart';
import '../../../../core/errors/presentation_failure_exception.dart';
import '../mutations/auth_mutations.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    await runLogin(
      ref: ref,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<MutationState<void>>(loginMutation, (_, next) {
      switch (next) {
        case MutationError(:final error):
          showErrorSnackBar(
            context,
            message: presentationFailureMessage(error),
          );
        case _:
      }
    });

    final loginState = ref.watch(loginMutation);
    final isLoading = loginState is MutationPending;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Community Board',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Please enter your email';
                        }

                        if (!validator.isEmail(v.trim())) {
                          return 'Please enter a valid email';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        helperText: '6 to 20 characters',
                      ),
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      enabled: !isLoading,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Please enter your password';
                        }

                        if (v.trim().length < 6) {
                          return 'At least 6 characters for password';
                        }
                        if (v.trim().length > 20) {
                          return 'Up to 20 characters long for password';
                        }

                        return null;
                      },
                      onFieldSubmitted: !isLoading ? (_) => _submit() : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: !isLoading ? () => _submit() : null,
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Login'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: !isLoading
                          ? () {
                              context.goNamed(RouteNames.signup);
                            }
                          : null,
                      child: const Text('Need an account?'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

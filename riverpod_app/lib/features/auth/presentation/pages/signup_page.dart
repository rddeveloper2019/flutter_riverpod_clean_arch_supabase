import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/utils.dart';
import 'package:string_validator/string_validator.dart' as validator;

import '../../../../core/config/router/route_constants.dart';
import '../../../../core/errors/presentation_failure_exception.dart';
import '../mutations/auth_mutations.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    await runSignup(
      ref: ref,
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<MutationState<void>>(signupMutation, (_, next) {
      switch (next) {
        case MutationError(:final error):
          showErrorSnackBar(
            context,
            message: presentationFailureMessage(error),
          );
        case _:
      }
    });

    final signupState = ref.watch(signupMutation);
    final isLoading = signupState is MutationPending;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(title: const Text('Signup')),
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
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        helperText: '2 to 20 characters',
                      ),
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Please enter your username';
                        }

                        if (v.trim().length < 2) {
                          return 'At least 2 characters for username';
                        }
                        if (v.trim().length > 20) {
                          return 'Up to 20 characters long for username';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        helperText: '6 to 20 characters',
                      ),
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      enabled: !isLoading,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Please enter your confirmation password';
                        }

                        if (v != _passwordController.text) {
                          return 'Password does not match';
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
                          : const Text('Signup'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: !isLoading
                          ? () {
                              context.goNamed(RouteNames.login);
                            }
                          : null,
                      child: const Text('Already have an account?'),
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

import 'package:core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/router/route_constants.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class MyProfilePage extends ConsumerWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(
      authControllerProvider.select((state) => state.user?.role == Roles.admin),
    );
    print('"(**) => isAdmin"');
    print(isAdmin);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(child: Text('My Profile')),
      floatingActionButton: !isAdmin
          ? const SizedBox.shrink()
          : FloatingActionButton(
              heroTag: null,
              onPressed: () {
                context.pushNamed(RouteNames.postCreate);
              },
              tooltip: 'Create post',
              child: const Icon(Icons.add),
            ),
    );
  }
}

import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('UserProfilePage')),
    );
  }
}

import 'package:flutter/material.dart';

class BuddiesScreen extends StatelessWidget {
  static String routeName = '/buddies';
  const BuddiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Buddies'),
      ),
    );
  }
}

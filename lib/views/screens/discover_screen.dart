import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  static String routeName = '/discover';

  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Discover'),
      ),
    );
  }
}

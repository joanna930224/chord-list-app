import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static String get routeName => 'ab2def8e-780f-4f5a-94f4-7d3dfc64f47f';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('HOME'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: .center, children: [const Text('Hi')]),
      ),
    );
  }
}

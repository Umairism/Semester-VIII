import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Go to List View'),
              onPressed: () {
                Navigator.pushNamed(context, '/listview');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Go to Grid View'),
              onPressed: () {
                Navigator.pushNamed(context, '/gridview');
              },
            ),
          ],
        ),
      ),
    );
  }
}

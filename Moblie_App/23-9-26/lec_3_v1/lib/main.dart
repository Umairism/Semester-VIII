// lec 3 : Navigation , List view and Grid view.

import 'package:flutter/material.dart';

import 'home_widget.dart';
import 'list_view_widget.dart';
import 'grid_view_widget.dart';

void main() {
  runApp(const LecThree());
}

class LecThree extends StatelessWidget {
  const LecThree({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lecture 3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      initialRoute: '/listview',
      routes: {
        '/': (context) => const HomeScreen(),
        '/listview': (context) => const ListViewScreen(),
        '/gridview': (context) => const GridViewScreen(),
      },
    );
  }
}

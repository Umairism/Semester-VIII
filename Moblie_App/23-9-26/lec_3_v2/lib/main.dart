import 'package:flutter/material.dart';

import 'home_widget.dart';
import 'list_view_widget.dart';
import 'grid_view_widget.dart';

void main() {
  runApp(const RecipeApiCall());
}

class RecipeApiCall extends StatelessWidget {
  const RecipeApiCall({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Api Implementation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/listview': (context) => const ListViewScreen(),
        '/gridview': (context) => const GridViewScreen(),
      },
    );
  }
}

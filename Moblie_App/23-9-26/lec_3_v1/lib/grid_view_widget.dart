import 'package:flutter/material.dart';

class GridViewScreen extends StatelessWidget {
  const GridViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = List.generate(
      21,
      (index) => {
        'id': index,
        'name': 'Item ${index + 1}',
        'color': Colors.deepPurple[(index % 9 + 1) * 100],
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Grid View Screen')),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    elevation: 2,
                    color: item['color'],
                    child: InkWell(
                      child: Center(
                        child: Text(
                          "${item['name']}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('You Tapped on ${item['name']}'),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              child: const Text('List View'),
              onPressed: () => Navigator.pushNamed(context, '/listview'),
            ),
          ],
        ),
      ),
    );
  }
}

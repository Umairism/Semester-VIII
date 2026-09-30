import 'package:flutter/material.dart';

class ListViewScreen extends StatelessWidget {
  const ListViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> items = List.generate(20, (index) => 'Item ${index + 1}');

    return Scaffold(
      appBar: AppBar(title: const Text('List View Screen')),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(Icons.add_shopping_cart),
                      title: Text(items[index]),
                      subtitle: Text('Subtitle for ${items[index]}'),
                      trailing: Icon(Icons.cancel),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('You Tapped on ${items[index]}'),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              child: const Text('Grid View'),
              onPressed: () => Navigator.pushNamed(context, '/gridview'),
            ),
          ],
        ),
      ),
    );
  }
}

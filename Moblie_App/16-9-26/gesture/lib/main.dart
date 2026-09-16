import 'package:flutter/material.dart';

void main() => runApp(const GestureDetectorExample());

class _GestureDetectorExample extends StatelessWidget {
  const _GestureDetectorExample({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture Detector Example',
      home: Scaffold(
        appBar: AppBar(title: Text('Gesture Detector Example')),
        body: Center(child: _GestureWidget()),
      ),
    );
  }
}

class _GestureWidget extends StatefulWidget {
  const _GestureWidget({super.key});

  @override
  State<_GestureWidget> createState() => _GestureWidgetState();
}

class _GestureWidgetState extends State<_GestureWidget> {
  Color color = Colors.blue;

  String eventText = "Halalalalala kuch nahi hua tery sy";
}

void _ontap() {
  setState(() {
    Color color = Color.red;
    String eventText = "Ab hua na tap shukr ha";
  })
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: .center,
//           children: [
//             const Text('You have pushed the button this many times:'),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

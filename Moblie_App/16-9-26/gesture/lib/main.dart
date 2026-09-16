import 'package:flutter/material.dart';

void main() => runApp(const GestureDetectorExample());

class GestureDetectorExample extends StatelessWidget {
  const GestureDetectorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture Detector Example',
      home: Scaffold(
        appBar: AppBar(title: const Text('Gesture Detector Example')),
        body: const Center(child: GestureWidget()),
      ),
    );
  }
}

class GestureWidget extends StatefulWidget {
  const GestureWidget({super.key});

  @override
  State<GestureWidget> createState() => _GestureWidgetState();
}

class _GestureWidgetState extends State<GestureWidget> {
  Color _color = Colors.orange;
  String _eventText = "Halalala Tu chuti kr";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _color = Colors.red;
          _eventText = "Single Click q kia???";
        });
      },
      onDoubleTap: () {
        setState(() {
          _color = Colors.green;
          _eventText = "Lo ge ab double b kr dia";
        });
      },
      onLongPress: () {
        setState(() {
          _color = Colors.blue;
          _eventText = "click ko chor b dy ab";
        });
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Text(
          _eventText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

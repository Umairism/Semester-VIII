import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Scaffold(
        appBar: AppBar(title: Center(child: Text("Form Demo"))),
        body: Padding(padding: EdgeInsets.all(20), child: FormWidget()),
      ),
    );
  }
}

class FormWidget extends StatefulWidget {
  const FormWidget({super.key});
  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  @override
  final _formKey = GlobalKey<FormState>();
  String _Name = "";
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.person),
              hintText: "Name",
              labelText: "Enter Your Name",
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please Enter Valid Name";
              }
              return null;
            },
            onSaved: (value) => value != null ? _Name = value! : null,
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.email),
              hintText: "Email",
              labelText: "Enter Your Email",
            ),

            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please Enter Valid Email";
              }
              final emailRegex = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              );
              if (!emailRegex.hasMatch(value)) {
                return "Please Enter Valid Email";
              }
              return null;
            },
            onSaved: (value) => value != null ? _email = value! : null,
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.password),
              hintText: "Password",
              labelText: "Enter Your Password",
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please Enter Valid Password";
              }
              return null;
            },
            onSaved: (value) => value != null ? _password = value! : null,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Form Submitted By $_Name($_email)and $_password",
                    ),
                    duration: Duration(seconds: 5),
                  ),
                );
              }
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }
}

class FormDemo extends StatefulWidget {
  const FormDemo({super.key});

  @override
  State<FormDemo> createState() => _FormDemoState();
}

class _FormDemoState extends State<FormDemo> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

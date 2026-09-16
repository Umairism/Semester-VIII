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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => Scaffold(
      //         appBar: AppBar(title: const Center(child: Text("Form Demo"))),
      //         body: const Padding(padding: EdgeInsets.all(20), child: FormWidget()),
      //       ),
      //   '/second': (context) => const SecondScreen(),
      // },

      home: Scaffold(
        appBar: AppBar(title: const Center(child: Text("Form Demo"))),
        body: const Padding(padding: EdgeInsets.all(20), child: FormWidget()),
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
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
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
            onSaved: (value) => value != null ? _name = value : null,
          ),
          TextFormField(
            decoration: const InputDecoration(
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
            onSaved: (value) => value != null ? _email = value : null,
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
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
            onSaved: (value) => value != null ? _password = value : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Form Submitted By $_name ($_email)"),
                    duration: const Duration(seconds: 2),
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondScreen(
                      name: _name,
                      email: _email,
                      password: _password,
                    ),
                  ),
                );

                // Navigator.pushNamed(
                //   context,
                //   '/second',
                //   arguments: {
                //     'name': _name,
                //     'email': _email,
                //     'password': _password,
                //   },
                // );
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final String name;
  final String email;
  final String password;

  const SecondScreen({
    super.key,
    this.name = "",
    this.email = "",
    this.password = "",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("2nd Screen Demo"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to the 2nd Screen!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (name.isNotEmpty) ...[
                Text("Name: $name", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text("Email: $email", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
              ],
              ElevatedButton(
                onPressed: () {
                  // Go back to the first screen
                  Navigator.pop(context);
                },
                child: const Text("Go Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

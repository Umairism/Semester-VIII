# SQLite in Flutter (GeeksforGeeks Tutorial)

SQLite is a very popular choice of local storage database. It is an SQL lightweight and serverless SQL database engine that is highly efficient and user-friendly. Below is a guide on how to integrate and use the SQLite database with a Flutter project.

## Prerequisites
- Basic knowledge of Flutter and Dart
- Flutter SDK installed
- Dart SDK installed
- IDEs such as VSCode & Android Studio

---

## Steps to Integrate SQLite Database in Flutter

### Step 1: Create a new Flutter Application
Create a new Flutter application using the command Prompt:
```bash
flutter create app_name
```

### Step 2: Adding Dependencies
Add `sqflite` to your `pubspec.yaml` file:
```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.4.2
```
Then run the command below in the terminal:
```bash
flutter pub get
# OR
flutter pub add sqflite
```

### Step 3: Defining the User Model
Create a file in `lib/user.dart` to define a model class to represent user data.
```dart
class User {
  final int? id;
  final String username;
  final String email;

  User({this.id, required this.username, required this.email});

  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username, 'email': email};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
    );
  }
}
```

### Step 4: Defining the Database Class
In a Database helper class (`lib/database_helper.dart`), implement the functions to initialize, create, insert, query, update, and delete users.
```dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'geeksforgeeks.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE gfg_users (
        id INTEGER PRIMARY KEY,
        username TEXT,
        email TEXT
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    Database db = await instance.db;
    return await db.insert('gfg_users', user.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await instance.db;
    return await db.query('gfg_users');
  }

  Future<int> updateUser(User user) async {
    Database db = await instance.db;
    return await db.update('gfg_users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    Database db = await instance.db;
    return await db.delete('gfg_users', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> initializeUsers() async {
    List<User> usersToAdd = [
      User(username: 'John', email: 'john@example.com'),
      User(username: 'Jane', email: 'jane@example.com'),
      User(username: 'Alice', email: 'alice@example.com'),
      User(username: 'Bob', email: 'bob@example.com'),
    ];

    for (User user in usersToAdd) {
      await insertUser(user);
    }
  }
}
```

### Step 5: Defining the main file
Initialize the database and insert the users before running the `MyApp` widget, then display them in a list.
```dart
import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import the DatabaseHelper class
import 'user.dart'; // Import the User class

void main() async {
  // Initialize the database and insert users
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDb();
  await DatabaseHelper.instance.initializeUsers();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management',
      home: UserList(),
    );
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final userMaps = await DatabaseHelper.instance.queryAllUsers();
    setState(() {
      _users = userMaps.map((userMap) => User.fromMap(userMap)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GFG User List'),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_users[index].username),
            subtitle: Text(_users[index].email),
          );
        },
      ),
    );
  }
}
```

---

## Assigned Tasks
1. **Button for Navigation**: Create a button to navigate to another form where we are going to add User Data into our database and when the form saved it navigate the user back to the main window.
2. **Database Operations**: Use `sqflite` for database operations.
3. **Floating Buttons**: Create two floating buttons for updating and deleting data infront of every user displayed on main window.
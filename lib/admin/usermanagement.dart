// UserManagementScreen.dart
import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    // Sample users data
    users = [
      User(id: '001', name: 'John Doe', email: 'john.doe@example.com'),
      User(id: '002', name: 'Jane Smith', email: 'jane.smith@example.com'),
      User(id: '003', name: 'Alice Johnson', email: 'alice.johnson@example.com'),
    ];
  }

  void addUser() {
    // Add a new user to the list
    setState(() {
      users.add(User(id: '004', name: 'New User', email: 'newuser@example.com'));
    });
  }

  void editUser(User user) {
    // Edit user details
    final userIndex = users.indexWhere((u) => u.id == user.id);
    if (userIndex != -1) {
      setState(() {
        users[userIndex] = User(
          id: user.id,
          name: user.name + ' (Updated)',
          email: user.email,
        );
      });
    }
  }

  void deleteUser(User user) {
    // Remove the user from the list
    setState(() {
      users.removeWhere((u) => u.id == user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        backgroundColor: Colors.red,
      ),
      body: users.isEmpty
          ? Center(child: Text('No users available'))
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: ListTile(
              title: Text(user.name),
              subtitle: Text('Email: ${user.email}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // Call editUser to update user details
                      editUser(user);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deleteUser(user);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addUser,
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}

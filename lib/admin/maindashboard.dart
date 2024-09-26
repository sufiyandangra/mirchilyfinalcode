
import 'package:flutter/material.dart';
import 'package:untitled/admin/ordermanagement.dart';
import 'package:untitled/admin/usermanagement.dart';
import 'productmanagement.dart';

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Admin Panel',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Manage Products'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductManagementScreen()),
                );
              },
            ),
            ElevatedButton(
              child: Text('View Orders'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderManagementScreen()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Manage Users'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserManagementScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

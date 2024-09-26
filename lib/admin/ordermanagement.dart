// OrderManagementScreen.dart
import 'package:flutter/material.dart';

class Order {
  final String id;
  final double total;
  final String status;

  Order({required this.id, required this.total, required this.status});
}

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for orders
    List<Order> orders = [
      Order(id: '001', total: 150.0, status: 'Pending'),
      Order(id: '002', total: 200.0, status: 'Shipped'),
      Order(id: '003', total: 120.0, status: 'Delivered'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Management'),
        backgroundColor: Colors.red,
      ),
      body: orders.isEmpty
          ? Center(child: Text('No orders available'))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              title: Text('Order ID: ${order.id}'),
              subtitle: Text('Total: \$${order.total.toStringAsFixed(2)}'),
              trailing: Text(order.status),
            ),
          );
        },
      ),
    );
  }
}

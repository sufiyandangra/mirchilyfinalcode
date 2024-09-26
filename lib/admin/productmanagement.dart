// ProductManagementScreen.dart
import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

class ProductManagementScreen extends StatefulWidget {
  @override
  _ProductManagementScreenState createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    // Sample products data
    products = [
      Product(id: '101', name: 'Paneer Lababdar', price: 60.0),
      Product(id: '102', name: 'Sambar Masala', price: 45.0),
      Product(id: '103', name: 'Shahi Biryani Masala', price: 70.0),
    ];
  }

  void addProduct() {
    // Add a new product to the list
    setState(() {
      products.add(Product(id: '104', name: 'New Product', price: 50.0));
    });
  }

  void editProduct(Product product) {
    // Edit product details
    final productIndex = products.indexWhere((p) => p.id == product.id);
    if (productIndex != -1) {
      setState(() {
        products[productIndex] = Product(
          id: product.id,
          name: product.name + ' (Updated)',
          price: product.price + 10.0,
        );
      });
    }
  }

  void deleteProduct(Product product) {
    // Remove the product from the list
    setState(() {
      products.removeWhere((p) => p.id == product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Management'),
        backgroundColor: Colors.red,
      ),
      body: products.isEmpty
          ? Center(child: Text('No products available'))
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: ListTile(
              title: Text(product.name),
              subtitle: Text('Price: \$${product.price.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // Call editProduct and update name or price as needed
                      editProduct(product);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deleteProduct(product);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addProduct,
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}

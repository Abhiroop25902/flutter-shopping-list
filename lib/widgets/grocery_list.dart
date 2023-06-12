import 'package:flutter/material.dart';

import '../data/dummy_items.dart';

class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Groceries')),
      body: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (ctx, idx) => ListTile(
                title: Text(groceryItems[idx].name),
                leading: Container(
                  height: 24,
                  width: 24,
                  color: groceryItems[idx].category.color,
                ),
                trailing: Text(
                  groceryItems[idx].quantity.toString(),
                ),
              )),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newGroceryItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newGroceryItem == null) return;

    setState(() {
      _groceryItems.add(newGroceryItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: InkWell(
            child: const UserAvatar(),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Sign Out?'),
                      content: const Text('Do you want to Sign Out?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).pop();
                              Navigator.popAndPushNamed(context, '/sign-in');
                            },
                            child: const Text('Yes')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('No')),
                      ],
                    );
                  });
            },
          ),
        ),
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: _groceryItems.isEmpty
          ? _displayNoItem(context)
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (ctx, idx) => Dismissible(
                    onDismissed: (direction) {
                      if (direction == DismissDirection.horizontal) {
                        setState(() {
                          _groceryItems.removeAt(idx);
                        });
                      }
                    },
                    key: ValueKey(_groceryItems[idx].id),
                    child: ListTile(
                      title: Text(_groceryItems[idx].name),
                      leading: Container(
                        height: 24,
                        width: 24,
                        color: _groceryItems[idx].category.color,
                      ),
                      trailing: Text(
                        _groceryItems[idx].quantity.toString(),
                      ),
                    ),
                  )),
    );
  }

  Center _displayNoItem(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Uh-Oh, No Items Found',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Please Add a Grocery Item',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      ],
    ));
  }
}

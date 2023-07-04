import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];

  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  void _showError(String errorString) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(errorString),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Exit'))
              ],
            ));
  }

  void _loadItems() async {
    if (FirebaseAuth.instance.currentUser == null) {
      _showError('Error in saving data, user not signed in correctly');
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;

    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    final url = Uri.https('shopping-list-11411-default-rtdb.firebaseio.com',
        'user/$userId/shopping-list.json', {"auth": idToken});

    final response = await http.get(url);

    if (response.statusCode != 200) {
      _showError((jsonDecode(response.body) as Map<String, dynamic>)['error']);
    }

    final Map<String, dynamic> listData = json.decode(response.body);

    final List<GroceryItem> loadedItems = [];

    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;

      loadedItems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }

    setState(() {
      _groceryItems = loadedItems;
    });
  }

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

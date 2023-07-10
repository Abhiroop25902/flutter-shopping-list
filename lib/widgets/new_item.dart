import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = '';
  int _enteredQuantity = 1;
  Category _selectedCategory = categories[Categories.vegetables]!;
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (FirebaseAuth.instance.currentUser == null) {
        _showError('Error in saving data, user not signed in correctly');
      }

      final userId = FirebaseAuth.instance.currentUser?.uid;

      setState(() {
        _isSending = true;
      });

      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      final url = Uri.https('shopping-list-11411-default-rtdb.firebaseio.com',
          'user/$userId/shopping-list.json', {"auth": idToken});

      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'name': _enteredName,
              'quantity': _enteredQuantity,
              'category': _selectedCategory.title,
            },
          ));

      if (response.statusCode != 200) {
        _showError(
            (jsonDecode(response.body) as Map<String, dynamic>)['error']);
        return;
      }

      final newGroceryItemId =
          (jsonDecode(response.body) as Map<String, dynamic>)['name'];

      if (context.mounted) {
        Navigator.of(context).pop(GroceryItem(
            id: newGroceryItemId,
            name: _enteredName,
            quantity: _enteredQuantity,
            category: _selectedCategory));
      }
    }
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

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _enteredName = '';
      _enteredQuantity = 1;
      _selectedCategory = categories[Categories.vegetables]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new item')),
      body: _isSending
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _enteredName,
                        maxLength: 50,
                        decoration: const InputDecoration(label: Text('Name')),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length > 50) {
                            return "Must be between 1 and 50 characters";
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _enteredName = value!;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  label: Text('Quantity')),
                              keyboardType: TextInputType.number,
                              initialValue: _enteredQuantity.toString(),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    int.tryParse(value) == null ||
                                    int.tryParse(value)! <= 0) {
                                  return "Must be a valid, positive number";
                                }

                                return null;
                              },
                              onSaved: (value) =>
                                  _enteredQuantity = int.parse(value!),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: DropdownButtonFormField(
                                value: _selectedCategory,
                                onSaved: (category) {
                                  _selectedCategory = category!;
                                },
                                items: [
                                  for (final category in categories.entries)
                                    DropdownMenuItem(
                                        value: category.value,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              color: category.value.color,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(category.value.title),
                                          ],
                                        ))
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value!;
                                  });
                                }),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: _isSending ? null : _resetForm,
                              child: const Text('Reset')),
                          ElevatedButton(
                              onPressed: _isSending ? null : _saveItem,
                              child: const Text('Add Item'))
                        ],
                      )
                    ],
                  ))),
    );
  }
}

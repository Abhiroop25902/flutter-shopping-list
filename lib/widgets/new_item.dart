import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:uuid/uuid.dart';

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

  void _saveItem() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final groceryItem = GroceryItem(
        id: const Uuid().v4(),
        name: _enteredName,
        quantity: _enteredQuantity,
        category: _selectedCategory,
      );

      Navigator.of(context).pop(groceryItem);
    }
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
      body: Padding(
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
                          decoration:
                              const InputDecoration(label: Text('Quantity')),
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
                          onPressed: _resetForm, child: const Text('Reset')),
                      ElevatedButton(
                          onPressed: _saveItem, child: const Text('Add Item'))
                    ],
                  )
                ],
              ))),
    );
  }
}
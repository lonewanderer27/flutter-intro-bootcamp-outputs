import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_groceries/data/categories.dart';
import 'package:my_groceries/models/category.dart';
import 'package:my_groceries/models/grocery_item.dart';
import 'package:my_groceries/providers/grocery_items_provider.dart';

class UpdateItemScreen extends ConsumerStatefulWidget {
  const UpdateItemScreen({super.key, required this.groceryItem, required this.index});
  final int index;
  final GroceryItem groceryItem;

  @override
  ConsumerState<UpdateItemScreen> createState() => _UpdateItemScreenState();
}

class _UpdateItemScreenState extends ConsumerState<UpdateItemScreen> {
  late TextEditingController _nameController;
  late TextEditingController _qtyController;
  late Category _selectedCategory;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.groceryItem.name);
    _qtyController = TextEditingController(text: widget.groceryItem.quantity.toString());
    _selectedCategory = widget.groceryItem.category;
  }

  void _onSave() async {
    // validate the form
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var hasUpdated = await ref
          .read(groceryItemsProvider.notifier)
          .replaceItem(widget.groceryItem.id, _nameController.value.text, int.tryParse(_qtyController.value.text)!, _selectedCategory, widget.index);

      if (hasUpdated == true) {
        // close this update screen
        if (mounted) Navigator.of(context).pop();
        return;
      }

      // otherwise warn the user through a snackbar that update has failed
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(duration: const Duration(seconds: 3), content: Text(ref.read(groceryItemsProvider).error!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Update Item'),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                      controller: _nameController,
                      maxLength: 50,
                      decoration: const InputDecoration(label: Text('Name')),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length > 50) {
                          return 'Please enter a valid item name';
                        }

                        if (value.trim().length < 2 || value.length > 50) {
                          return 'Must be between 1 to 50 characters.';
                        }

                        return null;
                      }),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _qtyController,
                          decoration: const InputDecoration(label: Text('Quantity')),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty || int.tryParse(value) == null || int.tryParse(value)! <= 0) {
                              return 'Please enter a valid quantity';
                            }

                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: DropdownButtonFormField(
                        items: categories.entries
                            .map((category) => DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: category.value.color,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(category.value.title)
                                  ],
                                )))
                            .toList(),
                        onChanged: (category) {
                          setState(() {
                            _selectedCategory = category!;
                          });
                        },
                        value: _selectedCategory,
                        decoration: const InputDecoration(label: Text('Category')),
                      ))
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // TextButton(onPressed: _deleteItem, child: Text('Delete')),
                      // SizedBox(width: 10),
                      ElevatedButton(onPressed: _onSave, child: Text('Save'))
                    ],
                  )
                ],
              ),
            )));
  }
}

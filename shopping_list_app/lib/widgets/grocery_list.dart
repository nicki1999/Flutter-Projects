import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  late Future<List<GroceryItem>>? _loadedItems;
  String _error = '';
  bool isloading = false;
  Widget content = const Center(child: CircularProgressIndicator());
  @override
  initState() {
    super.initState();
    isloading = true;
   _loadedItems = _loadItems();
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.removeAt(_groceryItems.indexOf(item));
    });

    final url = Uri.https(
      'shoppinglistapp-27e76-default-rtdb.firebaseio.com',
      'shopping-list/${item.id}.json',
    );
    var response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  Future<List<GroceryItem>> _loadItems() async {
    final url = Uri.https(
      'shoppinglistapp-27e76-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );

      final response = await http.get(url);
      if (response.statusCode >= 400) {
        throw Exception('failed to load items');
        // setState(() {
        //   _error = 'Failed to load items.';
        // });
      }

      if (response.body == 'null') {
        return [];
      }
      final Map<String, dynamic> dataList = json.decode(response.body);
      final List<GroceryItem> _loadedItems = [];
      for (final item in dataList.entries) {
        final category = categories.entries
            .firstWhere(
              (catItem) => catItem.value.title == item.value['category'],
            )
            .value;
        _loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }
      // setState(() {
      //   _groceryItems = _loadedItems;
      //   _isLoading = false;
      // });
      return _loadedItems;
  }

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => const NewItem()));

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {

    if (isloading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_error!.isEmpty) {
      content = Center(child: Text(_error));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addItem)],
      ),
      body: FutureBuilder(future: _loadedItems, builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        if(snapshot.data!.isEmpty){
          return const Center(child: Text('No items added yet.'));
        }
        return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(snapshot.data![index]);
          },
          key: ValueKey(snapshot.data![index].id),
          child: ListTile(
            title: Text(snapshot.data![index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: snapshot.data![index].category.color,
            ),
            trailing: Text(snapshot.data![index].quantity.toString()),
          ),
        ),
      );
      }),
    );
  }
}

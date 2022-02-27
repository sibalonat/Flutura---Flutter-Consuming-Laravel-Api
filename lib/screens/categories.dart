import 'package:flutter/material.dart';
import 'package:flutura/models/Category.dart';
import 'package:flutura/widgets/CategoryAdd.dart';

import 'package:flutura/widgets/CategoryEdit.dart';
import 'package:flutura/providers/CategoryProvider.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  //const Categories({Key? key}) : super(key: key);

  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);
    List<Category> categories = provider.categories;
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            Category category = categories[index];
            return ListTile(
              title: Text(category.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return CategoryEdit(
                                category, provider.updateCategory);
                          });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirmation'),
                            content: Text('Are you sure you want to delete'),
                            actions: [
                              TextButton(
                                  onPressed: () => deleteCategory(
                                      provider.deleteCategory, category),
                                  child: Text('Confirm')),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel')),
                            ],
                          );
                        }),
                  ),
                ],
              ),
            );
          }),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return CategoryAdd(provider.addCategory);
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future deleteCategory(Function callback, Category category) async {
    await callback(category);
    Navigator.pop(context);
  }
}

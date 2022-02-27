import 'package:flutter/material.dart';
import 'package:flutura/models/Category.dart';
import 'package:flutura/services/api.dart';

class CategoryEdit extends StatefulWidget {
  final Category category;
  final Function categoryCallback;
  CategoryEdit(this.category, this.categoryCallback, {Key? key}) : super (key: key);

  @override
  _CategoryEditState createState() => _CategoryEditState();

}

class _CategoryEditState extends State<CategoryEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final categoryNameController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    categoryNameController.text = widget.category.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
            onChanged: (text) => setState(() => errorMessage = ''),
            controller: categoryNameController,
            validator: (String? value) {
              if(value!.isEmpty) {
                return 'Enter Category';
              }
              return null;
            },
            // initialValue: category.name,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Category name',
            ),
          ),
          //Text(category.name),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                child: Text('Save'),
                onPressed: () => saveCategory(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.red
                ),
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Text(errorMessage, style: TextStyle(color: Colors.red),)
        ]),
      ),
    );
  }
  Future saveCategory() async {
    final form = _formKey.currentState;

    if(!form!.validate()) {
      return;
    }

    widget.category.name = categoryNameController.text;

    await widget.categoryCallback(widget.category);
    Navigator.pop(context);
  }
}
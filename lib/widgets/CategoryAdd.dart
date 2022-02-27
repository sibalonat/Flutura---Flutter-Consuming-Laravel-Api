import 'package:flutter/material.dart';
import 'package:flutura/models/Category.dart';
import 'package:flutura/services/api.dart';

class CategoryAdd extends StatefulWidget {
  final Function categoryCallback;
  CategoryAdd(this.categoryCallback, {Key? key}) : super (key: key);

  @override
  _CategoryAddState createState() => _CategoryAddState();

}

class _CategoryAddState extends State<CategoryAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final categoryNameController = TextEditingController();
  String errorMessage = '';


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
    await widget.categoryCallback(categoryNameController.text);
    Navigator.pop(context);
  }
}
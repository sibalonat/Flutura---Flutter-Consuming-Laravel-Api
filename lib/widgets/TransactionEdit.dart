import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutura/models/Category.dart';
import 'package:intl/intl.dart';
import 'package:flutura/models/Transaction.dart';
import 'package:flutura/providers/CategoryProvider.dart';
import 'package:flutura/services/api.dart';
import 'package:provider/provider.dart';

class TransactionEdit extends StatefulWidget {
  final Transaction transaction;
  final Function transactionCallback;
  TransactionEdit(this.transactionCallback, this.transaction, {Key? key}) : super (key: key);

  @override
  _TransactionEditState createState() => _TransactionEditState();

}

class _TransactionEditState extends State<TransactionEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final transactionDescriptionController = TextEditingController();
  final transactionAmountController = TextEditingController();
  final transactionCategoryController = TextEditingController();
  final transactionDateController = TextEditingController();

  String errorMessage = '';
  @override
  void initState() {
    transactionDescriptionController.text = widget.transaction.description.toString();
    transactionAmountController.text = widget.transaction.amount.toString();
    transactionCategoryController.text = widget.transaction.categoryId.toString();
    transactionDateController.text = widget.transaction.transactionDate.toString();
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
            controller: transactionAmountController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^-?(\d+\.?\d{0,2})?')
              ),
            ],
            keyboardType: TextInputType.numberWithOptions(
                signed: true,
                decimal: true
            ),
            validator: (value) {
              if(value!.trim().isEmpty) {
                return 'Amount is required';
              }
              final newValue = double.tryParse(value);
              if(newValue == null) {
                return 'Invalid amount format';
              }
            },
            // initialValue: category.name,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
                icon: Icon(Icons.attach_money),
                hintText: '0'
            ),
          ),
          buildCategoriesDropDown(),
          TextFormField(
            onChanged: (text) => setState(() => errorMessage = ''),
            controller: transactionDescriptionController,
            validator: (String? value) {
              if(value!.isEmpty) {
                return 'Enter description';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Transaction Description',
            ),
          ),
          TextFormField(
            onChanged: (text) => setState(() => errorMessage = ''),
            controller: transactionDateController,
            onTap: () {
              selectDate(context);
            },
            validator: (value) {
              if(value!.trim().isEmpty) {
                return 'Enter description';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Transaction date',
            ),
          ),
          //Text(category.name),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                child: Text('Save'),
                onPressed: () => saveTransaction(),
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

  Future selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5)
    );
    if(picked != null) {
      setState(() {
        transactionDateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  Widget buildCategoriesDropDown() {
    return Consumer<CategoryProvider>(
        builder: (context, cProvider, child) {
          List<Category> categories = cProvider.categories;
          return DropdownButtonFormField(
            elevation: 8,
            items: categories.map<DropdownMenuItem<String>>((e) {
              return DropdownMenuItem<String>(
                  value: e.id.toString(),
                  child: Text(e.name, style: TextStyle(color: Colors.black, fontSize: 20.0)));
            }).toList(),
            onChanged: (String? newValue) {
              if(newValue == null) {
                return;
              }
              setState(() {
                transactionDateController.text = newValue.toString();
              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Category'
            ),
            dropdownColor: Colors.white,
            validator: (value) {
              if(value == null) {
                return 'Please select category';
              }
            },
          );
        }
    );
  }

  Future saveTransaction() async {
    final form = _formKey.currentState;

    if(!form!.validate()) {
      return;
    }

       widget.transaction.categoryId = int.parse(transactionCategoryController.text);
       widget.transaction.transactionDate = transactionDateController.text;
       widget.transaction.amount = transactionAmountController.text;
       widget.transaction.description = transactionDescriptionController.text;

    await widget.transactionCallback(widget.transaction);

    Navigator.pop(context);
  }
}
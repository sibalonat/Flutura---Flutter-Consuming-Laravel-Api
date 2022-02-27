import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutura/models/Transaction.dart';
import 'package:flutura/providers/TransactionProvider.dart';
import 'package:flutura/widgets/TransactionAdd.dart';
import 'package:flutura/widgets/TransactionEdit.dart';
import 'package:provider/provider.dart';

class Transactions extends StatefulWidget {
  //const Categories({Key? key}) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    List<Transaction> transactions = provider.transactions;

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          Transaction transaction = transactions[index];
          return ListTile(
            title: Text('\$' + transaction.amount),
            subtitle: Text(transaction.categoryName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(transaction.transactionDate),
                    Text(transaction.description)
                  ]),
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return TransactionEdit(
                                transaction, provider.updateTransaction
                            );
                          });
                    },
                    icon: Icon(Icons.edit)
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirmation'),
                              content: Text('Are you sure?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel')
                                ),
                                TextButton(
                                    onPressed: () => deleteTransaction(
                                      provider.deleteTransaction, transaction, context
                                    ),
                                    child: Text('Delete')
                                ),
                              ],
                            );
                          }
                      );
                    },
                    icon: Icon(Icons.delete)
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return TransactionAdd(provider.addTransaction);
                }
            );
          },
        child: Icon(Icons.add),
      ),
    );
  }
  Future deleteTransaction(Function callback, Transaction transaction, BuildContext context) async {
    await callback(transaction);
    Navigator.pop(context);
  }
}
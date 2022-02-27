import 'package:flutter/material.dart';

import 'package:flutura/providers/AuthProvider.dart';
import 'package:flutura/providers/TransactionProvider.dart';
import 'package:flutura/screens/categories.dart';
import 'package:flutura/screens/home.dart';
import 'package:flutura/screens/login.dart';
import 'package:flutura/screens/register.dart';

import 'package:flutura/providers/CategoryProvider.dart';
import 'package:provider/provider.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<CategoryProvider>(
              create: (context) => CategoryProvider(authProvider)),
            ChangeNotifierProvider<TransactionProvider>(
                create: (context) => TransactionProvider(authProvider)),
          ],
          child: MaterialApp(
            title: 'Welcome Flutter',
            routes: {
              '/': (context) {
                final authProvider = Provider.of<AuthProvider>(context);
                if (authProvider.isAuthenticated) {
                  return Home();
                } else {
                  return Login();
                }
              },
              '/login': (context) => Login(),
              '/register': (context) => Register(),
              '/categories': (context) => Categories(),
            }
          )
        );
      })
    );
  }
}






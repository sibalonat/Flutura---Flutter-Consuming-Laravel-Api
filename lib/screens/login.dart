import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:flutura/providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login();

  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = '';

  late String deviceName;
  @override
  void initState() {
    super.initState();
    getDeviceName();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        color: Theme.of(context).primaryColorDark,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 8,
              margin: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (String? value) {
                          if(value!.isEmpty) {
                            return 'Enter email';
                          }
                          return null;
                        },
                        onChanged: (text) => setState(() => errorMessage = ''),
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: passwordController,
                        validator: (String? value) {
                          if(value!.isEmpty) {
                            return 'Enter password';
                          }
                          return null;
                        },
                        onChanged: (text) => setState(() => errorMessage = ''),
                        decoration: InputDecoration(labelText: 'Password'),
                      ),
                      ElevatedButton(
                        onPressed: () => submit(),
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 36)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text('Register new user'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> submit() async {
    final form = _formKey.currentState;
    if (!form!.validate()) {
      return;
    }
    final AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);


    try {
       await provider.login(
          emailController.text,
          passwordController.text,
          deviceName
      );
      Navigator.pop(context);
    } catch (Exception) {
      setState(() {
        errorMessage = Exception.toString().replaceAll('Exception: ', '');
      });
    }
  }
  Future<void> getDeviceName() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if(Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = build.model;
        });
      } else if(Platform.isIOS) {
        var build = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceName = build.model;
        });
      }
    } on PlatformException {
      setState(() {
        deviceName = 'Failed to get platform version';
      });
    }
  }
}

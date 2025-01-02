import 'package:custom_form_cubit_example/login_screen.dart';
import 'package:flutter/material.dart';

import 'application/login_form_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Login Form')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LoginScreen(),
        ),
      ),
    );
  }
}

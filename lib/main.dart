import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ansar Portal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInPage(), // Start with SignInPage as the home
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'home.dart';
import 'sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ansar Portal',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        // Set the background color for the default white screen
        backgroundColor: Colors.deepOrange,
      ),
      home: FutureBuilder<String?>(
        future: storage.read(key: 'isSignedIn'),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.hasData && snapshot.data == 'true') {
            return const HomePage(); // Navigate to home page if signed in
          } else {
            return const SignInPage(); // Navigate to sign-in page if not signed in
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

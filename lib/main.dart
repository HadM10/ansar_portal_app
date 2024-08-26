import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:in_app_update/in_app_update.dart';
import 'home.dart';
import 'sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    try {
      final AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        _showUpdateDialog();
      }
    } catch (e) {
      // Handle errors if necessary
      print('Error checking for update: $e');
    }
  }

  void _showUpdateDialog() async {
    final bool? update = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update Available'),
            content: const Text('A new version of the app is available. Please update to continue.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Later'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        }
    );

    if (update == true) {
      _performImmediateUpdate();
    }
  }

  void _performImmediateUpdate() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      // Handle update errors here
      print('Error during update: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ansar Portal',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
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

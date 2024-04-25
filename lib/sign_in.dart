import 'dart:convert';
import 'package:ansar_portal_mobile_app/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'bouncing_button.dart';
import 'home.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final storage = const FlutterSecureStorage();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    // Check if email or password is empty
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password.'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Return if any field is empty
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.43.178/ansar_portal/api/signin.php'),
        body: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        // Successful sign-in
        final userId = response.body;
        // Store authentication state
        await storage.write(key: 'isSignedIn', value: 'true');
        print(userId);
        // Store user ID securely
        await storage.write(key: 'userId', value: userId)
            .then((_) {
          // Navigate to the home screen or dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        })
            .catchError((error) {
          // Handle error
          print('Error saving user ID: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save user ID.'),
              backgroundColor: Colors.red,
            ),
          );
        });
      } else {
        // Sign-in failed, display error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong email or password. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }

    } catch (error) {
      print('Error signing in: $error');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        // Authentication successful, proceed with your logic
        final googleAuth = await googleUser.authentication;
        final response = await http.post(
          Uri.parse('http://192.168.43.178/ansar_portal/api/google_signin.php'),
          body: {
            'google_id': googleUser.id,
            'email': googleUser.email,
            'clientId': '778123163617-p7dlpb019kbj3n46corgmleptr3ddk4d.apps.googleusercontent.com',
          },
        );
        if (response.statusCode == 200) {
          // Store authentication state
          await storage.write(key: 'isSignedIn', value: 'true');
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          final userId = jsonResponse['user_id']; // Extract user_id from the response
          print('Google Sign-in User ID: $userId');

          // Store user ID securely
          await storage.write(key: 'userId', value: userId.toString())
              .then((_) {
            // Navigate to the home screen or dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          })
              .catchError((error) {
            // Handle error
            print('Error saving Google sign-in user ID: $error');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to save user ID.'),
                backgroundColor: Colors.red,
              ),
            );
          });
        } else {
          // Google sign-in failed, display error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Google sign-in failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // User canceled sign-in
        print('Google sign-in canceled.');
      }
    } catch (error) {
      print('Google sign-in error: $error');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/signinpage.jpeg',
            // Replace 'background_image.jpg' with your actual image asset path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Content
          Padding(
            padding: const EdgeInsets.only(
              top: 70.0,
              left: 20.0,
              right: 20.0,
              bottom: 20.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Your app logo
                  Image.asset(
                    'assets/ansarportallogo.png',
                    // Replace 'your_app_logo.png' with your actual logo image asset path
                    height: 200,
                  ),
                  const SizedBox(height: 30),
                  // Email TextField
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 2,
                            )
                          ],
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 2,
                            )
                          ],
                        ),
                        contentPadding:
                        const EdgeInsets.fromLTRB(12, 8, 12, 8),
                        // Adjust left padding here
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 2,
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Password TextField
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 2,
                            )
                          ],
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 2,
                            )
                          ],
                        ),
                        contentPadding:
                        const EdgeInsets.fromLTRB(12, 8, 12, 8),
                        // Adjust left padding here
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 2,
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sign In button
                  BouncingButton(onPressed: signIn),

                  const SizedBox(height: 10),

                  // Sign In with Google button
                  ElevatedButton(
                    onPressed: signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.deepOrange[700],
                      backgroundColor: Colors.white,
                      side: BorderSide.none,
                      shadowColor: Colors.black,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // less border radius
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.google,
                          size: 20,
                          color:
                          Colors.deepOrange[700], // You can set this to any color you want
                        ),
                        const SizedBox(width: 10),
                        const Text('Continue with Google'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Sign Up button
                  TextButton(
                    onPressed: () {
                      // Navigate to the sign-up screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      foregroundColor: Colors.white, // text color
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      side: BorderSide.none,
                      elevation: 10,
                      shadowColor: Colors.black,
                      backgroundColor: Colors.white24, // button color
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_add,
                            color: Colors.white), // example icon
                        SizedBox(width: 10),
                        Text("Don't have an account? Sign Up"),
                      ],
                    ),
                  ),

                  // Add bottom margin to create space at the bottom
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'bouncing_button.dart';
import 'sign_in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});


  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://192.168.1.5/ansar_portal/api/signup.php'),
        body: {
          'username': usernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        // Sign up successful, navigate to sign in screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      } else {
        // Sign up failed, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign up failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/signuppage.jpeg',
            // Replace 'background_image.jpg' with your actual image asset path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),

                    // Your app logo
                    Image.asset(
                      'assets/ansarportallogo.png',
                      // Replace 'your_app_logo.png' with your actual logo image asset path
                      height: 200,
                    ),

                    TextFormField(
                      controller: usernameController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.red,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 2,
                            )
                          ],
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(1),
                            blurRadius: 5,
                          )
                        ],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: const TextSelectionThemeData(
                          selectionHandleColor: Colors.red,
                        ),
                      ),
                      child: TextFormField(
                      controller: emailController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(1),
                              blurRadius: 5,
                            )

                          ],
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.red,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 2,
                            )
                          ],
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(1),
                            blurRadius: 5,
                          )
                        ],

                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(1),
                              blurRadius: 5,
                            )
                          ],
                        ),

                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),

                        ),
                        errorStyle: TextStyle(
                          color: Colors.red,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 5,
                            )
                          ],
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(1),
                            blurRadius: 5,
                          )
                        ],
                      ),

                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        } else if (!_containsUppercase(value)) {
                          return 'Password must contain at least one uppercase letter';
                        } else if (!_containsLowercase(value)) {
                          return 'Password must contain at least one lowercase letter';
                        } else if (!_containsNumber(value)) {
                          return 'Password must contain at least one number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    SignUpButton(onPressed: signUp),

                    const SizedBox(height: 20),

                    // Sign In button
                    TextButton(
                      onPressed: () {
                        // Navigate to the sign-up screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInPage()),
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
                          Icon(Icons.login,
                              color: Colors.white), // example icon
                          SizedBox(width: 10),
                          Text("Already have an account? Sign In"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _containsUppercase(String value) {
    return value.contains(RegExp(r'[A-Z]'));
  }

  bool _containsLowercase(String value) {
    return value.contains(RegExp(r'[a-z]'));
  }

  bool _containsNumber(String value) {
    return value.contains(RegExp(r'[0-9]'));
  }
}

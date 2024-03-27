import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'home.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.12/ansar_portal/api/signin.php'),
        body: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        // Successful sign-in
        // Navigate to the home screen or dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Sign-in failed, display error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign-in failed. Please try again.'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed in successfully with Google.'),
            backgroundColor: Colors.green,
          ),
        );
        print('Signed in with Google: ${googleUser.email}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
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
            'assets/signinpage.jpeg', // Replace 'background_image.jpg' with your actual image asset path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Your app logo
                  Image.asset(
                    'assets/ansarportallogo.png', // Replace 'your_app_logo.png' with your actual logo image asset path
                    height: 250,
                  ),
                  const SizedBox(height: 20),
                  // Email TextField
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 0),
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
                          shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 2)],
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 2)],
                        ),
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12), // Adjust left padding here

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 2)],
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
                          shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 2)],
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 2)],
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12), // Adjust left padding here

                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 2)],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Sign In button
                  ElevatedButton(
                    onPressed: signIn,
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(height: 10),
                  // Sign In with Google button
                  ElevatedButton(
                    onPressed: signInWithGoogle,
                    child: const Text('Sign In with Google'),
                  ),
                  const SizedBox(height: 10),
                  // Sign Up button
                  TextButton(
                    onPressed: () {
                      // Navigate to the sign-up screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text("Don't have an account? Sign Up"),
                  ),
                  // Add bottom margin to create space at the bottom
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: const Center(
        child: Text('Sign Up Page'),
      ),
    );
  }
}

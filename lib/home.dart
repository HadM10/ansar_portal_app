import 'package:ansar_portal_mobile_app/deals.dart';
import 'package:ansar_portal_mobile_app/stores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'news.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final storage = const FlutterSecureStorage();

  Future<void> _signOut(BuildContext context) async {
    // Your sign-out logic here
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
      // Remove authentication state
      await storage.delete(key: 'isSignedIn');
      Navigator.pushReplacementNamed(context, '/');
    } catch (error) {
      print('Error signing out: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/home-final.jpg', // Replace with your actual image path
              fit: BoxFit.cover,
            ),
          ),
          // Black layer
          Container(
            color: Colors.black.withOpacity(0.2), // Adjust opacity as needed
          ),
          // Logo and welcome message
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/ansarportallogo.png', // Replace with your actual logo image path
                  height: 200,
                ),
                const SizedBox(height: 50),
                const Text(
                  'WELCOME',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Kuro',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    // Add any other styles you want
                  ),
                ),
                const Text(
                  'TO ANSAR PORTAL',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Kuro',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    // Add any other styles you want
                  ),
                ),
              ],
            ),
          ),
          // Icons below (arranged in rows of three)
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector( // Wrap the store icon with GestureDetector
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DealsPage()), // Navigate to StoresPage
                    );
                  },
                  child: _buildIconWithLabel(Icons.local_offer, 'DEALS'),
                ),

                _buildIconWithLabel(Icons.event, 'EVENTS'),
                GestureDetector(
                  onTap: () => _signOut(context),
                  child: _buildIconWithLabel(Icons.logout, 'LOGOUT'),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 170,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector( // Wrap the store icon with GestureDetector
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StoresPage()), // Navigate to StoresPage
                    );
                  },
                  child: _buildIconWithLabel(Icons.store, 'STORES'),
                ),
                _buildIconWithLabel(Icons.category, 'CATEGORIES'),
                GestureDetector( // Wrap the store icon with GestureDetector
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewsPage()), // Navigate to StoresPage
                    );
                  },
                  child: _buildIconWithLabel(Icons.article, 'NEWS'),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithLabel(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFFFFFF),
          ),
          child: Icon(icon, size: 40, color: Colors.deepOrange[700]),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

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
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
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
          Positioned.fill(
            child: Image.asset(
              'assets/home-final.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/ansarportallogo.png',
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
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'TO ANSAR PORTAL',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Kuro',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconWithLabel(Icons.local_offer, 'DEALS', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DealsPage()),
                  );
                }),
                _buildIconWithLabel(Icons.event, 'EVENTS', () {
                  // Add navigation or action for EVENTS here
                }),
                _buildIconWithLabel(Icons.logout, 'LOGOUT', () {
                  _signOut(context);
                }),
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
                _buildIconWithLabel(Icons.store, 'STORES', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StoresPage()),
                  );
                }),
                _buildIconWithLabel(Icons.category, 'CATEGORIES', () {
                  // Add navigation or action for CATEGORIES here
                }),
                _buildIconWithLabel(Icons.article, 'NEWS', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NewsPage()),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithLabel(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
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
      ),
    );
  }
}

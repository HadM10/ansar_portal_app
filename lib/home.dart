import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share_plus/share_plus.dart';

import 'deals.dart';
import 'map.dart';
import 'news.dart';
import 'stores.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/home-final.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
          // Share App Button
          Positioned(
            top: 45,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.share, size: 35,),
              color: Colors.white,
                onPressed: () {
                  // Implement share app functionality
                  Share.share('Check out this awesome app!',);
                }
            ),
          ),
          // Hamburger Menu Button
          Positioned(
            top: 40,
            right: 10,
            child: PopupMenuButton(
              icon: Icon(Icons.menu, size: 45, color: Colors.white,),
              offset: Offset(0, 55),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: ListTile(
                      title: Text('About Us', style: TextStyle(color: Colors.black, fontFamily: 'kuro')),
                      onTap: () {
                        // Navigate to About Us page
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      title: Text('Contact Us', style: TextStyle(color: Colors.black, fontFamily: 'kuro')),
                      onTap: () {
                        // Navigate to Contact Us page
                      },
                    ),
                  ),
                  // Add more PopupMenuItems for additional options
                ];
              },
            ),
          ),

          // Center Content
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/ansarportallogo.png',
                  height: 200,
                ),
                const SizedBox(height: 20),
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
          // Bottom Row
          Positioned(
            bottom: 60,
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
          // Bottom Row 2
          Positioned(
            bottom: 180,
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
                _buildIconWithLabel(Icons.map, 'MAP', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
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

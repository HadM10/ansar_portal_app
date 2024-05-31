import 'package:AnsarPortal/sign_in.dart';
import 'package:AnsarPortal/tourism.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'socials.dart';
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );  // Ensure this route is defined in your route settings
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
            top: 45,
            left: 10,
            child: IconButton(
                icon: Icon(Icons.share, size: 35),
                color: Colors.white,
                onPressed: () {
                  Share.share('Check out this awesome app!');
                }
            ),
          ),

          Positioned(
            top: 40,
            right: 10,

            child: PopupMenuButton<int>(
              icon: Icon(Icons.menu, size: 45, color: Colors.white),
              offset: Offset(0, 60),
              itemBuilder: (BuildContext context) => [
              PopupMenuItem<int>(
                value: 1,
                child: ListTile(
                  leading: Icon(Icons.info, color: Colors.black87),
                  title: Text('Our Service', style: TextStyle(color: Colors.black87, fontFamily: 'kuro')),
                ), onTap: () {
                // Show a dialog or a toast with the message "Messi appears!"
                // You can customize the appearance and behavior as needed.
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('ANSAR PORTAL'),
                      content: Text("أهلاً بكم في بوابة أنصار، تطبيقكم الأمثل لاكتشاف كل ما هو جديد ومميز في أنصار ! نقدم لكم منصة شاملة تعرض أحدث الأخبار، العروض الحصرية، ومعلومات عن جميع المتاجر المحلية. تم تصميم بوابة أنصار لتجعل حياتكم أسهل، حيث يمكنكم العثور على كل ما تحتاجونه بلمسة زر. سواء كنتم تبحثون عن أحدث العروض، أو ترغبون في استكشاف متاجر جديدة، فإن بوابة أنصار هي دليلكم الأول. نهدف إلى تعزيز التجارة المحلية ودعم الاقتصاد في أنصار من خلال تسهيل الوصول إلى المعلومات والعروض التي تهمكم. انضموا إلينا الآن وكونوا جزءًا من مجتمع بوابة أنصار!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
                ),

                PopupMenuItem<int>(
                  value: 2,
                  child: ListTile(
                    leading: Icon(Icons.email, color: Colors.black87),
                    title: Text('Contact Us', style: TextStyle(color: Colors.black87, fontFamily: 'kuro')),
                    onTap: () {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'ansarportal@gmail.com',  // Replace with your email address
                        query: encodeQueryParameters(<String, String>{
                          'subject': 'Inquiry from MyApp', // Optional: Set the subject
                        }),
                      );
                      launchUrl(emailLaunchUri);
                    },
                  ),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.black87),
                    title: Text('Logout', style: TextStyle(color: Colors.black87, fontFamily: 'kuro')),
                    onTap: () {
                      Navigator.pop(context); // Close the menu before logging out
                      _signOut(context);
                    },
                  ),
                ),
              ],
            ),
          ),
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
                _buildIconWithLabel(Icons.article, 'NEWS', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NewsPage()),
                  );
                }),
                _buildIconWithLabel(Icons.map, 'MAP', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                }),
                _buildIconWithLabel(Icons.people, 'SOCIALS', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SocialsPage()),
                  );
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
                _buildIconWithLabel(FontAwesomeIcons.buildingColumns, 'ANSAR', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>TourismPage()),
                  );
                }, iconSize: 32),
                _buildIconWithLabel(Icons.local_offer, 'DEALS', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DealsPage()),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithLabel(
      IconData icon,
      String label,
      VoidCallback onTap, {
        double iconSize = 40, // Default icon size
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFFFFF),
            ),
            child: Icon(icon, size: iconSize, color: Colors.deepOrange[700]),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}

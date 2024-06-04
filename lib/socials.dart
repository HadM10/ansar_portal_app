import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOCIALS', style: TextStyle(color: Colors.white,
            fontFamily: 'kuro',
            fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepOrange[700], // Dark orange background color
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildImage('assets/whatsapp.jpg'),
          ),
          Expanded(
            child: _buildImage('assets/instagram.jpg'),
          ),
          Expanded(
            child: _buildImage('assets/tiktok.webp'),
          ),
          Expanded(
            child: _buildImage('assets/facebook.jpg'),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    return InkWell(
      onTap: () {
        if (imagePath.contains('whatsapp')) {
          _launchURL('whatsapp://send?phone=+96171363816');
        } else if (imagePath.contains('instagram')) {
          _launchURL('https://www.instagram.com/topcoders.lb');
        } else if (imagePath.contains('facebook')) {
          _launchURL('https://www.facebook.com/profile.php?id=61560817222567');
        } else if (imagePath.contains('tiktok')) {
          _launchURL('https://www.tiktok.com/@topcoders.lb?_t=8mvMjpQXnv7&_r=1');
        }
      },
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    await launchUrl(uri);

  }
}

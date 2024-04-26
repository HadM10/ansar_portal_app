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
          _launchURL('whatsapp://send?phone=YOUR_PHONE_NUMBER');
        } else if (imagePath.contains('instagram')) {
          _launchURL('https://www.instagram.com/YOUR_USERNAME/');
        } else if (imagePath.contains('facebook')) {
          _launchURL('https://www.facebook.com/YOUR_USERNAME/');
        } else if (imagePath.contains('tiktok')) {
          _launchURL('https://www.tiktok.com/@YOUR_USERNAME');
        }
      },
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

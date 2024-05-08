import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';

class TourismPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TOURISM',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'kuro',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrange[700],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          // Section 1: About Ansar - Carousel Slider
          Padding(padding: EdgeInsets.all(20.0),
            child: Center(child: Text(
              'About Ansar',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'kuro'
              ),
            ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: [
                Image.asset('assets/ansar1.png'),
                // Replace with your image path
                Image.asset('assets/ansar2.png'),
                // Replace with your image path
                Image.asset('assets/ansar3.png'),
                // Replace with your image path
              ],
            ),
          ),
          SizedBox(height: 20), // Adjust the spacing as needed
          // Add your places or monuments section here
          // Section 2: Places or Monuments - Cards
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text(
                  'Places or Monuments',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'kuro'
                  ),
                ),
                ),
                SizedBox(height: 20.0),
                // Replace these cards with your own
                _buildPlaceCard('Place 1', 'Description 1',
                    'https://via.placeholder.com/150'),
                SizedBox(height: 20.0),
                _buildPlaceCard('Place 2', 'Description 2',
                    'https://via.placeholder.com/150'),
                SizedBox(height: 20.0),
                _buildPlaceCard('Place 3', 'Description 3',
                    'https://via.placeholder.com/150'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(String title, String description, String imageUrl) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  description,
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


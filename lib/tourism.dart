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
          'ANSAR',
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
          Padding(padding: EdgeInsets.only(top: 10.0),
            child: Center(child: Text(
              '',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'kuro'
              ),
            ),
            ),
          ),
          Container(
            child: CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 4 / 4.5, // Adjust the aspect ratio as needed
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
          SizedBox(height: 10), // Adjust the spacing as needed
          // Add your places or monuments section here
          // Section 2: Places or Monuments - Cards
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text(
                  'معالم انصار',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'kuro'
                  ),
                ),
                ),
                SizedBox(height: 20.0),
                _buildPlaceCard('جمعية الرسالة للاسعاف الصحي',
                    'assets/risele.jpg'),
                SizedBox(height: 20.0),
                _buildPlaceCard(' الهيئة الصحية الاسلامية',
                    'assets/hy2a.jpg'),
                SizedBox(height: 20.0),
                _buildPlaceCard(' النجدة الشعبية',
                    'assets/njde.jpg'),
                SizedBox(height: 20.0),
                _buildPlaceCard('بلدية انصار',
                    'assets/bldye.jpg'),
                SizedBox(height: 20.0),
                _buildPlaceCard('ثانوية أنصار الرسميّة',
                    'assets/ansarschool.jpg'),
                _buildPlaceCard('ملتقى الفنيق',
                    'assets/phoenix.jpg'),
                _buildPlaceCard(' السوق التراثي',
                    'assets/fneq.jpg'),
                SizedBox(height: 20.0),
                _buildPlaceCard('ملعب القائد السيد موسى',
                    'assets/mousastadium.jpg'),
                SizedBox(height: 20.0),
                _buildPlaceCard('ملعب انصار الشعبي ',
                    'assets/stadium.jpg'),
                SizedBox(height: 20.0),
                _buildPlaceCard('حديقة انصار ',
                    'assets/7ady2a.jpg'),
                SizedBox(height: 20.0),
                _buildPlaceCard('مقام ابي ذر الغفاري',
                    'assets/makam.jpg'),
                SizedBox(height: 20.0),
                _buildPlaceCard('المدينة الرياضية',
                    'assets/sportcity.jpg'),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(String title, String imageUrl) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            imageUrl
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child:
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StoreDetailsPage extends StatefulWidget {
  final int storeId;

  const StoreDetailsPage({Key? key, required this.storeId}) : super(key: key);

  @override
  _StoreDetailsPageState createState() => _StoreDetailsPageState();
}

class _StoreDetailsPageState extends State<StoreDetailsPage> {
  Map<String, dynamic>? storeDetails;

  @override
  void initState() {
    super.initState();
    fetchStoreDetails();
  }

  Future<void> fetchStoreDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.4/ansar_portal/api/store_details.php?store_id=${widget
                .storeId}'),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          storeDetails = jsonResponse;
        });
      } else {
        throw Exception('Failed to load store details');
      }
    } catch (error) {
      print('Error fetching store details: $error');
    }
  }

  Widget _buildImageSlider() {
    return Stack(
      children: [
        Container(
          height: 300, // Adjust the height as needed
          child: PageView.builder(
            itemCount: storeDetails!['images'].length,
            itemBuilder: (context, index) {
              return Image.network(
                storeDetails!['images'][index],
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepOrange[700],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String value, String? url) {
    return Row(
      children: [
        Icon(icon, size: 40),
        SizedBox(width: 8),
        InkWell(
          onTap: () {
            // Add code to open the corresponding social media link
            if (url != null && url.isNotEmpty) {
              _launchURL(url);
            }
          },
          child: Text(
            '$value',
            style: TextStyle(fontSize: 18, fontFamily: 'kuro'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storeDetails != null
          ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSlider(),
            Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.grey.shade900,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Text(
                      storeDetails!['store_name'],
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'kuro',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          storeDetails!['description'],
                          style: TextStyle(fontSize: 18, fontFamily: 'kuro'),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 1,
                          color: Colors.grey.shade900,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: _buildDetailRow(Icons.store,
                        storeDetails!['category_name'], null),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: _buildDetailRow(
                        Icons.phone_android, storeDetails!['phone_number'],
                        null),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        // Add code to open map with store location
                      },
                      child: _buildDetailRow(
                          Icons.location_on, 'Store Location', null),
                    ),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(FontAwesomeIcons.facebook),
                        color: Color(0xFF3b5998),
                        iconSize: 45,// Facebook blue color
                        onPressed: () {
                          _launchURL(storeDetails!['facebook_url']);
                        },
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.instagram),
                        color: Color(0xFFc32aa3),
                        iconSize: 45,
                        onPressed: () {
                          _launchURL(storeDetails!['instagram_url']);
                        },
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.whatsapp),
                        color: Color(0xFF25d366),
                        iconSize: 45,
                        onPressed: () {
                          _launchURL(storeDetails!['whatsapp_number']);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.tiktok),
                        color: Color(0xFF000000),
                        iconSize: 45,
                        onPressed: () {
                          _launchURL(storeDetails!['tiktok_url']);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }




}


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
            'http://192.168.1.12/ansar_portal/api/store_details.php?store_id=${widget.storeId}'),
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

  Widget _buildDetailRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 40),
        SizedBox(width: 8),
        Text(
          '$value',
          style: TextStyle(fontSize: 18, fontFamily: 'kuro'),
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
                    width: double.infinity, // Make the container span the full width
                    color: Colors.grey.shade900, // Dark gray background color
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16), // Add padding
                    child: Text(
                      storeDetails!['store_name'],
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'kuro',
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text color
                      ),
                    ),
                  ),

                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Add horizontal padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          storeDetails!['description'],
                          style: TextStyle(fontSize: 18, fontFamily: 'kuro'),
                        ),
                        SizedBox(height: 20), // Add some space between the text and the line
                        Container(
                          height: 1,
                          color: Colors.grey.shade900, // Color of the line
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16), // Add horizontal padding
                    child: _buildDetailRow(Icons.store,
                      storeDetails!['category_name']),
                  ),
                  SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16), // Add horizontal padding
                child: _buildDetailRow(Icons.phone_android,
                      storeDetails!['phone_number']),
              ),
                  SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16), // Add horizontal padding
                child: InkWell(
                    onTap: () {
                      // Add code to open map with store location
                    },
                    child: _buildDetailRow(
                        Icons.location_on, 'Store Location'),
                  ),
              ),
                  SizedBox(height: 15),
                  // Display store rating using stars (optional)
                  // You can use a custom widget for star ratings
                  // Example: StarRating(rating: storeDetails['rating'])
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
}

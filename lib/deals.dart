import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class DealsPage extends StatefulWidget {
  const DealsPage({Key? key}) : super(key: key);

  @override
  _DealsPageState createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  List<DealItem> _dealItems = [];

  @override
  void initState() {
    super.initState();
    _fetchDeals();
  }

  Future<void> _fetchDeals() async {
    final response = await http.get(
      Uri.parse('https://ansarportal-deaa9ded50c7.herokuapp.com/api/view_offers.php'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _dealItems = data.map((item) => DealItem.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to fetch deals');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'أهم العروضات',
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
      body: _dealItems.isEmpty
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
        ),
      )
          :  Column(
          children: [
          SizedBox(height: 20), // Add a SizedBox for spacing
      Expanded(
      child: ListView.builder(
        itemCount: _dealItems.length,
        itemBuilder: (context, index) {
          final dealItem = _dealItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black87, // You can adjust the background color if needed
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        dealItem.storeName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'kuro',
                        ),
                      ),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 3 / 3,
                    child: CachedNetworkImage(
                      imageUrl: dealItem.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Text(
                            dealItem.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'kuro',
                            ),
                          ),
                          ),
                          SizedBox(height: 8),
                          Center(child: Text(
                            dealItem.description,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'kuro',
                            ),
                          ),
                          ),
                          SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'From  ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'kuro',
                                    color: Colors.deepOrange[700],
                                    fontWeight: FontWeight.bold, // Example: making "Publication Date:" bold
                                  ),
                                ),
                                TextSpan(
                                  text: '${dealItem.startDate}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'kuro',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: ' To  ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'kuro',
                                        color: Colors.deepOrange[700],
                                        fontWeight: FontWeight.bold, // Example: making "Publication Date:" bold
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${dealItem.endDate}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'kuro',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],),
                        ],),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

class DealItem {
  final int dealId;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String imageUrl;
  final String storeName;

  DealItem({
    required this.dealId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.storeName,
  });

  factory DealItem.fromJson(Map<String, dynamic> json) {
    return DealItem(
      dealId: int.parse(json['offer_id'].toString()),
      title: json['offer_title'],
      description: json['offer_description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      imageUrl: json['image_url'],
      storeName: json['store_name'], // Change to store name
    );
  }
}

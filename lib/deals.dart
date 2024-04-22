import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      Uri.parse('http://192.168.72.24/ansar_portal/api/view_offers.php'),
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
          'DEALS',
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
        child: CircularProgressIndicator(),

      )
          : Expanded(
        child: ListView.builder(
          itemCount: _dealItems.length,
          itemBuilder: (context, index) {
            final dealItem = _dealItems[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 4 / 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                        child: Image.network(
                          dealItem.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dealItem.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'kuro',
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            dealItem.description,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'kuro',
                            ),
                          ),
                          SizedBox(height: 8),
                              Text(
                                'Store: ${dealItem.storeName}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'kuro',
                                  color: Colors.deepOrange[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Start Date: ',
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
                              ],),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'End Date: ',
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<NewsItem> _newsItems = [];

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    final response = await http.get(
        Uri.parse('https://ansarportal-deaa9ded50c7.herokuapp.com/api/view_news.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _newsItems = data.map((item) => NewsItem.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to fetch news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NEWS',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'kuro',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrange[700], // Dark orange background color
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),

    body: _newsItems.isEmpty
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

        itemCount: _newsItems.length,
        itemBuilder: (context, index) {
          final newsItem = _newsItems[index];

          return Padding(

            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            // Adjust padding as needed

            child: Card(
              elevation: 4,
              // Add elevation for a raised effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              // Add rounded corners
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                AspectRatio(
                aspectRatio: 2 / 2.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.network(
                      newsItem.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    // Add padding inside the card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          newsItem.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'kuro',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          newsItem.content,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'kuro',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Publication Date: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'kuro',
                                      color: Colors.deepOrange[700],
                                      fontWeight: FontWeight.bold, // Example: making "Publication Date:" bold
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${newsItem.publicationDate}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'kuro',
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
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
      backgroundColor: Colors.white, // White background color
    );
  }

}

  class NewsItem {
  final int newsId;
  final String title;
  final String content;
  final String publicationDate;
  final String imageUrl;

  NewsItem({
    required this.newsId,
    required this.title,
    required this.content,
    required this.publicationDate,
    required this.imageUrl,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      newsId: int.parse(json['news_id'].toString()),
      title: json['title'],
      content: json['content'],
      publicationDate: json['publication_date'],
      imageUrl: json['image_url'],
    );
  }
}

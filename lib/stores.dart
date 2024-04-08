import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Define Store class
class Store {
  final int id;
  final String name;
  final String description;
  int totalLikes;
  final List<String> images;
  bool isLiked;

  Store({
    required this.id,
    required this.name,
    required this.description,
    required this.totalLikes,
    required this.images,
    this.isLiked = false,
  });

  // Factory method to create Store object from JSON
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: int.parse(json['store_id'].toString()),
      name: json['store_name'] ?? '',
      description: json['description'] ?? '',
      totalLikes: int.tryParse(json['total_likes'].toString()) ?? 0,
      images: List<String>.from(json['images'] ?? []),
    );
  }
}

// Define StoresPage widget
class StoresPage extends StatefulWidget {
  const StoresPage({Key? key}) : super(key: key);

  @override
  _StoresPageState createState() => _StoresPageState();
}

// Define _StoresPageState class
class _StoresPageState extends State<StoresPage> {
  List<Store> stores = [];
  String? userId; // Store user ID retrieved from session
  final storage = const FlutterSecureStorage(); // Instance of Flutter Secure Storage

  // Method to fetch stores from the server
  Future<void> fetchStores() async {
    try {
      // Make GET request to fetch stores
      final response = await http.get(Uri.parse('http://192.168.1.5/ansar_portal/api/view_stores.php'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          // Populate stores list from JSON response
          stores = jsonResponse.map((store) => Store.fromJson(store)).toList();
        });
        // Fetch user ID
        await getUserId();
        // Fetch user likes after loading stores
        await fetchUserLikes();
      } else {
        throw Exception('Failed to load stores');
      }
    } catch (error) {
      print('Error fetching stores: $error');
      // Handle error accordingly
    }
  }

  // Method to retrieve user ID from Flutter Secure Storage
  Future<void> getUserId() async {
    userId = await storage.read(key: 'userId');
    print('User ID: $userId'); // Print user ID
  }

  Future<void> fetchUserLikes() async {
    try {
      // Make POST request to fetch user likes with user ID from session
      final response = await http.post(
        Uri.parse('http://192.168.1.5/ansar_portal/api/fetch_user_likes.php'),
        body: {'user_id': userId!},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('Fetch User Likes Response: $jsonResponse'); // Print response
        setState(() {
          // Convert the list of liked store IDs to a set for efficient lookup
          final likedStoreIdsSet = Set<int>.from(jsonResponse['liked_stores']);

          // Update isLiked property for each store based on user likes
          for (var store in stores) {
            final isLiked = likedStoreIdsSet.contains(store.id);
            print('Store ${store.id} isLiked: $isLiked');
            store.isLiked = isLiked;
          }
        });
      } else {
        throw Exception('Failed to load user likes');
      }
    } catch (error) {
      print('Error fetching user likes: $error');
      // Handle error accordingly
    }
  }

  // Method to toggle like/unlike a store
  Future<void> toggleLike(Store store) async {
    try {
      // Make POST request to like/unlike a store with user ID from session
      final response = await http.post(
        Uri.parse('http://192.168.1.5/ansar_portal/api/like_store.php'),
        body: {
          'user_id': userId!,
          'store_id': store.id.toString(),
          'action': store.isLiked ? 'unlike' : 'like',
        },
      );
      if (response.statusCode == 200) {
        // Toggle isLiked property based on the response
        setState(() {
          store.isLiked = !store.isLiked;
          print('Store ${store.id} isLiked toggled: ${store.isLiked}');
          // Update totalLikes based on the response
          if (store.isLiked) {
            store.totalLikes++;
          } else {
            store.totalLikes--;
          }
        });

        // Save the updated liked status locally
        await saveLikedStatus(store.id.toString(), store.isLiked);
      } else {
        throw Exception('Failed to toggle like');
      }
    } catch (error) {
      print('Error toggling like: $error');
      // Handle error accordingly
    }
  }

  // Override initState() method to fetch stores, user ID, and liked status when widget is initialized
  @override
  void initState() {
    super.initState();
    fetchStores(); // Fetch stores and user ID
  }

  // Method to save the liked status locally
  Future<void> saveLikedStatus(String storeId, bool isLiked) async {
    await storage.write(key: 'liked_$storeId', value: isLiked.toString());
  }

  // Method to retrieve the liked status locally
  Future<bool?> getLikedStatus(String storeId) async {
    final likedStatus = await storage.read(key: 'liked_$storeId');
    return likedStatus != null ? likedStatus == 'true' : null;
  }

  // Override build() method to build the widget UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrange[700], // Dark orange background color
      ),
      body: ListView.builder(
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final store = stores[index];
          final String firstImage = store.images.isNotEmpty ? store.images.first : '';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Adjust padding as needed
            child: Card(
              elevation: 4, // Add elevation for a raised effect
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Add rounded corners
              child: ListTile(
                contentPadding: EdgeInsets.all(16), // Add padding inside the ListTile
                leading: CircleAvatar(
                  radius: 30, // Increase the radius of the CircleAvatar
                  backgroundImage: NetworkImage(firstImage),
                ),
                title: Padding(
                  padding: EdgeInsets.only(bottom: 4.0), // Add bottom padding
                  child: Text(
                    store.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Adjust font size and weight
                  ),
                ),
                subtitle: Text(
                  store.description,
                  style: TextStyle(fontSize: 14), // Adjust font size
                ),
                trailing: Row( // Use Row instead of Column
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      iconSize: 30, // Increase the size of the IconButton
                      icon: store.isLiked
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_border),
                      onPressed: () => toggleLike(store),
                    ),
                    Text(
                      '${store.totalLikes} Likes',
                      style: TextStyle(fontSize: 14), // Adjust font size
                    ),
                  ],
                ),
                onTap: () {
                  // Navigate to a detailed store page
                  // You can pass the store object to the next page to display more details
                },
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.white, // White background color
    );
  }
}

// Define main() function to run the app
void main() {
  runApp(const MaterialApp(
    home: StoresPage(),
  ));
}

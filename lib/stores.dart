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
  @override
  _StoresPageState createState() => _StoresPageState();
}

// Define _StoresPageState class
class _StoresPageState extends State<StoresPage> {
  List<Store> stores = [];
  String? userId; // Store user ID retrieved from session
  final storage = FlutterSecureStorage(); // Instance of Flutter Secure Storage

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
        // Fetch user likes after loading stores
        await getUserId(); // Retrieve user ID
        await fetchUserLikes(); // Fetch user likes
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

  // Method to fetch user likes from the server
  Future<void> fetchUserLikes() async {
    try {
      // Make POST request to fetch user likes with user ID from session
      final response = await http.post(
        Uri.parse('http://192.168.1.5/ansar_portal/api/fetch_user_likes.php'),
        body: {'user_id': userId},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body); // Changed to Map
        setState(() {
          // Update isLiked property for each store based on user likes
          stores.forEach((store) {
            final isLiked = jsonResponse['liked_stores'].contains(store.id.toString());
            print('Store ${store.id} isLiked: $isLiked');
            store.isLiked = isLiked;
          });
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
          'user_id': userId,
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
          // Save the updated liked status locally
          saveLikedStatus(store.id.toString(), store.isLiked);
        });
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
    getUserId(); // Retrieve user ID
    fetchUserLikes(); // Fetch user likes
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
        title: Text('Stores'),
      ),
      body: ListView.builder(
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final store = stores[index];
          final String firstImage = store.images.isNotEmpty ? store.images.first : ''; // Get the first image URL
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(firstImage), // Display the first image as the leading avatar
            ),
            title: Text(store.name),
            subtitle: Text(store.description),
            trailing: IconButton(
              icon: Icon(
                store.isLiked ? Icons.favorite : Icons.favorite_border, // Display filled heart if liked, otherwise outline heart
                color: store.isLiked ? Colors.red : null, // Red color if liked, null otherwise
              ),
              onPressed: () => toggleLike(store), // Toggle like/unlike on button press
            ),
            onTap: () {
              // Navigate to a detailed store page
              // You can pass the store object to the next page to display more details
            },
          );
        },
      ),
    );
  }
}

// Define main() function to run the app
void main() {
  runApp(MaterialApp(
    home: StoresPage(),
  ));
}

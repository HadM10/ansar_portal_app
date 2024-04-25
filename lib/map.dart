import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  bool _isLocationEnabled = false;

  // Set initial coordinates for the map
  final LatLng _center = const LatLng(33.8531, 35.8623); // Coordinates for Ansar village

  // Function to handle when the map is created
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    _checkLocationPermission();
  }

  // Function to check and request location permissions
  Future<void> _checkLocationPermission() async {
    final PermissionStatus status = await Permission.locationWhenInUse.status;
    if (status.isGranted) {
      setState(() {
        _isLocationEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MAP',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'kuro',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrange[700], // Dark orange background color
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: {
          // Add a marker for Ansar Village
          Marker(
            markerId: const MarkerId('ansar'),
            position: _center,
            infoWindow: const InfoWindow(
              title: 'Ansar Village',
              snippet: 'Welcome to Ansar!',
            ),
          ),
        },
        myLocationEnabled: _isLocationEnabled, // Enable MyLocation layer based on permission
      ),
    );
  }
}

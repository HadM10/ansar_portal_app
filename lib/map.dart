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
  MapType _currentMapType = MapType.normal;

  // Set initial coordinates for the map
  final LatLng _center = const LatLng(33.376495361328125, 35.360782623291016); // Coordinates for Ansar, Lebanon

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

  // Function to toggle map type
  void _toggleMapType() {
    setState(() {
      _currentMapType = (_currentMapType == MapType.normal) ? MapType.satellite : MapType.normal;
    });
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
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0, // Adjust the zoom level to match the HTML map
            ),
            mapType: _currentMapType,
            markers: {
              // Add a marker for Ansar, Lebanon
              Marker(
                markerId: const MarkerId('ansar'),
                position: _center,
                infoWindow: const InfoWindow(
                  title: 'Ansar, Lebanon',
                  snippet: 'Welcome to Ansar!',
                ),
              ),
            },
            myLocationEnabled: _isLocationEnabled, // Enable MyLocation layer based on permission
          ),
          Positioned(
            top: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: _toggleMapType,
              backgroundColor: Colors.deepOrange[700],
              child: Icon(
                _currentMapType == MapType.normal ? Icons.satellite : Icons.map,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

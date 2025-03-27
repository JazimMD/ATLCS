import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_first_app/services/location_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final LatLng destination;
  
  const MapScreen({Key? key, required this.destination}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  LatLng? _currentLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _openGoogleMaps() async {
    if (_currentLocation == null) return;

    final origin = Uri.encodeComponent('${_currentLocation!.latitude},${_currentLocation!.longitude}');
    final destination = Uri.encodeComponent('${widget.destination.latitude},${widget.destination.longitude}');
    
    // For Android and iOS
    final mobileUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving'
    );
    
    // For web fallback
    final webUrl = Uri.parse(
      'https://www.google.com/maps?saddr=$origin&daddr=$destination'
    );

    try {
      bool launched = await launchUrl(
        mobileUrl,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched) {
        // Try web URL as fallback
        launched = await launchUrl(
          webUrl,
          mode: LaunchMode.externalApplication,
        );
        
        if (!launched && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open Google Maps. Please make sure you have Google Maps installed.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening maps: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentLocation == null) {
      return const Scaffold(
        body: Center(child: Text('Unable to get current location')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.directions),
            onPressed: _openGoogleMaps,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.map,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Ready for Navigation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _openGoogleMaps,
              icon: const Icon(Icons.directions),
              label: const Text('Open in Google Maps'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

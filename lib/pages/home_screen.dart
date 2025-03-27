import 'package:flutter/material.dart';
import 'package:my_first_app/pages/map_screen.dart';
import 'package:my_first_app/pages/message_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_first_app/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng? _selectedDestination;

  @override
  Widget build(BuildContext context) {
    // If no destination is selected, show the message screen
    if (_selectedDestination == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Select Destination'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Auth().signOut();
              },
            ),
          ],
        ),
        body: MessageScreen(
          onDestinationSelected: (LatLng destination) {
            setState(() {
              _selectedDestination = destination;
            });
          },
        ),
      );
    }

    // If destination is selected, show the map screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Map'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _selectedDestination = null;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Auth().signOut();
            },
          ),
        ],
      ),
      body: MapScreen(destination: _selectedDestination!),
    );
  }
}

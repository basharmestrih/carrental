import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // Import for permission handling
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:latlong2/latlong.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String address = '';


  @override
  void initState() {
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body:  OpenStreetMapSearchAndPick(
              buttonTextStyle: const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
              buttonColor: Colors.blue,
              buttonText: 'Set Current Location',
              onPicked: (pickedData) {
                print(pickedData.latLong.latitude);
                print(pickedData.latLong.longitude);
                print(pickedData.address);
                print(pickedData.addressName);
              },
            )
          
    );
  }
}

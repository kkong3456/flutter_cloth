import 'package:cloth/data/weather.dart';
import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationPageState();
  }
}

class _LocationPageState extends State<LocationPage> {
  List<LocationData> locations = [
    LocationData(lat: 37.498122, lng: 127.027565, name: "강남구", x: 0, y: 0),
    LocationData(lat: 37.502418, lng: 127.853647, name: "동작구", x: 0, y: 0),
    LocationData(lat: 37.498122, lng: 127.027565, name: "마포구", x: 0, y: 0),
    LocationData(lat: 37.560502, lng: 127.907612, name: "성동구", x: 0, y: 0),
    LocationData(lat: 37.552288, lng: 127.145225, name: "강동구", x: 0, y: 0),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            child: ListView(
          children: List.generate(locations.length, (idx) {
            return ListTile(
                title: Text(locations[idx].name),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pop(locations[idx]);
                });
          }),
        )));
  }
}

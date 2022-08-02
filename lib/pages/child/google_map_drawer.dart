import 'package:flutter/material.dart';
import 'package:google_map_flutter/repository/location_repository.dart';

class GoogleMapDrawer extends StatefulWidget {
  const GoogleMapDrawer({Key? key}) : super(key: key);

  @override
  State<GoogleMapDrawer> createState() => _GoogleMapDrawerState();
}

class _GoogleMapDrawerState extends State<GoogleMapDrawer> {
  final TextEditingController _destinationController = TextEditingController();
  final LocationRepository locationRepository = LocationRepository();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10,
          left: 10,
          right: 10),
      child: Column(
        children: [
          TextField(
            controller: _destinationController,
            onSubmitted: (value){
              locationRepository.getPlace(value);
            },
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }
}

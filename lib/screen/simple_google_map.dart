import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const double CAMERA_ZOOM = 16;
const LatLng SOURCE_LOCATION = LatLng(42.747932,-71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685,-122.0605916);


class SimpleGoogleMap extends StatefulWidget {
  const SimpleGoogleMap({Key? key}) : super(key: key);

  @override
  State<SimpleGoogleMap> createState() => _SimpleGoogleMap();
}

class _SimpleGoogleMap extends State<SimpleGoogleMap> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};
// for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints? polylinePoints;
  String googleAPIKey = "AIzaSyBArz9lNJL16tlDEr_CuP0akLryqY__5-4";

  // for my custom marker pins
  BitmapDescriptor? originIcon;
  BitmapDescriptor? destinationIcon;
// the user's initial location and current location
// as it moves
  LocationData? currentLocation;
// a reference to the destination location
  LocationData? destinationLocation;
// wrapper around the location API
  Location? location;
  var pinPosition;
  var destPosition;


  @override
  void initState() {
    super.initState();

    // create an instance of Location
    location = Location();
    polylinePoints = PolylinePoints();

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location?.onLocationChanged.listen((LocationData currentPosition) {

      // current user's position in real time,
      currentLocation = currentPosition;

      // Get New Pin Marker for new Position on Map
      updatePinOnMap();
    });
    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    setInitialLocation();
  }

  void setSourceAndDestinationIcons() async {
    originIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/driving_pin.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location?.getLocation();

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });

    fixCameraPosition();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = const CameraPosition(
        zoom: CAMERA_ZOOM,
        target: SOURCE_LOCATION
    );
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng((currentLocation?.latitude ?? 0.0),
              (currentLocation?.longitude ?? 0.0 )),
          zoom: CAMERA_ZOOM,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map Flutter"),
        titleTextStyle: Theme.of(context).textTheme.headline5,
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: false,
            markers: _markers,
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              },
          )
        ],
      ),
    );
  }

  //Update Pin marker Current
  void updatePinOnMap() async {
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
        var pinPosition = LatLng((currentLocation?.latitude ?? 0.0),
          (currentLocation?.longitude ?? 0.0));

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere(
              (m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: const MarkerId('sourcePin'),
          position: pinPosition, // updated position
          icon: originIcon!
      ));
    });
  }

  void fixCameraPosition() async{
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      target: LatLng((currentLocation?.latitude ?? 0.0),
          (currentLocation?.longitude ?? 0.0)),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }

}

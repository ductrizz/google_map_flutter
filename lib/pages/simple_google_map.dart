import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_flutter/res/google_map_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';



class SimpleGoogleMap extends StatefulWidget {
  const SimpleGoogleMap({Key? key}) : super(key: key);

  @override
  State<SimpleGoogleMap> createState() => _SimpleGoogleMap();
}

class _SimpleGoogleMap extends State<SimpleGoogleMap> {
  final String googleAPIKey = "AIzaSyBArz9lNJL16tlDEr_CuP0akLryqY__5-4";
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};

// for my drawn routes on the map
  final Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  // for my custom marker pins
  late BitmapDescriptor originIcon;
  late BitmapDescriptor destinationIcon;

// the user's initial location and current location
  LocationData currentLocation = LocationData.fromMap({
    "latitude": 0.0,
    "longitude": 0.0,
  });
  LocationData destinationLocation = LocationData.fromMap({
    "latitude": 0.0,
    "longitude": 0.0,
  });
// wrapper around the location API
  Location location = Location();


  @override
  void initState() {
    super.initState();
    // by "listening" to the location's onLocationChanged event
    setInitialLocation();
    setSourceAndDestinationIcons();

    location.onLocationChanged.listen((LocationData newCurrentLocation) {
      // current user's position in real time,
      currentLocation = newCurrentLocation;
      // Get New Pin Marker for new Position on Map
      updatePinOnMap();
    });
  }

  void setSourceAndDestinationIcons() async {
    originIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5,),
        "assets/user_location_marker.png");

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
  }

  void setInitialLocation() async {
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();

    // hard-coded destination for this example
    destinationLocation = await LocationData.fromMap({
      "latitude": (currentLocation.latitude ?? destiLocation.latitude) + 0.005,
      "longitude": (currentLocation.longitude ?? destiLocation.longitude) + 0.001,
    });
    print("currentLocation : ${currentLocation.latitude} , ${currentLocation.longitude}");
    print("destinationLocation : ${destinationLocation.latitude} , ${destinationLocation.longitude}");
    fixCameraPosition();
    showPinsOnMap();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = const CameraPosition(
        zoom: cameraZoom,
        target: sourceLocation
    );
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude!,
              currentLocation.longitude!),
          zoom: cameraZoom,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map Flutter"),
        titleTextStyle: Theme.of(context).textTheme.headline5,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              setPolylines();
            });
            },
              icon: Icon(Icons.double_arrow_rounded))
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: FloatingActionButton(
          child: const Icon(Icons.my_location_outlined),
          onPressed: (){
            fixCameraPosition();
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: false,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
            polylines: _polylines,
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              },
          ),
          Positioned(
            bottom: 10,
              right: 100,
              left: 100,
              child: Container(
                alignment: Alignment.center,
                height: 40,
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Text("X: ${currentLocation.latitude} \nY: ${currentLocation.longitude}",
                textAlign: TextAlign.justify,
                overflow: TextOverflow.visible,),
              )),
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
        var pinPosition = LatLng((currentLocation.latitude ?? 0),
          (currentLocation.longitude ?? 0));

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere(
              (m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: const MarkerId('sourcePin'),
          position: pinPosition, // updated position
          icon: originIcon
      ));
    });
  }

  void fixCameraPosition() async{
    CameraPosition cPosition = CameraPosition(
      zoom: cameraZoom,
      target: LatLng(
          (currentLocation.latitude ?? 0.0),
          (currentLocation.longitude ?? 0.0)
      ),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }

  void setPolylines() async  {
    polylineCoordinates.clear();
    //Set point in Polyline
    PointLatLng _origin = PointLatLng(
        (currentLocation.latitude ?? 0) ,
        (currentLocation.longitude ?? 0));
    PointLatLng _destination = PointLatLng(
        (destinationLocation.latitude ?? 0) ,
        (destinationLocation.longitude ?? 0));
    print("Polyline ::Origin: ${currentLocation.latitude}, ${currentLocation.longitude} => Dest: ${destinationLocation.latitude}, ${destinationLocation.longitude}");
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        _origin,
        _destination,
        travelMode: TravelMode.driving,);
    print('result Length :: ${result.points.length}');
    if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point){
        polylineCoordinates.add(
            LatLng(point.latitude, point.longitude)
        );
        print('point :: ${point.latitude} , ${point.longitude}');
      });
      // Add polyline
      _addPolylines();
      polylineCoordinates.forEach((element) {
        print('point Polyline :: ${element.latitude}, ${element.longitude} ');
      });

    }
  }

  void _addPolylines(){
    setState(() {
      _polylines.add(Polyline(
          width: 6, // set the width of the polylines
          polylineId: const PolylineId("poly"),
          color: const Color.fromARGB(255, 255, 0, 0),
          points: polylineCoordinates
      ));
    });
  }
  void showPinsOnMap() {
    // get a LatLng for the source location from the LocationData currentLocation object
    var pinPosition = LatLng((currentLocation.latitude ?? 0),
        currentLocation.longitude ?? 0);
    // get a LatLng out of the LocationData object
    var destPosition = LatLng((destinationLocation.latitude ?? 0),
        (destinationLocation.longitude ?? 0));
    print("destPosition :: ${destPosition.latitude}, ${destPosition.longitude}");
    print("pinPosition :: ${pinPosition.latitude}, ${pinPosition.longitude}");
    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: originIcon
    ));
    // destination pin
    _markers.add(Marker(
        markerId: const MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon
    ));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolylines();
  }

}

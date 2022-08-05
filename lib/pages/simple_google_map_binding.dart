import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_map_flutter/repository/people_nearby_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../res/google_map_core.dart';

class SimpleGoogleMapBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SimpleGoogleMapController());
  }
}

class SimpleGoogleMapController extends GetxController{
///Properties
  final PeopleNearbyRepository _peopleNearbyRepository = PeopleNearbyRepository();
  final Rx<Completer<GoogleMapController>>  mapController = Completer<GoogleMapController>().obs;
  var initialCameraPosition = const CameraPosition(
    target: LatLng(28.527582, 77.0688971),
    zoom: 16,
  ).obs;

  RxSet<Marker> markers = <Marker>{}.obs;

  // for my drawn routes on the map
  RxSet<Polyline> polyLines = <Polyline>{}.obs;
  List<LatLng> polylineCoordinates = <LatLng>[];
  PolylinePoints polylinePoints = PolylinePoints();

  // for my custom marker pins
  late BitmapDescriptor originIcon;
  late BitmapDescriptor destinationIcon;

  // the user's initial location and current location
  Rx<LocationData> currentLocation = LocationData.fromMap({
    "latitude": 0.0,
    "longitude": 0.0,
  }).obs;

  Rx<LocationData> destinationLocation = LocationData.fromMap({
    "latitude": 0.0,
    "longitude": 0.0,
  }).obs;

  // wrapper around the location API
  Location location = Location();
///LifeCircle
  @override
  void onInit() async{
    super.onInit();
    setInitialLocation();
    await setSourceAndDestinationIcons();
    await _peopleNearbyRepository.getHttpPeopleNearby();
  }

  @override
  void onReady() {
    super.onReady();
    //Call Location
    location.onLocationChanged.listen((LocationData newCurrentLocation) {
      currentLocation = newCurrentLocation.obs;
      initialCameraPosition = CameraPosition(
        target: LatLng(
            currentLocation.value.latitude ?? 0,
            currentLocation.value.longitude ?? 0 ),
        zoom: 16,
      ).obs;
      // Get New Pin Marker for new Position on Map
      updatePinOnMap();
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

///Main Function:



///Create Polyline & Pin Marker

 //Set Icon Bitmap.
  Future<void> setSourceAndDestinationIcons() async {
    originIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5,),
        "assets/user_location_marker.png");

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
  }
  //Set InitialLocation.
  void setInitialLocation() async {
    // current location from the location's getLocation()
    currentLocation = (await location.getLocation()).obs;

    destinationLocation = (await LocationData.fromMap({
      "latitude": (currentLocation.value.latitude ?? destiLocation.latitude) + 0.005,
      "longitude": (currentLocation.value.longitude ?? destiLocation.longitude) + 0.001,
    })).obs;

    showPinsOnMap();
    fixCameraPosition();
  }

  //Update Pin marker Current
  void updatePinOnMap() async {
      // updated position
      var pinPosition = LatLng(
          currentLocation.value.latitude ?? 0,
          currentLocation.value.longitude ?? 0);

      markers.removeWhere(
              (m) => m.markerId.value == PinMarker.sourcePin.name);

      _addMarket(
        markerId: PinMarker.sourcePin,
        position: pinPosition,
        iconMarker: originIcon,
      );
  }

  void fixCameraPosition() async{
    CameraPosition cPosition = CameraPosition(
      zoom: cameraZoom,
      target: LatLng(
          (currentLocation.value.latitude ?? 0),
          (currentLocation.value.longitude ?? 0)
      ),
    );
    final controller = (await mapController.value.future);
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }

  void addPolylines() async  {
    polylineCoordinates.clear();
    List<PointLatLng> listPolyLinesPoint = (await _polyLinePoints(
      origin: currentLocation.value,
      destination: destinationLocation.value
    )).points;
    if(listPolyLinesPoint.isNotEmpty){
      for (var point in listPolyLinesPoint) {
        polylineCoordinates.add(
            LatLng(point.latitude, point.longitude)
        );
      }
      // Add polyline
      polyLines.add(Polyline(
          width: 6, // set the width of the polylines
          polylineId: const PolylineId("poly"),
          color: const Color.fromARGB(255, 255, 0, 0),
          points: polylineCoordinates
      )).obs;
      polylineCoordinates.forEach((element) {
        print('point Polyline :: ${element.latitude}, ${element.longitude} ');
      });
    }
  }

  void showPinsOnMap() {
    // get a LatLng for the source location from the LocationData currentLocation object
    var pinPosition = LatLng(
        currentLocation.value.latitude ?? 0,
        currentLocation.value.longitude ?? 0);
    // get a LatLng out of the LocationData object
    var destPosition = LatLng(
      destinationLocation.value.latitude  ?? 0,
      destinationLocation.value.longitude ?? 0);
    // add the initial source location pin
    _addMarket(
      markerId: PinMarker.sourcePin,
      position: pinPosition,
      iconMarker: originIcon,
    );
    // destination pin
    _addMarket(
      markerId: PinMarker.destPin,
      position: destPosition,
      iconMarker: destinationIcon,
    );
    addPolylines();
  }

///Private Func
  Future<PolylineResult> _polyLinePoints({
    required LocationData origin,
    required LocationData destination,
  }) async  {
    //Set point in Polyline
    PointLatLng _origin = PointLatLng(
        (origin.latitude ?? 0) ,
        (origin.longitude ?? 0));
    PointLatLng _destination = PointLatLng(
        (destination.latitude ?? 0) ,
        (destination.longitude ?? 0));
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      _origin,
      _destination,
      travelMode: TravelMode.driving,);
    return result;
  }

   _addMarket({
    required PinMarker markerId,
    required LatLng position,
    BitmapDescriptor iconMarker = BitmapDescriptor.defaultMarker,
  }){
    markers.value.add(Marker(
        markerId: MarkerId(markerId.name),
        position: position,
        icon: iconMarker
    ));
  }

}

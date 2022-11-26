import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../model/Data.dart';
import '../repository/nearby_repository.dart';
import '../res/bitmap_descriptor_cus.dart';
import '../res/calculator.dart';
import '../res/google_map_core.dart';

class SimpleGoogleMapBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SimpleGoogleMapController());
  }
}

class SimpleGoogleMapController extends GetxController{
///Properties
  final NearbyRepository _nearbyRepository = NearbyRepository();
  final BitmapDescriptorCus bitmapDescriptorCus = BitmapDescriptorCus();
  List<Data> peopleNearby = [];
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
  Location location = Location();
  //
  Rx<LocationData> currentLocation = LocationData.fromMap({
    "latitude": 0.0,
    "longitude": 0.0,
  }).obs;

///LifeCircle
  @override
  void onInit() async{
    super.onInit();
    await getResponse();
    await setInitialLocation();
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

  Future<void> getResponse()async {
    await _nearbyRepository.getPostman();
    peopleNearby = _nearbyRepository.peopleNearby;
  }



///Main Function:

///Create Polyline & Pin Marker

  //Set InitialLocation.
  Future<void> setInitialLocation() async {
    // current location from the location's getLocation()
    currentLocation = (await location.getLocation()).obs;
    var marker = await _nearbyRepository.addOrigin(LatLng(
        currentLocation.value.latitude ?? 0,
        currentLocation.value.longitude ??0
    ));
    markers.value.add(
        marker
    );
    fixCameraPosition();
    showDataNearby();
  }

  //Update Pin marker Current
  void updatePinOnMap() async {
      // updated position
      var pinPosition = LatLng(
          currentLocation.value.latitude ?? 0,
          currentLocation.value.longitude ?? 0);
      markers.value.removeWhere(
              (m) => m.markerId.value == PinMarker.originPin.name);
      Marker marker = await _nearbyRepository.addOrigin(pinPosition);
      markers.value.add(marker);
  }

  void showDataNearby({Distance? distance})async{
    var listNearby = await _nearbyRepository.showNearby(
      distance: distance,
        originPointLat: currentLocation.value.latitude ?? 0 ,
        originPointLong: currentLocation.value.longitude ?? 0);

    for (var index = 0; index < listNearby.length; index++){
      var data = listNearby[index];
      var geolocation = data.geolocation?.convertLatLng;
      LatLng position = LatLng(geolocation?.latitude ?? 0, geolocation?.longitude ?? 0);
      String imgUrl = data.avatar ?? "";
      markers.value.add(
        await _nearbyRepository.addNearMarker(
          index: index,
          position: position, imgUrl: imgUrl,
          onTap: (){
          addPolylines(destiLocation: position);
          },
        )
      );
    }
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

  void addPolylines({required LatLng destiLocation}) async  {
    polylineCoordinates.clear();
    List<PointLatLng> listPolyLinesPoint = (await _polyLinePoints(
        origin: currentLocation.value,
        destination: LocationData.fromMap({
          "latitude" : destiLocation.latitude,
          "longitude" : destiLocation.longitude
        })
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
      double totalCalculator = 0;
      for(int i=0; i < (polylineCoordinates.length -1); i++){
        var point1 = polylineCoordinates[i];
        var point2 = polylineCoordinates[i + 1];
        totalCalculator += double.parse(calculatorDistance(
            point1.latitude, point1.longitude,
            point2.latitude, point2.longitude,
            "K"));
      }
      var indexCenter = (polylineCoordinates.length/2).ceil();
      var positionCenter = polylineCoordinates[indexCenter];

      markers.value.removeWhere(
              (m) => m.markerId.value == "kmIcon");
      BitmapDescriptor kmIcon = await bitmapDescriptorCus.forText("${totalCalculator.toStringAsFixed(2)} km");
      markers.value.add(
          Marker(
            markerId: const MarkerId("kmIcon"),
            position: positionCenter,
            icon: kmIcon,
          ));
    }
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

}

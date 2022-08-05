import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const String googleApiKey = "AIzaSyBArz9lNJL16tlDEr_CuP0akLryqY__5-4";
const double cameraZoom = 16;
const LatLng sourceLocation = LatLng(50.747932,-71.167889);
const LatLng destiLocation = LatLng(37.4219983 , -122.094);

enum PinMarker{
  sourcePin,
  destPin,
}

extension PinMarkerNameExt on  PinMarker{
  String get name {
    switch (this) {
      case PinMarker.sourcePin:
        return 'sourcePin';
      case PinMarker.destPin:
        return 'destPin';
      default:
        return 'destPin';
    }
  }
}



extension GeolocationCaculator on String{
  LocationData get locationData {
    List listValue = split(',');
    LocationData locationData = LocationData.fromMap({
      "latitude": listValue[0],
      "longitude": listValue[1],
    });
    return locationData;
  }
}
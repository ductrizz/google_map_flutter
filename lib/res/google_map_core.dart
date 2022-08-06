import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const String googleApiKey = "AIzaSyBArz9lNJL16tlDEr_CuP0akLryqY__5-4";
const double cameraZoom = 16;
const LatLng sourceLocation = LatLng(50.747932,-71.167889);
const LatLng destiLocation = LatLng(37.4219983 , -122.094);

enum PinMarker{
  originPin,
  destPin,
}

extension PinMarkerNameExt on  PinMarker{
  String get name {
    switch (this) {
      case PinMarker.originPin:
        return 'originPin';
      case PinMarker.destPin:
        return 'destPin';
      default:
        return 'destPin';
    }
  }
}



extension GeolocationCaculator on String{
  LocationData get locationData {
    List listValue = this.split(',');
    LocationData locationData = LocationData.fromMap({
      "latitude": double.parse(listValue[0]),
      "longitude": double.parse(listValue[1]),
    });
    return locationData;
  }
}

enum Distance{
  km3,
  km5,
}

extension DistanceExt on  Distance{
  String get name {
    switch (this) {
      case Distance.km3:
        return 'km3';
      case Distance.km5:
        return 'km5';
      default:
        return 'null';
    }
  }
}
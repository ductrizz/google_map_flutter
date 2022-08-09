import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_flutter/model/Data.dart';
import 'package:google_map_flutter/model/Nearby_entity.dart';
import 'package:google_map_flutter/model/polyline_entity.dart';
import 'package:google_map_flutter/res/bitmap_descriptor_cus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:label_marker/label_marker.dart';

import '../res/caculator.dart';
import '../res/google_map_core.dart';

class NearbyRepository{
  List<Data> peopleNearby = [];
  BitmapDescriptorCus bitmapDescriptorCus = BitmapDescriptorCus();

  Future<void> getPostman() async{
    var request = http.Request('POST', Uri.parse('https://mamajoi.com/api/mamajoi/nearby'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String stringEntity = await response.stream.bytesToString(); //get Stream Data to String
      //convert String to Json
      var repositoryNearby = convert.jsonDecode(stringEntity);
      var people = NearbyEntity.fromJson(repositoryNearby);
      //
      peopleNearby.clear();
      people.data?.forEach((element) {
        peopleNearby.add(Data.fromJson(element));
        print("data Nearby :: ${Data.fromJson(element).toString()}");
      });
    }
    else {
      print("getPostman Failure :: ${response.reasonPhrase}");
    }
  }


  Future<List<Data>> showNearby({
    Distance? distance,
    required double originPointLat,
    required double originPointLong,
  })async{
    List<Data> filterNearby = [];
    List<Marker> markers = [];
    if(distance?.name == Distance.km3.name){
      filterNearby = peopleNearby.where((data){
        var geolocation = data.geolocation?.convertLatLng;
        double distance = double.parse(calculatorDistance(
            originPointLat,
            originPointLong,
            geolocation?.latitude ?? 0,
            geolocation?.longitude ?? 0,
            "K"
        ));
        return distance <= 3.0;
      }).toList();
    }else if(distance?.name == Distance.km5.name){
      filterNearby = peopleNearby.where((data){
        var geolocation = data.geolocation?.convertLatLng;
        double distance = double.parse(calculatorDistance(
            originPointLat,
            originPointLong,
            geolocation?.latitude ?? 0,
            geolocation?.longitude ?? 0,
            "K"
        ));
        return distance <= 5.0;
      }).toList();
    }else{
      filterNearby = peopleNearby;
    }
    /*for(var i = 0; i < filterNearby.length; i++){
      var data = filterNearby[i];
      var nearbyLocation = data.geolocation?.convertLatLng;
      print("positionNearby ${i} :: ${nearbyLocation?.latitude} , ${nearbyLocation?.longitude}");
    }*/
    return Future.value(
        filterNearby
    );
  }

  Future<Marker> addNearMarker({required int index, required LatLng position,required String imgUrl, VoidCallback? onTap})async{
    BitmapDescriptor nearbyIcon = await bitmapDescriptorCus.fromNetworkImage(imgUrl: imgUrl);
    Marker marker = Marker(
        markerId: MarkerId("${PinMarker.destPin.name}_$index"),
        position: position,
        icon: nearbyIcon,
        onTap: onTap,
    );
    return Future.value(
        marker
    );
  }

  Future<Marker> addOrigin(LatLng currentLocation)async{
    BitmapDescriptor originIcon = await bitmapDescriptorCus.fromAssetImage("assets/user_location_marker.png");
    Marker marker = Marker(
            markerId: MarkerId(PinMarker.originPin.name),
            position: currentLocation,
            icon: originIcon
        );
    return Future.value(
      marker
    );
  }
}
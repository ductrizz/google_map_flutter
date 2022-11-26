import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_flutter/pages/simple_google_map.dart';
import 'package:google_map_flutter/pages/simple_google_map_binding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  //runApp(const MyApp());
  runApp(GetMaterialApp(
    initialRoute: '/',
    initialBinding: SimpleGoogleMapBinding(),
    getPages: [
      GetPage(
        name: '/',
        page: () => SimpleGoogleMap(),
        binding: SimpleGoogleMapBinding(),
      ),
    ],
  ));
}

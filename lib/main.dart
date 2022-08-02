import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_map_flutter/pages/simple_google_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  /*if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SimpleGoogleMap(),
    );
  }
}



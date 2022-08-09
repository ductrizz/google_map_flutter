import 'dart:typed_data';
import 'dart:ui';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BitmapDescriptorCus {

  Future<BitmapDescriptor> fromAssetImage(String assetPath) async{
    BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5, size: Size(20,30)),
        assetPath
    );
    return bitmapDescriptor;
  }

  /*Future<BitmapDescriptor> fromNetworkImage({required String imgUrl}) async{
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgUrl)).load(imgUrl)).buffer.asUint8List();
    BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromBytes(bytes);
    return Future.value(bitmapDescriptor);
  }*/
 Future<BitmapDescriptor> fromNetworkImage({required String imgUrl}) async{
   Uint8List bytes = await getBytesFromNetWork(imgUrl , 120);
   BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromBytes(bytes);
    return Future.value(bitmapDescriptor);
 }

  Future<BitmapDescriptor> forText(String content) async{
    BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5, size: Size(50,100)),
        content
    );
    return bitmapDescriptor;
  }

  Future<Uint8List> getBytesFromNetWork(String imgUrl,int width)async {
    //ByteData data = await rootBundle.load(path);
    ByteData data = await NetworkAssetBundle(Uri.parse(imgUrl)).load(imgUrl);
    Codec codec = await instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: width
    );
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
        format: ImageByteFormat.png))!
        .buffer.asUint8List();
  }

}
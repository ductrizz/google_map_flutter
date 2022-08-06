import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> createCustomMarkerBitmap(String title) async {
  TextSpan span = TextSpan(
    style: const TextStyle(
      color: Colors.red,
      fontSize: 35.0,
      fontWeight: FontWeight.bold,
    ),
    text: title,
  );

  TextPainter tp = TextPainter(
    text: span,
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  tp.text = TextSpan(
    text: title,
    style: const TextStyle(
      fontSize: 40.0,
      color: Colors.red,
      letterSpacing: 1.0,
    ),
  );

  PictureRecorder recorder = PictureRecorder();
  Canvas c = Canvas(recorder);

  tp.layout();
  tp.paint(c, const Offset(20.0, 10.0));

  /* Do your painting of the custom icon here, including drawing text, shapes, etc. */

  Picture p = recorder.endRecording();
  ByteData? pngBytes =
  await (await p.toImage(tp.width.toInt() + 40, tp.height.toInt() + 20))
      .toByteData(format: ImageByteFormat.png);

  Uint8List data = Uint8List.view(pngBytes!.buffer);

  return BitmapDescriptor.fromBytes(data);
}
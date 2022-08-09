import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';

class PolylineEntity{
  List<Polyline> polyLines = <Polyline>[];
  LabelMarker marker;

  PolylineEntity(this.polyLines, this.marker);
}
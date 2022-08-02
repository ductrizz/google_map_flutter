import 'package:google_map_flutter/res/google_map_core.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationRepository{
  String key = googleApiKey;
  Future<String> getPlaceId(String input) async{
    final String url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key";
    print("url 1 : $url");
    var repose = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(repose.body);
    var placeId = json['candidates'][0]["place_id"] as String;
    print("placeId 1 :: $placeId");
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async{
    final String placeId = await getPlaceId(input);
    final String url =
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?place_id=$placeId&key=$key";
    var repose = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(repose.body);
    var results = json['results'] as Map<String, dynamic>;
    print("url 2 : $url");
    print("results :: ${results.toString()}");

    return results;
  }


}
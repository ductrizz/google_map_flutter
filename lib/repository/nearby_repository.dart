import 'package:google_map_flutter/model/Data.dart';
import 'package:google_map_flutter/model/Nearby_entity.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class NearbyRepository{
  List<Data> peopleNearby = [];

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
}
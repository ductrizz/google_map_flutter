import 'package:dio/dio.dart';
import 'package:google_map_flutter/model/people_nearby.dart';
import 'package:google_map_flutter/model/person_nearby.dart';
import 'package:google_map_flutter/res/base_dio.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PeopleNearbyRepository{
  PeopleNearby? peopleNearby;
  PersonNearby? personNearby;
  Dio dio = Dio();

  Future<void> getPeopleNearby() async{
    const String _urlAPI = "https://mamajoi.com/api/mamajoi/nearby";
    var repository = await dio.get(_urlAPI);
    print("repository :: ${repository.data}");
    //personNearby = repository.data;
  }
  Future<void> getHttpPeopleNearby()async{
    String _url = "https://mamajoi.com/api/mamajoi/nearby";
    var uri = Uri(
        scheme: 'https',
        host: 'mamajoi.com',
        path: 'api/mamajoi',
        fragment: 'nearby');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = PeopleNearby.fromJson(jsonResponse);
      print('Number of books about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
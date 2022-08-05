import 'person_nearby.dart';

class PeopleNearby{
  String? success;
  String? option;
  List? peopleNearby;

  PeopleNearby({this.success, this.option, this.peopleNearby});

  Map<String, dynamic> toJson(){
    return {
      "success" : success  ,
      "option" : option,
      "peopleNearby" : peopleNearby as dynamic,
    };
  }

  PeopleNearby.fromJson(dynamic json) : this(
      success: json["success"],
      option: json["option"],
      peopleNearby: json["peopleNearby"] as List,
  );

  @override
  String toString() {
    return 'PeopleNearby{success: $success, option: $option, peopleNearby: $peopleNearby}';
  }
}
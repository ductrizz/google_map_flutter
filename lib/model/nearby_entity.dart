import 'Data.dart';

/// success : true
/// option : null
/// data : [{"name":"Nguyễn Thanh Hoàng","avatar":"https://mamajoi.com/storage/app/public/users/202206101805039805.png","email":"hoangnt@gmail.com","phone":"0911223344","geolocation":"10.789914997439512,106.67758134073166"},{"name":"Nguyễn Thanh Hùng","avatar":"https://mamajoi.com/storage/app/public/users/default.png","email":"hungnt@gmail.com","phone":null,"geolocation":"10.782560865168708,106.68333361113244"},{"name":"Thợ 1","avatar":"https://mamajoi.com/storage/app/public/users/default.png","email":"firstbeauty@gmail.com","phone":null,"geolocation":"10.803733163966289,106.66123925098577"},{"name":"Thợ 2","avatar":"https://mamajoi.com/storage/app/public/users/default.png","email":"secondbeauty@gmail.com","phone":null,"geolocation":"10.80060614635197,106.67086271566252"},{"name":"Thợ 3","avatar":"https://mamajoi.com/storage/app/public/users/default.png","email":"thirdbeauty@gmail.com","phone":null,"geolocation":"10.792339161389872,106.66332494485106"}]
/// message : "User retrieved successful"

class NearbyEntity {
  bool? success;
  dynamic option;
  List<dynamic>? data;
  String? message;

  NearbyEntity({
      this.success,
      this.option,
      this.data, 
      this.message,});

  /*NearbyEntity.fromJson(dynamic json) {
    success = json['success'] as bool;
    option = json['option'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }*/
  NearbyEntity.fromJson(dynamic json) : this(
      success : json['success'],
      option : json['option'],
      data : json['data'],
      message : json['message'],
  );


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['option'] = option;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    return map;
  }

}
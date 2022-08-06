/// name : "Nguyễn Thanh Hoàng"
/// avatar : "https://mamajoi.com/storage/app/public/users/202206101805039805.png"
/// email : "hoangnt@gmail.com"
/// phone : "0911223344"
/// geolocation : "10.789914997439512,106.67758134073166"

class Data {
  String? name;
  String? avatar;
  String? email;
  String? phone;
  String? geolocation;
  Data({
      this.name, 
      this.avatar, 
      this.email, 
      this.phone, 
      this.geolocation,});

  Data.fromJson(dynamic json) {
    name = json['name'];
    avatar = json['avatar'];
    email = json['email'];
    phone = json['phone'];
    geolocation = json['geolocation'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['avatar'] = avatar;
    map['email'] = email;
    map['phone'] = phone;
    map['geolocation'] = geolocation;
    return map;
  }
  @override
  String toString() {
    return 'Data{name: $name, avatar: $avatar, email: $email, phone: $phone, geolocation: $geolocation}';
  }
}
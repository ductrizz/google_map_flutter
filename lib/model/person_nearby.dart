class PersonNearby{
  String? name;
  String? avatar;
  String? email;
  String? phone;
  String? geolocation;

  PersonNearby({
    required this.name,
    this.avatar,
    required this.email,
    this.phone,
    required this.geolocation});

  Map<String, dynamic> toJson(){
    return {
        "name" : name  ,
        "avatar" : avatar,
        "email" : email,
        "phone" : phone,
        "geolocation" : geolocation
    };
  }
  PersonNearby.fromJson(dynamic json) : this(
        name: json["name"],
        avatar: json["avatar"],
        email: json["email"],
        phone: json["phone"],
        geolocation: json["geolocation"],
    );

  @override
  String toString() {
    return 'PersonNearby{name: $name, avatar: $avatar, email: $email, phone: $phone, geolocation: $geolocation}';
  }
}
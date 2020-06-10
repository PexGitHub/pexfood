class UserModel {
  String id;
  String type;
  String name;
  String user;
  String password;
  String nameshop;
  String address;
  String phone;
  String urlpicture;
  String lat;
  String lng;
  String token;

  UserModel(
      {this.id,
      this.type,
      this.name,
      this.user,
      this.password,
      this.nameshop,
      this.address,
      this.phone,
      this.urlpicture,
      this.lat,
      this.lng,
      this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    user = json['user'];
    password = json['password'];
    nameshop = json['nameshop'];
    address = json['address'];
    phone = json['phone'];
    urlpicture = json['urlpicture'];
    lat = json['lat'];
    lng = json['lng'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['user'] = this.user;
    data['password'] = this.password;
    data['nameshop'] = this.nameshop;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['urlpicture'] = this.urlpicture;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['token'] = this.token;
    return data;
  }
}

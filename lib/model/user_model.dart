
class UserModel {
  String id;
  String type;
  String name;
  String user;
  String password;

  UserModel({this.id, this.type, this.name, this.user, this.password});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    user = json['user'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['user'] = this.user;
    data['password'] = this.password;
    return data;
  }
}

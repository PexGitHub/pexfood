class FoodModel {
  String id;
  String idShop;
  String nameFood;
  String pathImage;
  String price;
  String detail;

  FoodModel(
      {this.id,
      this.idShop,
      this.nameFood,
      this.pathImage,
      this.price,
      this.detail});

  FoodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idShop = json['idShop'];
    nameFood = json['nameFood'];
    pathImage = json['pathImage'];
    price = json['price'];
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idShop'] = this.idShop;
    data['nameFood'] = this.nameFood;
    data['pathImage'] = this.pathImage;
    data['price'] = this.price;
    data['detail'] = this.detail;
    return data;
  }
}

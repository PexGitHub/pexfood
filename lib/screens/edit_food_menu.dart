import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pexfood/model/food_model.dart';
import 'package:pexfood/utility/myconstant.dart';
import 'package:pexfood/utility/normal_dialog.dart';

class EditFoodMenu extends StatefulWidget {
  final FoodModel foodModel;
  EditFoodMenu({Key key, this.foodModel}) : super(key: key);

  @override
  _EditFoodMenuState createState() => _EditFoodMenuState();
}

class _EditFoodMenuState extends State<EditFoodMenu> {
  FoodModel foodModel;
  File file;
  String name, price, detail, pathImage;
  @override
  void initState() {
    super.initState();
    foodModel = widget.foodModel;
    name = foodModel.nameFood;
    price = foodModel.price;
    detail = foodModel.detail;
    pathImage = foodModel.pathImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: uploadButton(),
      appBar: AppBar(
        title: Text('ปรับปรุง เมนู ${foodModel.nameFood}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            nameFood(),
            groupImage(),
            priceFood(),
            detailFood(),
          ],
        ),
      ),
    );
  }

  FloatingActionButton uploadButton() {
    return FloatingActionButton(
      onPressed: () {
        if (name.isEmpty || price.isEmpty || detail.isEmpty) {
          normalDialog(context, 'กรุณากรอกให้ครบทุกช่อง');
        } else {
          confirmEdit();
        }
      },
      child: Icon(Icons.cloud_upload),
    );
  }

  Future<Null> confirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'คุณต้องการจะเปลี่ยนแปลงเมนูอาหารใช่ไหม',
        ),
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  editValueOnMySQL();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                label: Text('เปลี่ยนแปลง'),
              ),
              FlatButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Text('ไม่เปลี่ยนแปลง'),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<Null> editValueOnMySQL() async {
    String id = foodModel.id;
    String url =
        '${MyConstant().domain}/pexfood/editFoodWhereId.php?isAdd=true&nameFood=$name&pathImage=$pathImage&price=$price&detail=$detail&id=$id';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'กรุณาลองใหม่ มีอะไรผิดพลาด');
      }
    });
  }

  Widget groupImage() => Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseImage(ImageSource.camera),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            width: 250.0,
            height: 250.0,
            child: file == null
                ? Image.network(
                    '${MyConstant().domain}${foodModel.pathImage}',
                    fit: BoxFit.cover,
                  )
                : Image.file(file),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseImage(ImageSource.gallery),
          ),
        ],
      );
  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget nameFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 16.0),
              width: 250.0,
              child: TextFormField(
                onChanged: (value) => name = value.trim(),
                initialValue: name,
                decoration: InputDecoration(
                    labelText: 'ชื่อเมนูอาหาร', border: OutlineInputBorder()),
              )),
        ],
      );
  Widget priceFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 16.0),
              width: 250.0,
              child: TextFormField(
                onChanged: (value) => price = value.trim(),
                keyboardType: TextInputType.number,
                initialValue: price,
                decoration: InputDecoration(
                    labelText: 'ราคาอาหาร', border: OutlineInputBorder()),
              )),
        ],
      );
  Widget detailFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 16.0),
              width: 250.0,
              child: TextFormField(
                onChanged: (value) => detail.trim(),
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                initialValue: detail,
                decoration: InputDecoration(
                    labelText: 'รายละเอียดอาหาร', border: OutlineInputBorder()),
              )),
        ],
      );
}

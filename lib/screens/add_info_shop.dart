import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:pexfood/utility/myconstant.dart';
import 'package:pexfood/utility/mystyle.dart';
import 'package:pexfood/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInfoShop extends StatefulWidget {
  @override
  _AddInfoShopState createState() => _AddInfoShopState();
}

class _AddInfoShopState extends State<AddInfoShop> {
  double lat, lng;
  File file;
  String nameshop, address, phone;
  String urlpicture;

  @override
  void initState() {
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocation();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });
    print('lat = $lat  , lng = $lng');
  }

  Future<LocationData> findLocation() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Infomation Shop'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyStyle().mySizedBox(),
            nameForm(),
            MyStyle().mySizedBox(),
            addressForm(),
            MyStyle().mySizedBox(),
            phoneForm(),
            MyStyle().mySizedBox(),
            groupImage(),
            MyStyle().mySizedBox(),
            lat == null ? MyStyle().myProgressMap() : showMap(),
            MyStyle().mySizedBox(),
            saveButton()
          ],
        ),
      ),
    );
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      var pickImage = ImagePicker().getImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );
      var object = await pickImage;
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget saveButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        onPressed: () {
          if (nameshop == null ||
              nameshop.isEmpty ||
              address == null ||
              address.isEmpty ||
              phone == null ||
              phone.isEmpty) {
            normalDialog(context, 'กรุณากรอกทุกช่อง');
          } else if (file == null) {
            normalDialog(context, 'กรุณาเลือกรูปภาพ');
          } else {
            uploadImage();
          }
        },
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'Save Infomation',
          style: TextStyle(color: Colors.white),
        ),
        color: MyStyle().primaryColor,
      ),
    );
  }

  Future<Null> uploadImage() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameImage = 'shop$i.jpg';
    print('nameImage == $nameImage , pathImage == ${file.path}');
    String url = '${MyConstant().domain}/pexfood/saveShop.php';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) {
        print('Upload == $value');

        urlpicture = '/pexfood/shop/$nameImage';
        print('urlImage = $urlpicture');
        editUserShop();
      });
    } catch (e) {}
  }

  Future<Null> editUserShop() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    String url =
        '${MyConstant().domain}/pexfood/editDataWhereId.php?isAdd=true&id=$id&nameshop=$nameshop&address=$address&phone=$phone&urlpicture=$urlpicture&lat=$lat&lng=$lng';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'กรุณาลองใหม่ ไม่สามารถบันทึกได้');
      }
    });
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myShop'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
            title: 'SSP Tower', snippet: 'ละติจูด = $lat , ลองติจูด = $lng'),
      )
    ].toSet();
  }

  Container showMap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 16.0);

    return Container(
        height: 300.0,
        child: GoogleMap(
          markers: myMarker(),
          initialCameraPosition: cameraPosition,
          mapType: MapType.normal,
          onMapCreated: (controller) {},
        ));
  }

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.camera_alt,
              size: 36.0,
            ),
            onPressed: () => chooseImage(ImageSource.camera)),
        Container(
          width: 250.0,
          child: file == null
              ? Image.asset('images/myimage.png')
              : Image.file(file),
        ),
        IconButton(
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36.0,
          ),
          onPressed: () => chooseImage(ImageSource.gallery),
        )
      ],
    );
  }

  Widget nameForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextField(
            onChanged: (value) => nameshop = value.trim(),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ชื่อร้านค้า',
                prefixIcon: Icon(
                  Icons.account_box,
                )),
          ),
        ),
      ],
    );
  }

  Widget addressForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextField(
            onChanged: (value) => address = value.trim(),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ที่อยู่ร้านค้า',
                prefixIcon: Icon(
                  Icons.home,
                )),
          ),
        ),
      ],
    );
  }

  Widget phoneForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextField(
            onChanged: (value) => phone = value.trim(),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'เบอร์โทรร้านค้า',
                prefixIcon: Icon(
                  Icons.phone,
                )),
          ),
        ),
      ],
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:pexfood/model/user_model.dart';
import 'package:pexfood/utility/myconstant.dart';
import 'package:pexfood/utility/mystyle.dart';
import 'package:pexfood/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfoShop extends StatefulWidget {
  @override
  _EditInfoShopState createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  UserModel userModel;
  String nameshop, address, phone, urlpicture;
  Location location = Location();
  double lat, lng;
  File file;

  @override
  void initState() {
    super.initState();
    readCurrentInfoShop();

    location.onLocationChanged.listen((event) {
      setState(() {
        lat = event.latitude;
        lng = event.longitude;
        //print('lat = $lat , lng = $lng');
      });
    });
  }

  Future<Null> readCurrentInfoShop() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String shopId = preferences.getString('id');
    String url =
        '${MyConstant().domain}/pexfood/getuserwhereid.php?isAdd=true&id=$shopId';

    Response response = await Dio().get(url);

    var result = json.decode(response.data);
    print(result);
    for (var map in result) {
      print(map);
      setState(() {
        userModel = UserModel.fromJson(map);
        nameshop = userModel.nameshop;
        address = userModel.address;
        phone = userModel.phone;
        urlpicture = userModel.urlpicture;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ปรับปรุงรายละเอียดร้าน'),
      ),
      body: userModel == null ? MyStyle().myProgressMap() : showContent(),
    );
  }

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            nameShopForm(),
            showImage(),
            MyStyle().mySizedBox(),
            addressForm(),
            MyStyle().mySizedBox(),
            phoneForm(),
            lat == null ? MyStyle().myProgressMap() : showMap(),
            editButton()
          ],
        ),
      );

  Widget editButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        color: MyStyle().primaryColor,
        onPressed: () => confirmDialog(),
        icon: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        label: Text(
          'ปรับปรุงรายละเอียด',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> confirmDialog() {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณแน่ใจ ที่จะปรับปรุงรายละเอียดของร้าน'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                onPressed: () {
                  Navigator.pop(context);
                  editThread();
                },
                child: Text('แน่ใจ'),
              ),
              OutlineButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ไม่แน่ใจ'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> editThread() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String namefile = 'editShop$i.jpg';

    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file.path, filename: namefile);
    FormData formData = FormData.fromMap(map);

    String urlUpload = '${MyConstant().domain}/pexfood/saveShop.php';
    await Dio().post(urlUpload, data: formData).then((value) async {
      urlpicture = '/pexfood/shop/$namefile';

      String id = userModel.id;
      String url =
          '${MyConstant().domain}/pexfood/editDataWhereId.php?isAdd=true&id=$id&nameshop=$nameshop&address=$address&phone=$phone&urlpicture=$urlpicture&lat=$lat&lng=$lng';

      Response response = await Dio().get(url);

      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'อัพเดตไม่ได้ กรุณาลองใหม่');
      }
    });
  }

  Set<Marker> currentMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myMarker'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
            title: 'ร้านอยู่ที่นี่', snippet: 'Lat = $lat , Lng = $lng'),
      )
    ].toSet();
  }

  Container showMap() {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.0,
    );
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      height: 250.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) => {},
        markers: currentMarker(),
      ),
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );
      file = File(object.path);
    } catch (e) {}
  }

  Widget showImage() => Container(
        margin: EdgeInsetsDirectional.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: () => chooseImage(ImageSource.camera)),
            Container(
              width: 250.0,
              height: 250.0,
              child: file == null
                  ? Image.network('${MyConstant().domain}$urlpicture')
                  : Image.file(file),
            ),
            IconButton(
              icon: Icon(Icons.add_photo_alternate),
              onPressed: () => chooseImage(ImageSource.gallery),
            ),
          ],
        ),
      );

  Widget nameShopForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => nameshop = value,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ชื่อของร้าน'),
              initialValue: nameshop,
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => address = value,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ที่อยู่ของร้าน'),
              initialValue: address,
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => phone = value,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'เบอร์ติดต่อร้าน'),
              initialValue: phone,
            ),
          ),
        ],
      );
}

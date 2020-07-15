import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pexfood/model/user_model.dart';
import 'package:pexfood/screens/add_info_shop.dart';
import 'package:pexfood/screens/edit_info_shop.dart';
import 'package:pexfood/utility/myconstant.dart';
import 'package:pexfood/utility/mystyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationShop extends StatefulWidget {
  @override
  _InformationShopState createState() => _InformationShopState();
}

class _InformationShopState extends State<InformationShop> {
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  Future<Null> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');

    String url =
        '${MyConstant().domain}/pexfood/getuserwhereid.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) {
      // print('value = $value');
      var result = json.decode(value.data);
      //  print('result = $result');
      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
        });

        print('nameshop = ${userModel.nameshop}');

        if (userModel.nameshop.isEmpty) {
        } else {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        userModel == null
            ? MyStyle().myProgressMap()
            : userModel.nameshop.isEmpty
                ? showNoData(context)
                : showListInfoShop(),
        addeditButton(),
      ],
    );
  }

  Widget showListInfoShop() => Column(
        children: <Widget>[
          MyStyle().showTitle2('รายละเอียดร้าน ${userModel.nameshop}'),
          showImageShop(),
          Row(
            children: <Widget>[
              MyStyle().showTitle2('ที่อยู่ของร้าน'),
            ],
          ),
          Row(
            children: <Widget>[
              Text(userModel.address),
            ],
          ),
          MyStyle().mySizedBox(),
          showMapShop(),
        ],
      );

  Widget showMapShop() {
    double lat = double.parse(userModel.lat);
    double lng = double.parse(userModel.lng);

    LatLng latLng = LatLng(lat, lng);
    CameraPosition position = CameraPosition(target: latLng, zoom: 16.0);

    print(lng);
    return Expanded(
      //padding: EdgeInsets.all(10.0),
      // height: 300.0,
      child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: showMarker(),
      ),
    );
  }

  Set<Marker> showMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('shopId'),
        position:
            LatLng(double.parse(userModel.lat), double.parse(userModel.lng)),
        infoWindow: InfoWindow(
            title: 'ตำแหน่งร้าน',
            snippet:
                'ละติจูด = ${userModel.lat} , ลองติจูด = ${userModel.lng}'),
      )
    ].toSet();
  }

  Container showImageShop() {
    return Container(
        padding: EdgeInsets.all(10.0),
        width: 220.0,
        height: 220.0,
        child: Image.network('${MyConstant().domain}${userModel.urlpicture}'));
  }

  Widget showNoData(BuildContext context) {
    return MyStyle().titleCenter(context, 'ยังไม่มีข้อมูล กรุณาเพิ่มข้อมูล');
  }

  Row addeditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () => routeToAddInfo(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void routeToAddInfo() {
    Widget widget = userModel.nameshop.isEmpty ? AddInfoShop() : EditInfoShop();
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => widget);
    Navigator.of(context).push(route).then((value) => readDataUser());
  }
}

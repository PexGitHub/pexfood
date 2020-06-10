import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pexfood/model/user_model.dart';
import 'package:pexfood/screens/add_info_shop.dart';
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
                : Text('Have   Data'),
        addeditButton(),
      ],
    );
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
    MaterialPageRoute route =
        MaterialPageRoute(builder: (context) => AddInfoShop());
    Navigator.of(context).push(route);
  }
}

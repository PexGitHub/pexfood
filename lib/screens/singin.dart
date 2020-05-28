import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pexfood/model/user_model.dart';
import 'package:pexfood/screens/main_rider.dart';
import 'package:pexfood/screens/main_shop.dart';
import 'package:pexfood/screens/main_user.dart';
import 'package:pexfood/utility/mystyle.dart';
import 'package:pexfood/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingIn extends StatefulWidget {
  @override
  _SingInState createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  String user, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sing In'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: <Color>[Colors.white, MyStyle().primaryColor],
            radius: 1.0,
            center: Alignment(0, -0.3),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MyStyle().showLogo(),
                MyStyle().mySizedBox(),
                MyStyle().showTitle('Pex Food'),
                MyStyle().mySizedBox(),
                userForm(),
                MyStyle().mySizedBox(),
                passwordForm(),
                MyStyle().mySizedBox(),
                loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> checkAuthen() async {
    String url =
        'http://192.168.0.107:81/pexfood/getuserwhereuser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      var result = json.decode(response.data);
      print('result = $result');
      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (userModel.password == password) {
          String chooseType = userModel.type;
          if (chooseType == 'User') {
            routeToService(MainUser(), userModel);
          } else if (chooseType == 'Shop') {
            routeToService(MainShop(), userModel);
          } else if (chooseType == 'Rider') {
            routeToService(MainRider(), userModel);
          } else {
            normalDialog(context, 'Error');
          }
        } else {
          normalDialog(context, 'Password ไม่ถูกต้อง กรุณาลองใหม่');
        }
      }
    } catch (e) {}
  }

  Future<Null> routeToService(Widget myWidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', userModel.id);
    preferences.setString('type', userModel.type);
    preferences.setString('name', userModel.name);
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget loginButton() => Container(
      width: 250.0,
      child: RaisedButton(
        onPressed: () {
          if (user == null ||
              user.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'มีค่าว่าง กรุณากรอกให้ครบทุกช่อง');
          } else {
            checkAuthen();
          }
        },
        color: MyStyle().darkColor,
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ));

  Widget userForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
            labelText: 'User :',
            labelStyle: TextStyle(color: MyStyle().darkColor),
            prefixIcon: Icon(
              Icons.account_box,
              color: MyStyle().darkColor,
            ),
          ),
        ),
      );
  Widget passwordForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
            labelText: 'Password :',
            labelStyle: TextStyle(color: MyStyle().darkColor),
            prefixIcon: Icon(
              Icons.lock,
              color: MyStyle().darkColor,
            ),
          ),
        ),
      );
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pexfood/utility/mystyle.dart';
import 'package:pexfood/utility/normal_dialog.dart';

class SingUp extends StatefulWidget {
  @override
  _SingUpState createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  String chooseType, name, user, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          myLogo(),
          MyStyle().mySizedBox(),
          showAppName(),
          MyStyle().mySizedBox(),
          nameForm(),
          MyStyle().mySizedBox(),
          userForm(),
          MyStyle().mySizedBox(),
          passwordForm(),
          MyStyle().mySizedBox(),
          MyStyle().showTitle2('ชนิดของสมาชิก :'),
          MyStyle().mySizedBox(),
          userRadio(),
          shopRadio(),
          riderRadio(),
          MyStyle().mySizedBox(),
          registerButton(),
        ],
      ),
    );
  }

  Future<Null> checkUser() async {
    String url =
        'http://192.168.0.107:81/pexfood/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        registerThread();
      } else {
        normalDialog(
            context, 'User นี้ $user มีอยู่แล้วในระบบ กรุณาตั้งชื่อใหม่');
      }
    } catch (e) {}
  }

  Future<Null> registerThread() async {
    String url =
        'http://192.168.0.107:81/pexfood/addData.php?isAdd=true&name=$name&user=$user&password=$password&type=$chooseType';
    try {
      Response response = await Dio().get(url);
      print('res = $response');

      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ไม่สามารถสมัครได้ กรุณาลองใหม่อีกครั้ง');
      }
    } catch (e) {}
  }

  Widget registerButton() => Container(
      width: 250.0,
      child: RaisedButton(
        onPressed: () {
          print(
              'Name = $name , User = $user , Password = $password , ChooseType = $chooseType');
          if (name == null ||
              name.isEmpty ||
              user == null ||
              user.isEmpty ||
              password == null ||
              password.isEmpty) {
            print('Have Space');
            normalDialog(context, 'มีช่องว่าง กรุณากรอกให้ครบทุกช่อง');
          } else if (chooseType == null) {
            normalDialog(context, 'โปรดเลือกชนิดของผู้สมัคร');
          } else {
            checkUser();
          }
        },
        color: MyStyle().darkColor,
        child: Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
      ));

  Widget userRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: 250.0,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'User',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text(
                  'ผู้สั่งอาหาร',
                  style: TextStyle(color: MyStyle().darkColor),
                )
              ],
            ),
          ),
        ],
      );
  Widget shopRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: 250.0,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'Shop',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text(
                  'เจ้าของร้านอาหาร',
                  style: TextStyle(color: MyStyle().darkColor),
                )
              ],
            ),
          ),
        ],
      );
  Widget riderRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: 250.0,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'Rider',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text(
                  'ผู้ส่งอาหาร',
                  style: TextStyle(color: MyStyle().darkColor),
                )
              ],
            ),
          ),
        ],
      );
  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => name = value.trim(),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
                labelText: 'Name :',
                labelStyle: TextStyle(color: MyStyle().darkColor),
                prefixIcon: Icon(
                  Icons.face,
                  color: MyStyle().darkColor,
                ),
              ),
            ),
          ),
        ],
      );
  Widget userForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
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
          ),
        ],
      );
  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
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
          ),
        ],
      );

  Widget showAppName() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MyStyle().showTitle('Pex Food'),
        ],
      );

  Widget myLogo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MyStyle().showLogo(),
        ],
      );
}

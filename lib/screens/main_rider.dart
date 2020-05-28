import 'package:flutter/material.dart';
import 'package:pexfood/utility/mystyle.dart';
import 'package:pexfood/utility/singOutProcess.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainRider extends StatefulWidget {
  @override
  _MainRiderState createState() => _MainRiderState();
}

class _MainRiderState extends State<MainRider> {
  String nameUser;
  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('name');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: showDrawer(),
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main Rider' : 'Login By $nameUser'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => singoOutProcess(context),
          )
        ],
      ),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
          ],
        ),
      );
  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('rider.jpg'),
        currentAccountPicture: MyStyle().showLogo(),
        accountName: Text(
          'Rider',
          style: TextStyle(color: MyStyle().darkColor),
        ),
        accountEmail: Text(
          'Please Login',
          style: TextStyle(color: MyStyle().primaryColor),
        ));
  }
}

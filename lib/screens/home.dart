import 'package:flutter/material.dart';
import 'package:pexfood/screens/main_rider.dart';
import 'package:pexfood/screens/main_shop.dart';
import 'package:pexfood/screens/main_user.dart';
import 'package:pexfood/screens/singin.dart';
import 'package:pexfood/screens/singup.dart';
import 'package:pexfood/utility/mystyle.dart';
import 'package:pexfood/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String chooseType;
  @override
  void initState() {
    super.initState();
    checkPreferences();
  }

  Future<Null> checkPreferences() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      chooseType = preferences.get('type');
      if (chooseType != 'null' && chooseType.isNotEmpty) {
        if (chooseType == 'User') {
          routeToService(MainUser());
        } else if (chooseType == 'Shop') {
          routeToService(MainShop());
        } else if (chooseType == 'Rider') {
          routeToService(MainRider());
        } else {
          normalDialog(context, 'Error User Type');
        }
      }
    } catch (e) {}
  }

  void routeToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: showDrawer(),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
            signInMenu(),
            signUpMenu(),
          ],
        ),
      );

  ListTile signInMenu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text('Sign In'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SingIn());
        Navigator.push(context, route);
      },
    );
  }

  ListTile signUpMenu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text('Sign Up'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SingUp());
        Navigator.push(context, route);
      },
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('guess.jpg'),
        currentAccountPicture: MyStyle().showLogo(),
        accountName: Text(
          'Guest',
          style: TextStyle(color: MyStyle().darkColor),
        ),
        accountEmail: Text(
          'Please Login',
          style: TextStyle(color: MyStyle().primaryColor),
        ));
  }
}

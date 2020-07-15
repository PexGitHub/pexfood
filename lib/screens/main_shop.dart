import 'package:flutter/material.dart';
import 'package:pexfood/utility/mystyle.dart';
import 'package:pexfood/utility/singOutProcess.dart';
import 'package:pexfood/widget/list_food_menu_shop.dart';
import 'package:pexfood/widget/infomation_shop.dart';
import 'package:pexfood/widget/order_list_shop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainShop extends StatefulWidget {
  @override
  _MainShopState createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  String nameUser;
  Widget currentWidget = OrderListShop();
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
        title: Text(nameUser == null ? 'Main Shop' : 'Login By $nameUser'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => singoOutProcess(context),
          )
        ],
      ),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
            homeMenu(),
            foodMenu(),
            informationMenu(),
            signOutMenu(),
          ],
        ),
      );

  ListTile homeMenu() {
    return ListTile(
      leading: Icon(Icons.home),
      title: Text('รายการอาหารที่ ลูกค้าสั่ง'),
      subtitle: Text('รายการอาหารที่ยังไม่ได้ ทำส่งลูกค้า'),
      onTap: () {
        setState(() {
          currentWidget = OrderListShop();
          Navigator.pop(context);
        });
      },
    );
  }

  ListTile foodMenu() {
    return ListTile(
      leading: Icon(Icons.fastfood),
      title: Text('รายการอาหาร'),
      subtitle: Text('รายการอาหาร ของร้าน'),
      onTap: () {
        setState(() {
          currentWidget = ListFoodMenuShop();
          Navigator.pop(context);
        });
      },
    );
  }

  ListTile informationMenu() {
    return ListTile(
      leading: Icon(Icons.info),
      title: Text('รายละเอียด ของร้าน'),
      subtitle: Text('รายละเอียด ของร้าน พร้อมแก้ไข'),
      onTap: () {
        setState(() {
          currentWidget = InformationShop();
          Navigator.pop(context);
        });
      },
    );
  }

  ListTile signOutMenu() {
    return ListTile(
      leading: Icon(Icons.exit_to_app),
      title: Text('Sign Out'),
      subtitle: Text('Sign Out และกลับไป หน้าแรก'),
      onTap: () => singoOutProcess(context),
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('shop.jpg'),
        currentAccountPicture: MyStyle().showLogo(),
        accountName: Text(
          'Shop',
          style: TextStyle(color: MyStyle().darkColor),
        ),
        accountEmail: Text(
          'Please Login',
          style: TextStyle(color: MyStyle().primaryColor),
        ));
  }
}

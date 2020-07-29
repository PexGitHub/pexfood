import 'package:flutter/material.dart';
import 'package:pexfood/model/user_model.dart';
import 'package:pexfood/utility/mystyle.dart';
import 'package:pexfood/widget/about_shop.dart';
import 'package:pexfood/widget/show_menu_food.dart';

class ShowShopFoodMenu extends StatefulWidget {
  final UserModel userModel;
  ShowShopFoodMenu({Key key, this.userModel}) : super(key: key);
  @override
  _ShowShopFoodMenuState createState() => _ShowShopFoodMenuState();
}

class _ShowShopFoodMenuState extends State<ShowShopFoodMenu> {
  UserModel userModel;
  List<Widget> listWidgets = List();
  int indexPage = 0;
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    listWidgets.add(AboutShop(
      userModel: userModel,
    ));
    listWidgets.add(ShowMenuFood(
      userModel: userModel,
    ));
  }

  BottomNavigationBarItem aboutShopNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.restaurant),
      title: Text('รายละเอียดร้าน'),
    );
  }

  BottomNavigationBarItem showMenuFoodNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_menu),
      title: Text('เมนูอาหาร'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[MyStyle().iconShowCart(context)],
        title: Text(userModel.nameshop),
      ),
      body: listWidgets.length == 0
          ? MyStyle().myProgressMap()
          : listWidgets[indexPage],
      bottomNavigationBar: showButtomNavigationBar(),
    );
  }

  BottomNavigationBar showButtomNavigationBar() => BottomNavigationBar(
          currentIndex: indexPage,
          selectedItemColor: Colors.white,
          backgroundColor: Colors.blue.shade900,
          onTap: (value) {
            setState(() {
              indexPage = value;
            });
          },
          items: <BottomNavigationBarItem>[
            aboutShopNav(),
            showMenuFoodNav(),
          ]);
}

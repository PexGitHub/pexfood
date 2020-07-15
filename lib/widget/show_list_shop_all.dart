import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pexfood/model/user_model.dart';
import 'package:pexfood/screens/show_shop_food_menu.dart';
import 'package:pexfood/utility/myconstant.dart';
import 'package:pexfood/utility/mystyle.dart';

class ShowListShopAll extends StatefulWidget {
  @override
  _ShowListShopAllState createState() => _ShowListShopAllState();
}

class _ShowListShopAllState extends State<ShowListShopAll> {
  List<UserModel> userModels = List();
  List<Widget> shopCards = List();
  @override
  void initState() {
    super.initState();
    readShop();
  }

  @override
  Widget build(BuildContext context) {
    return shopCards.length == 0
        ? MyStyle().myProgressMap()
        : GridView.extent(
            maxCrossAxisExtent: 180.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            children: shopCards,
          );
  }

  Future<Null> readShop() async {
    String url =
        '${MyConstant().domain}/pexfood/getuserwhereChooseType.php?isAdd=true&type=Shop';
    await Dio().get(url).then((value) {
      //print('value = $value');
      var result = jsonDecode(value.data);
      int index = 0;

      for (var map in result) {
        UserModel model = UserModel.fromJson(map);

        String nameShop = model.nameshop;
        if (nameShop.isNotEmpty) {
          setState(() {
            userModels.add(model);
            shopCards.add(createCard(model, index));
            index++;
          });
        }
      }
    });
  }

  Widget createCard(UserModel userModel, int index) {
    return GestureDetector(
      onTap: () {
        print('index = $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowShopFoodMenu(
            userModel: userModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 80.0,
              height: 80.0,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  '${MyConstant().domain}${userModel.urlpicture}',
                ),
              ),
            ),
            MyStyle().mySizedBox(),
            MyStyle().showTitle3(userModel.nameshop),
          ],
        ),
      ),
    );
  }
}

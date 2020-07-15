import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pexfood/model/food_model.dart';
import 'package:pexfood/screens/add_food_menu.dart';
import 'package:pexfood/screens/edit_food_menu.dart';
import 'package:pexfood/utility/myconstant.dart';
import 'package:pexfood/utility/mystyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListFoodMenuShop extends StatefulWidget {
  @override
  _ListFoodMenuShop createState() => _ListFoodMenuShop();
}

bool loadStatus = true; //Progress Load JSON
bool status = true; //Have Data

List<FoodModel> foodModels = List();

class _ListFoodMenuShop extends State<ListFoodMenuShop> {
  @override
  void initState() {
    super.initState();
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    if (foodModels.length != 0) {
      foodModels.clear();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString('id');

    String url =
        '${MyConstant().domain}/pexfood/getFoodwhereidshop.php?isAdd=true&idShop=$idShop';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        var result = jsonDecode(value.data);

        // print (result);
        for (var map in result) {
          FoodModel foodModel = FoodModel.fromJson(map);
          setState(() {
            foodModels.add(foodModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        loadStatus ? MyStyle().myProgressMap() : showContent(),
        addMenuButton(),
      ],
    );
  }

  Widget showContent() {
    return status
        ? showListFood()
        : Center(
            child: Text('ยังไม่มีรายการอาหาร'),
          );
  }

  Widget showListFood() => ListView.builder(
        itemCount: foodModels.length,
        itemBuilder: (context, index) => Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              child: Image.network(
                '${MyConstant().domain}${foodModels[index].pathImage}',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      foodModels[index].nameFood,
                      style: MyStyle().mainTitle,
                    ),
                    Text(
                      'ราคา ${foodModels[index].price} บาท',
                      style: MyStyle().mainTitle2,
                    ),
                    Text(foodModels[index].detail),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.purple,
                          ),
                          onPressed: () {
                            MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) =>
                                  EditFoodMenu(foodModel: foodModels[index]),
                            );
                            Navigator.push(context, route)
                                .then((value) => readFoodMenu());
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => deleteFood(foodModels[index]),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  Future<Null> deleteFood(FoodModel foodModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title:
            MyStyle().showTitle2('คุณต้องการลบ เมนู ${foodModel.nameFood} ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    String url =
                        '${MyConstant().domain}/pexfood/deleteFoodwhereid.php?isAdd=true&id=${foodModel.id}';
                    await Dio().get(url).then((value) => readFoodMenu());
                  },
                  child: Text('ยืนยัน')),
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('ยังไม่ลบ'))
            ],
          )
        ],
      ),
    );
  }

  Widget addMenuButton() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => AddFoodMenu(),
                    );
                    Navigator.push(context, route)
                        .then((value) => readFoodMenu());
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pexfood/model/cart_model.dart';
import 'package:pexfood/utility/myconstant.dart';
import 'package:pexfood/utility/mystyle.dart';
import 'package:pexfood/utility/normal_dialog.dart';
import 'package:pexfood/utility/sqlite_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ShowCart extends StatefulWidget {
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<CartModel> cartModels = List();
  int total;
  bool status = true;

  @override
  void initState() {
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    total = 0;
    var object = await SQLiteHelper().readAllDataFromSQLite();
    if (object.length != 0) {
      for (var model in object) {
        String sumString = model.sum;
        int sumInt = int.parse(sumString);
        setState(() {
          status = false;
          cartModels = object;
          total = total + sumInt;
        });
      }
    } else {
      setState(() {
        status = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้าของฉัน'),
      ),
      body: status ? Center(child: Text('ตะกร้าว่างเปล่า')) : buildContent(),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildNameShop(),
            buildHeadTitle(),
            buildListFood(),
            Divider(),
            buildTotal(),
            buildClearCartButton(),
            buildOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget buildClearCartButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 150,
          child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: MyStyle().primaryColor,
              onPressed: () {
                confirmDeleteAllData();
              },
              icon: Icon(
                Icons.delete_outline,
                color: Colors.white,
              ),
              label: Text(
                'เคลียร์ตะกร้า',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Widget buildOrderButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 150,
          child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: MyStyle().darkColor,
              onPressed: () {
                orderThread();
              },
              icon: Icon(
                Icons.fastfood,
                color: Colors.white,
              ),
              label: Text(
                'Order',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Widget buildTotal() => Row(
        children: <Widget>[
          Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  MyStyle().showTitle2('ราคารวม : '),
                ],
              )),
          Expanded(
            flex: 1,
            child: MyStyle().showTitle3Red(total.toString()),
          ),
        ],
      );

  Widget buildNameShop() {
    return Container(
      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              MyStyle().showTitle2('ร้าน ${cartModels[0].nameShop}'),
            ],
          ),
          Row(
            children: <Widget>[
              MyStyle()
                  .showTitle3('ระยะทาง ${cartModels[0].distance} กิโลเมตร'),
            ],
          ),
          Row(
            children: <Widget>[
              MyStyle().showTitle3('ค่าส่ง ${cartModels[0].transport} บาท'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeadTitle() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        children: <Widget>[
          Expanded(flex: 3, child: MyStyle().showTitle3('รายการอาหาร')),
          Expanded(flex: 1, child: MyStyle().showTitle3('ราคา')),
          Expanded(flex: 1, child: MyStyle().showTitle3('จำนวน')),
          Expanded(flex: 1, child: MyStyle().showTitle3('รวม')),
          Expanded(
            flex: 1,
            child: MyStyle().mySizedBox(),
          )
        ],
      ),
    );
  }

  Widget buildListFood() => ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: cartModels.length,
        itemBuilder: (context, index) => Row(
          children: <Widget>[
            Expanded(flex: 3, child: Text(cartModels[index].nameFood)),
            Expanded(flex: 1, child: Text(cartModels[index].price)),
            Expanded(flex: 1, child: Text(cartModels[index].amount)),
            Expanded(flex: 1, child: Text(cartModels[index].sum)),
            Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () async {
                    int id = cartModels[index].id;
                    print('You Click Delete id = $id');
                    await SQLiteHelper().deleteDataWhereId(id).then((value) {
                      print('Success Delete id = $id');
                      readSQLite();
                    });
                  },
                ))
          ],
        ),
      );

  Future<Null> confirmDeleteAllData() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
          title: Text('คุณต้องการลบรายการอาหารทั้งหมดใช่ไหม'),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: MyStyle().primaryColor,
                  onPressed: () async {
                    Navigator.pop(context);
                    await SQLiteHelper().deleteAllData().then((value) {
                      readSQLite();
                    });
                  },
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ]),
    );
  }

  Future<Null> orderThread() async {
    DateTime dateTime = DateTime.now();
    String orderDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    String idShop = cartModels[0].idShop;
    String nameShop = cartModels[0].nameShop;
    String distance = cartModels[0].distance;
    String transport = cartModels[0].transport;
    List<String> idFoods = List();
    List<String> nameFoods = List();
    List<String> prices = List();
    List<String> amounts = List();
    List<String> sums = List();

    for (var model in cartModels) {
      idFoods.add(model.idFood);
      nameFoods.add(model.nameFood);
      prices.add(model.price);
      amounts.add(model.amount);
      sums.add(model.sum);
    }
    String idFood = idFoods.toString();
    String nameFood = nameFoods.toString();
    String price = prices.toString();
    String amount = amounts.toString();
    String sum = sums.toString();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idUser = preferences.getString('id');
    String nameUser = preferences.getString('name');

    print(
        '$orderDateTime $idUser $nameUser $idShop $nameShop $distance $transport');
    print('$idFood $nameFoods $prices $amounts $sums');

    String url =
        '${MyConstant().domain}/pexfood/addOrder.php?isAdd=true&orderDateTime=$orderDateTime&idUser=$idUser&nameUser=$nameUser&idShop=$idShop&nameShop=$nameShop&distance=$distance&transport=$transport&idFood=$idFood&nameFood=$nameFood&price=$price&amount=$amount&sum=$sum&idRider=none&status=UserOrder';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        clearAllSQLite();
      } else {
        normalDialog(context, 'ไม่สามารถ order ได้ กรุณาลองใหม่');
      }
    });
  }

  Future<Null> clearAllSQLite() async {
    Toast.show(
      'Order เรียบร้อยแล้ว',
      context,
      duration: Toast.LENGTH_LONG,
    );
    await SQLiteHelper().deleteAllData().then((value) {
      readSQLite();
    });
  }
}

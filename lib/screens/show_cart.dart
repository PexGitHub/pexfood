import 'package:flutter/material.dart';
import 'package:pexfood/model/cart_model.dart';
import 'package:pexfood/utility/mystyle.dart';
import 'package:pexfood/utility/sqlite_helper.dart';

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
    // TODO: implement initState
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
            buildClearCartButton()
          ],
        ),
      ),
    );
  }

  Widget buildClearCartButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        RaisedButton.icon(
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
}

import 'package:flutter/material.dart';
import 'package:pexfood/screens/add_info_shop.dart';
import 'package:pexfood/utility/mystyle.dart';

class InformationShop extends StatefulWidget {
  @override
  _InformationShopState createState() => _InformationShopState();
}

class _InformationShopState extends State<InformationShop> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MyStyle().titleCenter(context, 'ยังไม่มีข้อมูล กรุณาเพิ่มข้อมูล'),
        addeditButton(),
      ],
    );
  }

  Row addeditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () => routeToAddInfo(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void routeToAddInfo() {
    MaterialPageRoute route =
        MaterialPageRoute(builder: (context) => AddInfoShop());
    Navigator.of(context).push(route);
  }
}

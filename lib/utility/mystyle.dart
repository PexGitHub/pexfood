import 'package:flutter/material.dart';
import 'package:pexfood/screens/show_cart.dart';

class MyStyle {
  Color darkColor = Colors.blue.shade700;
  Color primaryColor = Colors.green;

  Widget iconShowCart(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add_shopping_cart),
      onPressed: () {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowCart(),
        );
        Navigator.push(context, route);
      },
    );
  }

  Widget myProgressMap() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  SizedBox mySizedBox() => SizedBox(
        height: 16.0,
        width: 8.0,
      );

  Text showTitle(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 24.0, color: darkColor, fontWeight: FontWeight.bold),
      );

  Text showTitle2(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 18.0, color: darkColor, fontWeight: FontWeight.bold),
      );
  Text showTitle3(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 16.0, color: darkColor, fontWeight: FontWeight.bold),
      );
      Text showTitle3Red(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 16.0, color: Colors.red, fontWeight: FontWeight.bold),
      );
  TextStyle mainTitle = TextStyle(
      fontSize: 16.0, color: Colors.blue, fontWeight: FontWeight.bold);
  TextStyle mainTitle2 = TextStyle(
      fontSize: 14.0, color: Colors.green, fontWeight: FontWeight.bold);

  Center titleCenter(BuildContext context, String string) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          string,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Container showLogo() {
    return Container(
      child: Image.asset('images/logo.png'),
      width: 120.0,
    );
  }

  BoxDecoration myBoxDecoration(String namePic) {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/$namePic'), fit: BoxFit.cover));
  }

  MyStyle();
}

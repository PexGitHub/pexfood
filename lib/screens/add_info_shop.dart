import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pexfood/utility/mystyle.dart';

class AddInfoShop extends StatefulWidget {
  @override
  _AddInfoShopState createState() => _AddInfoShopState();
}

class _AddInfoShopState extends State<AddInfoShop> {
  double lat, lng;
  @override
  void initState() {
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocation();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });
    print('lat = $lat  , lng = $lng');
  }

  Future<LocationData> findLocation() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Infomation Shop'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyStyle().mySizedBox(),
            nameForm(),
            MyStyle().mySizedBox(),
            addressForm(),
            MyStyle().mySizedBox(),
            phoneForm(),
            MyStyle().mySizedBox(),
            groupImage(),
            MyStyle().mySizedBox(),
            lat == null ? MyStyle().myProgressMap() : showMap(),
            MyStyle().mySizedBox(),
            saveButton()
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        onPressed: () {},
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'Save Infomation',
          style: TextStyle(color: Colors.white),
        ),
        color: MyStyle().primaryColor,
      ),
    );
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myShop'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
            title: 'SSP Tower', snippet: 'ละติจูด = $lat , ลองติจูด = $lng'),
      )
    ].toSet();
  }

  Container showMap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 16.0);

    return Container(
        height: 300.0,
        child: GoogleMap(
          markers: myMarker(),
          initialCameraPosition: cameraPosition,
          mapType: MapType.normal,
          onMapCreated: (controller) {},
        ));
  }

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.image,
              size: 36.0,
            ),
            onPressed: () {}),
        Container(
          width: 250.0,
          child: Image.asset('images/myimage.png'),
        ),
        IconButton(
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36.0,
          ),
          onPressed: () {},
        )
      ],
    );
  }

  Widget nameForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ชื่อร้านค้า',
                prefixIcon: Icon(
                  Icons.account_box,
                )),
          ),
        ),
      ],
    );
  }

  Widget addressForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ที่อยู่ร้านค้า',
                prefixIcon: Icon(
                  Icons.home,
                )),
          ),
        ),
      ],
    );
  }

  Widget phoneForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'เบอร์โทรร้านค้า',
                prefixIcon: Icon(
                  Icons.phone,
                )),
          ),
        ),
      ],
    );
  }
}

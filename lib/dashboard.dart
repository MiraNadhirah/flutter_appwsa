import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wsa/locations.dart';
import 'package:geocoder/geocoder.dart';
//import 'package:flutter_wsa/location_test.dart';
import 'package:geolocator/geolocator.dart';
import 'contact.dart';
import 'contact_data.dart';
import 'firestore_service.dart';
import 'main.dart';
import 'widget/provider_widget.dart';

final primaryColor = const Color(0xFF7E57C2);

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Timer timer;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("MENU"),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.purple[900],
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              child: const Text("LOGOUT"),
              onPressed: () {
                _signOut().whenComplete(() {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MyApp()));
                });
              },
            )
          ],
        ),
        body: Container(
          color: primaryColor,
          child: Column(children: <Widget>[
            Image(
              image: AssetImage('images/logo.png'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(12.0),
                    child: new MaterialButton(
                      height: 100.0,
                      minWidth: 100.0,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: new Text("My Profile"),
                      onPressed: () => {
                        // Navigator.push(
                        // context,
                        // MaterialPageRoute(builder: (context) => Profile()),
                        // )
                      },
                      splashColor: Colors.grey,
                    )),
                Padding(
                    padding: EdgeInsets.all(12.0),
                    child: new MaterialButton(
                      height: 100.0,
                      minWidth: 100.0,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: new Text("Emergency \n\t\tContacts"),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        ),
                      },
                      splashColor: Colors.redAccent,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(12.0),
                    child: new MaterialButton(
                      height: 100.0,
                      minWidth: 100.0,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: new Text("LOCATION"),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Location()),
                        )
                      },
                      splashColor: Colors.redAccent,
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(12.0),
                          child: new MaterialButton(
                            height: 100.0,
                            minWidth: 100.0,
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            child: new Text("SOS"),
                            onPressed: () async {
                              if (timer == null || !timer.isActive) {
                                timer = Timer.periodic(Duration(seconds: 5),
                                    (timer) async {
                                  print("Sending");
                                  print(DateTime.now());

                                  await _getCurrentLocation();
                                  if (_currentAddress == null) return;
                                  sendMessage(
                                      "$_currentAddress\nhttp://www.google.com/maps/place/${_currentPosition.latitude},${_currentPosition.longitude}");
                                });
                              } else {
                                timer.cancel();
                                //sendMessage("Ding Dong");
                              }
                              // sendMessage(return launch(body:"hello"),_sendsms(number),);
                            },
                            splashColor: Colors.redAccent,
                          )),
                    ])
              ],
            )
          ]),
        ));
  }

  void sendMessage(String message) async {
    //TODO:buat kirim sms
    List<Contact> contacts = await FirestoreService()
        .getContacts(Provider.of(context).auth.getCurrentUID());
    print(message);
  }

  Position _currentPosition;
  String _currentAddress;

  Future _getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _currentPosition = position;
    });

    await _getAddressFromLatLng();
  }

  _getAddressFromLatLng() async {
    try {
      if ((await Geolocator.checkPermission()) !=
          LocationPermission.whileInUse) {
        //TODO : buat permission request untuk bagi tau user izinkan permission
        print("Not granted");
        return;
      }

      if (!(await Geolocator.isLocationServiceEnabled())) {
        //TODO : buat dialog untk bagi tau user aktifkan GPS
        print("GPS Disabled");
        return;
      }

      var p = await Geocoder.local.findAddressesFromCoordinates(
          Coordinates(_currentPosition.latitude, _currentPosition.longitude));

      var place = p.first;

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.countryName}";
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future _signOut() async {
    await _auth.signOut();
  }
}

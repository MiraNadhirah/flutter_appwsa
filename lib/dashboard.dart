import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wsa/launcher.dart';
import 'package:flutter_wsa/locations.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'contact.dart';
import 'contact_data.dart';
import 'firestore_service.dart';
import 'main.dart';
import 'widget/provider_widget.dart';
import 'package:sms/sms.dart';

final primaryColor = const Color(0xFF7E57C2);

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Timer timer;
  String myId;
  AudioCache audioCache = AudioCache();

  Widget build(BuildContext context) {
    myId = Provider.of(context).auth.getCurrentUID();
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
              image: AssetImage('assets/logo.png'),
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
                      child: new Text("Self Defence Videos"),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Launcher()),
                        )
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
                                timer = Timer.periodic(Duration(seconds: 15),
                                    (timer) async {
                                  print("Sending");
                                  print(DateTime.now());

                                  await _getCurrentLocation();
                                  if (_currentAddress == null) return;
                                  sendMessage(
                                      "I am in danger, this is my current location $_currentAddress\nhttp://www.google.com/maps/place/${_currentPosition.latitude},${_currentPosition.longitude}");
                                });
                                audioCache.load('siren.mp3');
                                audioCache.play('siren.mp3');
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
    List<Contact> contacts = await FirestoreService().getContacts(myId);
    SmsSender sms = SmsSender();
    contacts.forEach((element) {
      sms.sendSms(SmsMessage(element.phoneNo, message));
    });
    print(message);
  }

  Position _currentPosition;
  String _currentAddress;

  Future _getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    _currentPosition = position;
    if (mounted) setState(() {});

    await _getAddressFromLatLng();
  }

  _getAddressFromLatLng() async {
    try {
      if ((await Geolocator.checkPermission()) == LocationPermission.denied) {
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

      _currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.countryName}";
      if (mounted) setState(() {});
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future _signOut() async {
    await _auth.signOut();
  }
}

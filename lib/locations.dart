import 'dart:async';
import 'dart:html';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  Completer<GoogleMapController> controller1;

  //static LatLng _center = LatLng(-15.4630239974464, 28.363397732282127);
  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
  static LatLng _lastMapPosition = _initialPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  /*Show dialog if GPS not enabled and open settings location*/
  Future _checkGps() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Can't get gurrent location"),
                content:
                    const Text('Please make sure you enable GPS and try again'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        // final AndroidIntent intent = AndroidIntent(
                        //     action:
                        //         'android.settings.LOCATION_SOURCE_SETTINGS');
                        // intent.launch();
                        // Navigator.of(context, rootNavigator: true).pop();
                        // _gpsService();

                        Geolocator.openLocationSettings();
                      })
                ],
              );
            });
      }
    }
  }

/*Check if gps service is enabled or not*/
  Future _gpsService() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      _checkGps();
      return null;
    } else
      return true;
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Address> placemark = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(position.latitude, position.longitude));
    //  = await Geolocator.placemarkFromCoordinates(
    //     position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print('${placemark.first.addressLine}');
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
    });
  }

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
              title: "Your Location",
              //snippet: "This is a snippet",
              onTap: () {}),
          onTap: () {},
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  Widget mapButton(Function function, Icon icon, Color color) {
    return RawMaterialButton(
      onPressed: function,
      child: icon,
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: const EdgeInsets.all(7.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPosition == null
          ? Container(
              child: Center(
                child: Text(
                  'loading map..',
                  style: TextStyle(
                      fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                ),
              ),
            )
          : Container(
              child: Stack(children: <Widget>[
                GoogleMap(
                  markers: _markers,
                  mapType: _currentMapType,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 14.4746,
                  ),
                  onMapCreated: _onMapCreated,
                  zoomGesturesEnabled: true,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  myLocationButtonEnabled: false,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          mapButton(_onAddMarkerButtonPressed,
                              Icon(Icons.add_location), Colors.blue),
                          mapButton(
                              _onMapTypeButtonPressed,
                              Icon(
                                IconData(0xf473,
                                    fontFamily: CupertinoIcons.iconFont,
                                    fontPackage:
                                        CupertinoIcons.iconFontPackage),
                              ),
                              Colors.green),
                        ],
                      )),
                )
              ]),
            ),
    );
  }
}

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class Tracking extends StatefulWidget {
  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {

  final Set<Polyline> polyline = {};
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  GoogleMapController mapController;
  List<LatLng> routeCordinates = [];

  //Insert the API KEY in AndroidManifest.xml and in the below line.
  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: "Your API KEY");
  BitmapDescriptor customIcon1;
  BitmapDescriptor customIcon2;

//to get permission of location
//  Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
//    var granted = await _requestPermission(Permission.location);
//    if (granted!=true) {
//      requestLocationPermission();
//    }
//    debugPrint('requestContactsPermission $granted');
//    return granted;
//  }
//  Future _checkGps() async {
//    if (!(await Geolocator().isLocationServiceEnabled())) {
//      if (Theme.of(context).platform == TargetPlatform.android) {
//        showDialog(
//            context: context,
//            barrierDismissible: false,
//            builder: (BuildContext context) {
//              return AlertDialog(
//                title: Text("Can't get gurrent location"),
//                content:const Text('Please make sure you enable GPS and try again'),
//                actions: <Widget>[
//                  FlatButton(child: Text('Ok'),
//                      onPressed: () {
//                        final AndroidIntent intent = AndroidIntent(
//                            action: 'android.settings.LOCATION_SOURCE_SETTINGS');
//                        intent.launch();
//                        setState(() {
//                        });
//                        Navigator.of(context, rootNavigator: true).pop();
//                        _gpsService();
//                      })],
//              );
//            });
//      }
//    }
//  }
//
//  Future _gpsService() async {
//    if (!(await Geolocator().isLocationServiceEnabled())) {
//      _checkGps();
//      return null;
//    } else
//      return true;
//  }
//
//
//
//  Future<bool> _requestPermission(Permission permission) async {
//    if(await Permission.location.request().isGranted){
//      return true;
//    }
//    return false;
//  }

  getSomePoints() async {
      routeCordinates = await googleMapPolyline.getCoordinatesWithLocation(
          origin: LatLng(19.9839509, 73.7531648),
          destination: LatLng(19.9703004, 73.7938285,),
      mode: RouteMode.driving);
  }

  getAddressPoints() async {
    routeCordinates = await googleMapPolyline.getPolylineCoordinatesWithAddress(
        origin: 'Nashik,Maharashtra,India',
        destination: 'Pune,Maharashtra,India',
        mode: RouteMode.driving
    );
  }

  @override
  void initState() {
    super.initState();
//    getaddressPoints();
    getSomePoints();
  }

  void onMapCreated(GoogleMapController controller) {
    LatLng pinPosition1 = LatLng(19.9839509, 73.7531648);
    LatLng pinPosition2 =  LatLng(19.8898025, 73.8018113);
    _markers.add(
        Marker(
            markerId: MarkerId('Marker 1'),
            position: pinPosition1,
            icon: customIcon1
        )
    );
    _markers.add(
        Marker(
          markerId: MarkerId('Marker 2'),
          position: pinPosition2,
          icon: customIcon2,
        )
    );
    setState(() {
      mapController = controller;
      polyline.add(Polyline(
          polylineId: PolylineId('route1'),
          visible: true,
          points: routeCordinates,
          width: 4,
          color: Colors.blue,
          startCap: Cap.roundCap,
          endCap: Cap.buttCap));
    });
  }

  createMarkers(context){
    if(customIcon1 ==null){
      ImageConfiguration configuration = createLocalImageConfiguration(context);
       BitmapDescriptor.fromAssetImage(configuration,
          'assets/images/driving_pin.png').then((icon){
            setState(() {
              customIcon1 =icon;
            });
      });
    }
    if(customIcon2 ==null){
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration,
          'assets/images/destination_map_marker.png').then((icon){
        setState(() {
          customIcon2 =icon;
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    createMarkers(context);
    return Scaffold(
        body: GoogleMap(
          onMapCreated: onMapCreated,
          markers: _markers,
          polylines: polyline,
          initialCameraPosition:
          CameraPosition(target: LatLng(19.9911106, 73.7334396), zoom: 10.0),
          mapType: MapType.normal,
        ));
  }
}
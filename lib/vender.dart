// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, avoid_print, must_be_immutable, use_key_in_widget_constructors, no_logic_in_create_state, prefer_typing_uninitialized_variables, use_build_context_synchronously, prefer_final_fields, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:major_project/home.dart';

import 'db.dart';

// For creating player profile
class VenMakeProfilePage extends StatefulWidget {
  const VenMakeProfilePage({super.key});

  @override
  State<VenMakeProfilePage> createState() => _VenMakeProfilePageState();
}

class _VenMakeProfilePageState extends State<VenMakeProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  Color primaryColor = Color.fromARGB(255, 174, 39, 39);

  final _gender = ["Male", "Female"];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back,
              color: primaryColor,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  'Create Your\nProfile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 40,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Image.asset(
                  'assets/user.png',
                  width: width * 0.35,
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Enter Name',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: primaryColor),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: numberController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.hourglass_bottom_rounded),
                          labelText: 'Enter Phone Number',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: primaryColor),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                          )),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () async {
                          final User? user = FirebaseAuth.instance.currentUser;
                          int number = int.parse(numberController.text);
                          await DatabaseManager().createVenderData(
                              nameController.text, number, user!.uid);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VenderHomePage()));
                        },
                        color: primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GetLocation extends StatefulWidget {
  const GetLocation({super.key});

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  GoogleMapController? _googleMapController;
  Position? position;
  var addressLocation;
  var latitude;
  var longitude;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: addressLocation));
    setState(() {
      markers[markerId] = _marker;
    });
  }

  void getCurrentLocation() async {
    Position currentPosition =
        await GeolocatorPlatform.instance.getCurrentPosition();
    setState(() {
      position = currentPosition;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Widget cusSearchbar = Text('Search Ground');
    Color cusColor = Color.fromARGB(255, 174, 39, 39);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: cusSearchbar,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            fontFamily: 'codecpro'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.65,
              child: GoogleMap(
                onTap: (tapped) async {
                  getMarkers(tapped.latitude, tapped.longitude);
                  List<Placemark> addresses = await placemarkFromCoordinates(
                      tapped.latitude, tapped.longitude);
                  var firstAddress =
                      "${addresses.first.subLocality},${addresses.first.locality},${addresses.first.administrativeArea},${addresses.first.country},${addresses.first.postalCode}";
                  setState(() {
                    addressLocation = firstAddress;
                    latitude = tapped.latitude;
                    longitude = tapped.longitude;
                  });
                },
                mapType: MapType.normal,
                compassEnabled: true,
                trafficEnabled: true,
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: LatLng(22.72056, 75.84722), zoom: 14.0),
                onMapCreated: (controller) => _googleMapController = controller,
                markers: Set<Marker>.of(markers.values),
              ),
            ),
            Text(
              "Address : $addressLocation",
              style: TextStyle(fontSize: 10),
            )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: cusColor,
        foregroundColor: Colors.black,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero),
        child: Text("OKAY"),
        onPressed: () async {
          final User? user = FirebaseAuth.instance.currentUser;
          var gid = "${latitude}xyzXYZ${longitude}asdASD";
          await DatabaseManager().addGroundLocData(
              latitude, longitude, addressLocation, gid, user!.uid);
          Navigator.pop(context, gid);
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

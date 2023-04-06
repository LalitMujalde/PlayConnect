// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, avoid_print, must_be_immutable, use_key_in_widget_constructors, no_logic_in_create_state, prefer_typing_uninitialized_variables, use_build_context_synchronously, prefer_collection_literals
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:major_project/home.dart';

import 'db.dart';

class Setttings extends StatefulWidget {
  const Setttings({super.key});

  @override
  State<Setttings> createState() => _SetttingsState();
}

class _SetttingsState extends State<Setttings> {
  var name;
  var age;
  var gender;
  var email;

  @override
  void initState() {
    super.initState();
    fetchProfileDetails();
  }

  User? user = FirebaseAuth.instance.currentUser;

  fetchProfileDetails() async {
    List profile = await DatabaseManager().getPlayerDetails(user!.uid);
    setState(() {
      name = profile[0];
      age = profile[1];
      gender = profile[2];
      email = user!.email;
    });
  }

  // Colors
  Color black = Colors.black;
  Color white = Colors.white;
  Color primaryColor = Color.fromARGB(255, 174, 39, 39);

  // attbts
  Widget cusSearchbar = Text('SETTINGS');
  Icon cusIcon = Icon(Icons.search);

  // icons
  Icon edit = Icon(Icons.edit);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomePage()));
            },
            icon: Icon(
              Icons.arrow_back,
              color: black,
            ),
          ),
          title: cusSearchbar,
          titleTextStyle: TextStyle(
              color: black,
              fontSize: 25,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              fontFamily: 'codecpro'),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: Column(children: [
                  SizedBox(
                    height: height * 0.27,
                    child: LayoutBuilder(builder: (context, constraints) {
                      double innerHeight = constraints.maxHeight;
                      double innerWidth = constraints.maxWidth;
                      var children2 = [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: innerHeight * 0.65,
                            width: innerWidth,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      // spreadRadius: 5,
                                      blurRadius: 15.0,
                                      offset: Offset(0.0, 0.75))
                                ],
                                color: primaryColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 2),
                                IconButton(
                                    onPressed: () {
                                      _bottomUpdate(context);
                                    },
                                    icon: Icon(Icons.edit, size: 40))
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          child: Center(
                            child: Container(
                              child: Image.asset(
                                'assets/profile.png',
                                width: innerWidth * 0.55,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        )
                      ];
                      return Stack(
                        fit: StackFit.expand,
                        children: children2,
                      );
                    }),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                      height: height * 0.4,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Stack(fit: StackFit.expand, children: [
                          Positioned(
                              child: Container(
                            height: height * 0.4,
                            width: width,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color.fromARGB(255, 174, 39, 39)),
                            child: Column(children: [
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Name :',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  Text('$name',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ],
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Age :',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  Text('$age',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ],
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Gender :',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  Text('$gender',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ],
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Email :',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  Text('$email',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ],
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ]),
                          ))
                        ]);
                      }))
                ]))));
  }

  _bottomUpdate(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext c) {
          return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Text(
                        'Update Profile',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Name :',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 250,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: '$name',
                              ),
                              onChanged: (value) {
                                name = value;
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Age :',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 250,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: '$age',
                              ),
                              onChanged: (value) {
                                name = value;
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gender :',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 250,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: '$gender',
                              ),
                              onChanged: (value) {
                                name = value;
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.95,
                child: FloatingActionButton(
                  backgroundColor: Colors.red, //child widget inside this button
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () async {
                    await DatabaseManager()
                        .updateUserData(name, gender, age, user!.uid);
                    Navigator.pop(context);
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Save',
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.save_rounded, color: Colors.white),
                      ]),
                ),
              ));
        });
  }
}

// For creating player profile
class MakeProfilePage extends StatefulWidget {
  const MakeProfilePage({super.key});

  @override
  State<MakeProfilePage> createState() => _MakeProfilePageState();
}

class _MakeProfilePageState extends State<MakeProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  var selectedGen;

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
                      controller: ageController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.hourglass_bottom_rounded),
                          labelText: 'Enter Age',
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
                    SizedBox(height: 10),
                    DropdownButtonFormField(
                      items: _gender
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (selectedType) {
                        setState(() {
                          selectedGen = selectedType;
                        });
                      },
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: primaryColor,
                      ),
                      hint: Text(
                        'Gender',
                        style: TextStyle(color: Colors.black),
                      ),
                      dropdownColor: Color.fromARGB(255, 214, 111, 111),
                      decoration: InputDecoration(
                        labelText: "Gender",
                        labelStyle: TextStyle(
                            color: primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                        prefixIcon: Icon(
                          Icons.accessibility_new,
                          color: primaryColor,
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.black)),
                      ),
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
                          int age = int.parse(ageController.text);
                          await DatabaseManager().createUserData(
                              nameController.text, selectedGen, age, user!.uid);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomePage()));
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

class LocationChooseForSchedule extends StatefulWidget {
  const LocationChooseForSchedule({super.key});

  @override
  State<LocationChooseForSchedule> createState() =>
      _LocationChooseForScheduleState();
}

class _LocationChooseForScheduleState extends State<LocationChooseForSchedule> {
  Color black = Colors.black;

  GoogleMapController? _googleMapController;

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }

  Widget cusSearchbar = Text('Search Ground');
  Icon cusIcon = Icon(Icons.search);
  Color cusColor = Color.fromARGB(255, 174, 39, 39);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var gid;
  var chosenMarkerName;
  var chosenMarkerAddress;
  List availSports = [];
  List markerData = [];

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(specify['latitude'], specify['longitude']),
      infoWindow: InfoWindow(
          title: specify['Ground Name'], snippet: specify['Address']),
      onTap: () {
        var locGid = markerId.value;
        var lovchosenMarkerName = specify['Ground Name'];
        var lovchosenMarkerAddress = specify['Address'];
        List lovavailSports = specify['Available Sports'];
        setState(() {
          gid = locGid;
          chosenMarkerName = lovchosenMarkerName;
          chosenMarkerAddress = lovchosenMarkerAddress;
          availSports = lovavailSports;
        });
      },
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkersData() async {
    FirebaseFirestore.instance.collection('Ground').get().then((myMockData) {
      if (myMockData.docs.isNotEmpty) {
        for (int i = 0; i < myMockData.docs.length; i++) {
          initMarker(myMockData.docs[i].data(), myMockData.docs[i].id);
        }
      }
    });
  }

  @override
  void initState() {
    getMarkersData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: cusSearchbar,
        leading: Icon(
          Icons.location_on_outlined,
          color: Colors.black,
        ),
        titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            fontFamily: 'codecpro'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                if (cusIcon.icon == Icons.search) {
                  cusIcon = Icon(Icons.cancel);
                  cusSearchbar = TextField(
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        hintText: 'eg. holker ground',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none),
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'codecpro',
                        color: Colors.white),
                  );
                } else {
                  cusSearchbar = Text('Search Ground');
                  cusIcon = Icon(Icons.search);
                }
              });
            },
            icon: cusIcon,
            color: Colors.black,
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: GoogleMap(
            markers: Set<Marker>.of(markers.values),
            mapType: MapType.normal,
            compassEnabled: true,
            trafficEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition:
                CameraPosition(target: LatLng(22.72056, 75.84722), zoom: 14.0),
            onMapCreated: (controller) => _googleMapController = controller,
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: cusColor,
        foregroundColor: Colors.black,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero),
        child: Text("OKAY"),
        onPressed: () async {
          markerData.addAll([
            [gid, chosenMarkerName, chosenMarkerAddress],
            availSports
          ]);
          print(markerData[0][0]);
          print(markerData[0][1]);
          print(markerData[0][2]);
          print(markerData[1]);
          Navigator.pop(context, markerData);
        },
      ),
    );
  }
}

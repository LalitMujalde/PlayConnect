// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, avoid_print, sized_box_for_whitespace, sort_child_properties_last, no_leading_underscores_for_local_identifiers, prefer_collection_literals, prefer_typing_uninitialized_variables, prefer_final_fields, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:major_project/about.dart';
import 'package:major_project/google_sign_in.dart';
import 'package:major_project/player.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';
import 'package:custom_info_window/custom_info_window.dart';

import 'db.dart';
import 'vender.dart';

// Player Pages

// Your Schedule Page
class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

// default subheading
subheading(label) {
  return Text(label, style: TextStyle(color: Colors.black, fontSize: 20));
}

class _SchedulePageState extends State<SchedulePage> {
  List<String> images = [
    'assets/Batminton.jpeg',
    'assets/Cricket.jpeg',
    'assets/Football.jpeg',
    'assets/Hockey.jpeg',
    'assets/TT.jpeg'
  ];
  List sports = ['Available Games'];

  // Choose Date and time code ------------------------------->

  DateTime dateTime = DateTime.now();

  // Ends Here <------------------------

  // to fetch Data for schedules
  List scheduleList = [];
  List profileDetails = [];
  String? name;
  var age;
  var gender;

  @override
  void initState() {
    super.initState();
    fetchScheduleDataList();
    fetchProfileDetails();
  }

  User? user = FirebaseAuth.instance.currentUser;

  fetchScheduleDataList() async {
    dynamic resultant = await DatabaseManager().getScheduleDataList(user!.uid);

    if (resultant == null) {
      print('Unable to Retrieve');
      print(user!.uid);
    } else {
      setState(() {
        scheduleList = resultant;
      });
    }
  }

  fetchProfileDetails() async {
    List profile = await DatabaseManager().getPlayerDetails(user!.uid);
    setState(() {
      name = profile[0];
      age = profile[1];
      gender = profile[2];
    });
  }
  // Ends Here data fetching

  Widget cusSearchbar = Text('HELLO');
  Icon cusIcon = Icon(Icons.search);
  Color cusColor = Color.fromARGB(255, 174, 39, 39);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('HELLO ${name?.split(' ')[0].toUpperCase()}'),
        titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            fontFamily: 'codecpro'),
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationPage()));
              },
              icon: Icon(Icons.notifications),
              color: cusColor)
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Select Preferences
              Container(
                  height: height * 0.35,
                  // color: Colors.black,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Stack(fit: StackFit.expand, children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Your Preffered Sports',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      print(profileDetails[0]);
                                    },
                                    icon: Icon(Icons.edit))
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                            child: RefreshIndicator(
                              onRefresh: _refresh,
                              child: ListView.builder(
                                itemCount: images.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          10.0), //add border radius
                                      child: Image.asset(
                                        images[index],
                                        height: 100.0,
                                        width: 100.0,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      )
                    ]);
                  })),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    subheading('Your Schedule'),
                    IconButton(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: Icon(Icons.refresh))
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 30),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: scheduleList.length,
                      itemBuilder: (context, index) {
                        return Container(
                            padding: EdgeInsets.all(5),
                            child: Column(children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: cusColor),
                                child: Column(children: [
                                  SizedBox(height: 15),
                                  Text(
                                    scheduleList[index]['Ground Name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    scheduleList[index]['Ground Location'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Timing : ${scheduleList[index]['time']} at ${scheduleList[index]['Date']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'For : ${scheduleList[index]['Sport']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            print('Pressed');
                                          },
                                          icon: Icon(
                                            Icons.more_horiz_sharp,
                                            color: Colors.white,
                                            size: 30,
                                          )),
                                      Container(
                                        width: 5,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 30,
                                          )),
                                      Container(
                                        width: 5,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('Player')
                                                .doc(user!.uid)
                                                .collection('Schedule')
                                                .doc(scheduleList[index].id)
                                                .delete()
                                                .then((value) =>
                                                    print("deleted"));
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 30,
                                          ))
                                    ],
                                  )
                                ]),
                              )
                            ]));
                      })),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _bottomSheet(context);
          },
          backgroundColor: Color.fromARGB(255, 174, 39, 39),
          hoverColor: Colors.white,
          child: Icon(Icons.add)),
    );
  }

  // For refresh indicator
  Future<void> _refresh() {
    return Future.delayed(Duration(seconds: 5));
  }

  // Widget For Player ---------------------------------->
  _bottomSheet(context) {
    // List for sports

    // variable for database
    List markerData = [];
    var chosenAddress = 'Choose Ground Location';
    var chosenGame;
    var chosendate;
    var chosentime;

    // Hour and Minute Code
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    // Ends here
    showModalBottomSheet(
        context: context,
        builder: (BuildContext c) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Schedule',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 2),
                          top: BorderSide(color: Colors.black, width: 2),
                          right: BorderSide(color: Colors.black, width: 2),
                          left: BorderSide(color: Colors.black, width: 2),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton(
                          onPressed: () async {
                            List result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LocationChooseForSchedule()));
                            setState(() {
                              markerData = result;
                              chosenAddress = markerData[0][2];
                              sports.addAll(markerData[1]);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0.0,
                          ),
                          child: Row(children: [
                            Icon(Icons.location_on, color: Colors.black),
                            SizedBox(width: 20),
                            Text(
                              chosenAddress,
                            ),
                          ])),
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField(
                      value: sports[0],
                      items: sports
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        chosenGame = value;
                      },
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: cusColor,
                      ),
                      dropdownColor: Color.fromARGB(255, 214, 111, 111),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.accessibility_new,
                          color: cusColor,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.black,
                          width: 3,
                        )),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text('Choose Timing'),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('Date'),
                            ElevatedButton(
                              child: Text(
                                  '${dateTime.year}/${dateTime.month}/${dateTime.day}'),
                              onPressed: () async {
                                final date = await pickDate();
                                if (date == null) return;

                                final newDateTime = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    dateTime.hour,
                                    dateTime.minute);

                                setState(() => dateTime = newDateTime);
                              },
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text('Time'),
                            ElevatedButton(
                              child: Text('$hours:$minutes'),
                              onPressed: () async {
                                final time = await pickTime();
                                if (time == null) return; // Cancel

                                final newDateTime = DateTime(
                                  dateTime.year,
                                  dateTime.month,
                                  dateTime.day,
                                  time.hour,
                                  time.minute,
                                );

                                setState(() => dateTime = newDateTime);
                              },
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              height: 60,
              width: 120,
              child: FloatingActionButton(
                backgroundColor: cusColor,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Save',
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.save_rounded, color: Colors.white),
                ]), //child widget inside this button
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () async {
                  final User? user = FirebaseAuth.instance.currentUser;
                  setState(() {
                    chosendate =
                        "${dateTime.day}:${dateTime.month}:${dateTime.year}";
                    chosentime = "${dateTime.hour}:${dateTime.minute}";
                  });
                  print(markerData[0][1]);
                  print(markerData[0][2]);
                  print(markerData[0][0]);
                  print(sports);
                  print(chosenGame);
                  print(chosenAddress);
                  await DatabaseManager().addScheduleDate(
                    markerData[0][1],
                    chosenGame,
                    chosendate,
                    chosentime,
                    markerData[0][2],
                    markerData[0][0],
                    user!.uid,
                  );
                },
              ),
            ),
          );
        });
  }
  // Ends here {bottom sheet} -------------------------->

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      );
}

// Search Page
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Color black = Colors.black;

  // GoogleMapController? _googleMapController;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  Widget cusSearchbar = Text('Search Ground');
  Icon cusIcon = Icon(Icons.search);
  Color cusColor = Color.fromARGB(255, 174, 39, 39);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  // List for sports
  List sports = [];
  var groundName;
  var groundId;
  var groundAddress;
  // Date Time for data
  DateTime dateTime = DateTime.now();

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    var _latLng = LatLng(specify['latitude'], specify['longitude']);
    final Marker marker = Marker(
        markerId: markerId,
        position: _latLng,
        onTap: () {
          String? name;
          var document = FirebaseFirestore.instance
              .collection('GOwner')
              .doc(specify['OwnerId']);
          document.get().then((value) {
            name = value['name'];
          });
          _customInfoWindowController.addInfoWindow!(
              Column(
                children: [
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(specify['Ground Name'],
                                          style: TextStyle(fontSize: 20)),
                                      SizedBox(height: 8),
                                      Text(
                                          specify['Organization Type'] +
                                              ' Ground',
                                          style: TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 174, 39, 39),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: IconButton(
                                        onPressed: () {
                                          _searchbottomSheet(context);
                                        },
                                        icon: Icon(Icons.add)),
                                  )
                                ],
                              ),
                              Divider(color: Colors.black),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${specify['Opening Time']}:00',
                                      style: TextStyle(fontSize: 20)),
                                  Icon(Icons.arrow_forward),
                                  Text('${specify['Closing Time']}:00',
                                      style: TextStyle(fontSize: 20))
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(specify['Ground Type'] + ' PlayGround',
                                  style: TextStyle(fontSize: 20)),
                              SizedBox(height: 15),
                              Container(
                                height: 30,
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    // shrinkWrap: true,
                                    itemCount:
                                        specify['Available Sports'].length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          padding: EdgeInsets.all(7),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          height: 27,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Text(
                                                specify['Available Sports']
                                                    [index],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white)),
                                          ));
                                    }),
                              ),
                              SizedBox(height: 15),
                              Text(specify['Address'],
                                  style: TextStyle(fontSize: 20)),
                              Divider(color: Colors.black),
                              Text('Owner : $name',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 20)),
                              SizedBox(height: 10),
                            ],
                          ))),
                  Icon(Icons.arrow_drop_down_sharp)
                ],
              ),
              _latLng);
        });
    setState(() {
      markers[markerId] = marker;
      sports = specify['Available Sports'];
      groundName = specify['Ground Name'];
      groundId = specifyId;
      groundAddress = specify['Address'];
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
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Stack(
          children: [
            GoogleMap(
              markers: Set<Marker>.of(markers.values),
              mapType: MapType.normal,
              compassEnabled: true,
              trafficEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                  target: LatLng(22.72056, 75.84722), zoom: 13.0),
              onMapCreated: (controller) {
                _customInfoWindowController.googleMapController = controller;
              },
              onCameraMove: (position) {
                _customInfoWindowController.onCameraMove!();
              },
              onTap: (position) {
                _customInfoWindowController.hideInfoWindow!();
              },
            ),
            CustomInfoWindow(
              controller: _customInfoWindowController,
              height: 200,
              width: 300,
              offset: 35,
            )
          ],
        ),
      ),
    );
  }

  _searchbottomSheet(context) {
    // variable for database
    var chosenAddress = 'Choose Ground Location';
    var chosenGame;
    var chosendate;
    var chosentime;

    // Hour and Minute Code
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    // Ends here
    showModalBottomSheet(
        context: context,
        builder: (BuildContext c) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Schedule',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      groundName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField(
                      value: sports[0],
                      items: sports
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        chosenGame = value;
                      },
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: cusColor,
                      ),
                      dropdownColor: Color.fromARGB(255, 214, 111, 111),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.accessibility_new,
                          color: cusColor,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.black,
                          width: 3,
                        )),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text('Choose Timing'),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('Date'),
                            ElevatedButton(
                              child: Text(
                                  '${dateTime.year}/${dateTime.month}/${dateTime.day}'),
                              onPressed: () async {
                                final date = await pickDate();
                                if (date == null) return;

                                final newDateTime = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    dateTime.hour,
                                    dateTime.minute);

                                setState(() => dateTime = newDateTime);
                              },
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text('Time'),
                            ElevatedButton(
                              child: Text('$hours:$minutes'),
                              onPressed: () async {
                                final time = await pickTime();
                                if (time == null) return; // Cancel

                                final newDateTime = DateTime(
                                  dateTime.year,
                                  dateTime.month,
                                  dateTime.day,
                                  time.hour,
                                  time.minute,
                                );

                                setState(() => dateTime = newDateTime);
                              },
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              height: 60,
              width: 120,
              child: FloatingActionButton(
                backgroundColor: cusColor,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Save',
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.save_rounded, color: Colors.white),
                ]), //child widget inside this button
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () async {
                  final User? user = FirebaseAuth.instance.currentUser;
                  setState(() {
                    chosendate =
                        "${dateTime.day}:${dateTime.month}:${dateTime.year}";
                    chosentime = "${dateTime.hour}:${dateTime.minute}";
                  });
                  print(groundName);
                  print(groundAddress);
                  print(groundId);
                  print(sports);
                  print(chosenGame);
                  print(chosenAddress);
                  await DatabaseManager().addScheduleDate(
                    groundName,
                    chosenGame,
                    chosendate,
                    chosentime,
                    groundAddress,
                    groundId,
                    user!.uid,
                  );
                  // await FirebaseFirestore.instance
                  //     .collection('Ground')
                  //     .doc('groundId')
                  //     .collection('Players')
                  //     .doc(user.uid)
                  //     .set({'player': 'Player'});
                  Navigator.pop(context);
                },
              ),
            ),
          );
        });
  }
  // Ends here {bottom sheet} -------------------------->

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      );
}

// Pulling request page
class PlayerListPage extends StatefulWidget {
  const PlayerListPage({super.key});

  @override
  State<PlayerListPage> createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State<PlayerListPage> {
  List scheduleList = [];
  List playerInGround = [];

  @override
  void initState() {
    super.initState();
    fetchScheduleDataList();
    fetchPlayerinGround();
  }

  User? user = FirebaseAuth.instance.currentUser;

  fetchScheduleDataList() async {
    dynamic resultant = await DatabaseManager().getScheduleDataList(user!.uid);

    if (resultant == null) {
      print('Unable to Retrieve');
      print(user!.uid);
    } else {
      setState(() {
        scheduleList = resultant;
      });
    }
    // print(scheduleList[0]['Ground Id']);
  }

  fetchPlayerinGround() async {
    for (int i = 0; i < scheduleList.length; i++) {
      print(scheduleList[i]['Ground Id']);
      print(user!.uid);
      dynamic resultant = await DatabaseManager()
          .getPlayerInGroundList(scheduleList[i]['Ground Id'], user!.uid);

      setState(() {
        playerInGround[i] = resultant;
      });
    }
    print(playerInGround);
  }

  Color cusColor = Color.fromARGB(255, 174, 39, 39);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: cusColor,
          title: Text('Check Players',
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'codecpro',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1)),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(10),
        ));
  }
}

// Notification Page
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Color cusColor = Color.fromARGB(255, 174, 39, 39);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: cusColor,
        title: Text('Notifications',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'codecpro',
                fontWeight: FontWeight.w600,
                letterSpacing: 1)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.refresh_rounded),
          )
        ],
      ),
      body: Center(
        child: Container(
          width: 200,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/search.png'))),
        ),
      ),
    );
  }
}

// Profile Page
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  var age;
  var gender;
  var length;

  @override
  void initState() {
    super.initState();
    fetchProfileDetails();
    fetchScheduleDataList();
  }

  User? user = FirebaseAuth.instance.currentUser;

  fetchProfileDetails() async {
    List profile = await DatabaseManager().getPlayerDetails(user!.uid);
    setState(() {
      name = profile[0];
      age = profile[1];
      gender = profile[2];
    });
  }

  List scheduleList = [];

  fetchScheduleDataList() async {
    dynamic resultant = await DatabaseManager().getScheduleDataList(user!.uid);

    if (resultant == null) {
      print('Unable to Retrieve');
      print(user!.uid);
    } else {
      setState(() {
        scheduleList = resultant;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              Text(
                'My\nProfile',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Nisebuschgardens',
                    color: Color.fromARGB(255, 174, 39, 39)),
              ),
              Container(
                height: height * 0.4,
                child: LayoutBuilder(builder: (context, constraints) {
                  double innerHeight = constraints.maxHeight;
                  double innerWidth = constraints.maxWidth;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: innerHeight * 0.65,
                          width: innerWidth,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color.fromARGB(255, 174, 39, 39)),
                          child: Column(
                            children: [
                              SizedBox(height: 90),
                              Text(
                                '$name',
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text('Schedules',
                                          style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 8),
                                      Text('$scheduleList.length',
                                          style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 8),
                                    child: Container(
                                      height: 50,
                                      width: 5,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.black),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text('Pulled',
                                          style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 8),
                                      Text('0',
                                          style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ],
                              )
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
                    ],
                  );
                }),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: height * 0.4,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Stack(fit: StackFit.expand, children: [
                      Positioned(
                          child: Container(
                        height: height * 0.4,
                        width: width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color.fromARGB(255, 174, 39, 39)),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            SizedBox(
                              height: 50,
                              width: 400,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Setttings()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 174, 39, 39),
                                      side: BorderSide(
                                          width: 0.5, color: Colors.black)),
                                  child: Text(
                                    'Settings',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 50,
                              width: 400,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 174, 39, 39),
                                      side: BorderSide(
                                          width: 0.5, color: Colors.black)),
                                  child: Text(
                                    'Dark Mode',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 50,
                              width: 400,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 174, 39, 39),
                                      side: BorderSide(
                                          width: 0.5, color: Colors.black)),
                                  child: Text(
                                    'N/A',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 50,
                              width: 400,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => HelpPage()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 174, 39, 39),
                                      side: BorderSide(
                                          width: 0.5, color: Colors.black)),
                                  child: Text(
                                    'Help and Feedbook',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 50,
                              width: 400,
                              child: ElevatedButton(
                                  onPressed: () {
                                    final provider =
                                        Provider.of<GoogleSignInProvider>(
                                            context,
                                            listen: false);
                                    provider.googleLogout();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 174, 39, 39),
                                      side: BorderSide(
                                          width: 0.5, color: Colors.black)),
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ))
                    ]);
                  }))
            ],
          ),
        ),
      ),
    );
  }
}

// For ddddddsssssders pages

class GroundListPage extends StatefulWidget {
  const GroundListPage({super.key});

  @override
  State<GroundListPage> createState() => _GroundListPageState();
}

class _GroundListPageState extends State<GroundListPage> {
  List<String> sports = [
    'Badminton',
    'Cricket',
    'Football',
    'Hockey',
    'TableTennis',
    'Vollyball'
  ];

  List<String> types = [
    'Select Ground Type',
    'Indoor',
    'Outdoor',
    'Turf',
    'Other Activity Ground'
  ];
  String groundType = 'Select Ground Type';

  List<String> orgType = [
    'Organization Types',
    'Public',
    'Private',
  ];
  String organizationType = 'Organization Types';

  // Google Map API
  GoogleMapController? _googleMapController;

  // Google Map APi
  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  // Choose Date and time code ------------------------------->

  DateTime startingTime = DateTime(2022, 12, 24, 6, 0);
  DateTime endingTime = DateTime(2022, 12, 25, 12, 0);

  // Ends Here <------------------------

  Widget cusSearchbar = Text('Your Grounds');
  Icon cusIcon = Icon(Icons.search);
  Color cusColor = Color.fromARGB(255, 174, 39, 39);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: cusSearchbar,
        titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            fontFamily: 'codecpro'),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                if (cusIcon.icon == Icons.search) {
                  cusIcon = Icon(Icons.cancel);
                  cusSearchbar = TextField(
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        hintText: 'eg. schedule 1',
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none),
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'codecpro',
                        color: Colors.black),
                  );
                } else {
                  cusSearchbar = Text('HELLO');
                  cusIcon = Icon(Icons.search);
                }
              });
            },
            icon: cusIcon,
            color: Colors.black,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _registerGround(context);
        },
        backgroundColor: cusColor,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Text(
          '+',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  _registerGround(context) {
    // Hour and Minute Code
    final startingHour = startingTime.hour.toString().padLeft(2, '0');
    final startingMinute = startingTime.minute.toString().padLeft(2, '0');

    final endingHour = endingTime.hour.toString().padLeft(2, '0');
    final endingMinute = endingTime.minute.toString().padLeft(2, '0');
    // Ends here
    var chosenAddr = "Choose Ground location";
    List<String> chosenAvailSports = [];
    List<String> availSports = [];
    var groundName;
    var groundFees;
    var gid;

    showDialog(
        context: context,
        builder: (BuildContext c) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            icon: Icon(Icons.arrow_back_rounded)),
                        SizedBox(width: 10),
                        Text(
                          'Add Ground',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 2),
                          top: BorderSide(color: Colors.black, width: 2),
                          right: BorderSide(color: Colors.black, width: 2),
                          left: BorderSide(color: Colors.black, width: 2),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton(
                          onPressed: () async {
                            var result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => GetLocation()));
                            setState(() {
                              gid = result;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0.0,
                          ),
                          child: Row(children: [
                            Icon(Icons.location_on, color: Colors.black),
                            SizedBox(width: 20),
                            Text(
                              chosenAddr,
                            ),
                          ])),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.photo_size_select_large_rounded,
                            color: Colors.black,
                          ),
                          labelText: 'Ground Name',
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: cusColor),
                            borderRadius: BorderRadius.circular(5),
                          )),
                      onChanged: (value) {
                        groundName = value;
                      },
                    ),
                    SizedBox(height: 15),
                    TextField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.money,
                            color: Colors.black,
                          ),
                          labelText: 'Fees',
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: cusColor),
                            borderRadius: BorderRadius.circular(5),
                          )),
                      onChanged: (value) {
                        groundFees = value;
                      },
                    ),
                    SizedBox(height: 15),
                    DropDownMultiSelect(
                      options: sports,
                      whenEmpty: 'Select Available Games',
                      onChanged: (value) {
                        chosenAvailSports.addAll(value);
                        setState(() {
                          for (var element in chosenAvailSports) {
                            if (!availSports.contains(element)) {
                              availSports.add(element);
                            }
                          }
                        });
                      },
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: cusColor,
                      ),
                      selectedValues: availSports.toList(),
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField(
                      value: groundType,
                      items: types
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        groundType = value!;
                      },
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: cusColor,
                      ),
                      dropdownColor: Color.fromARGB(255, 214, 111, 111),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.difference,
                          color: cusColor,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.black,
                          width: 3,
                        )),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField(
                      value: organizationType,
                      items: orgType
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        organizationType = value!;
                      },
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: cusColor,
                      ),
                      dropdownColor: Color.fromARGB(255, 214, 111, 111),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.difference,
                          color: cusColor,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.black,
                          width: 3,
                        )),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Choose Timing'),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Opening',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: ElevatedButton(
                                child: Text(
                                  '$startingHour:$startingMinute',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                onPressed: () async {
                                  final time = await startingPickTime();
                                  if (time == null) return; // Cancel

                                  final newDateTime = DateTime(
                                    startingTime.year,
                                    startingTime.month,
                                    startingTime.day,
                                    time.hour,
                                    time.minute,
                                  );

                                  setState(() => startingTime = newDateTime);
                                },
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Closing',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: ElevatedButton(
                                child: Text(
                                  '$endingHour:$endingMinute',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                onPressed: () async {
                                  final time = await endingPickTime();
                                  if (time == null) return; // Cancel

                                  final newDateTime = DateTime(
                                    endingTime.year,
                                    endingTime.month,
                                    endingTime.day,
                                    time.hour,
                                    time.minute,
                                  );

                                  setState(() => endingTime = newDateTime);
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.95,
              child: FloatingActionButton(
                backgroundColor: cusColor,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Save',
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.save_rounded, color: Colors.white),
                ]), //child widget inside this button
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () async {
                  print(availSports.toList());
                  print(groundType);
                  print(startingTime);
                  print(endingTime);
                  print(groundFees);
                  print(groundName);
                  print(organizationType);
                  await DatabaseManager().addGroundData(
                      groundName,
                      groundFees,
                      availSports,
                      groundType,
                      organizationType,
                      startingTime.hour,
                      endingTime.hour,
                      gid);
                  Navigator.pop(context, gid);
                },
              ),
            ),
          );
        });
  }

  Future<TimeOfDay?> startingPickTime() => showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: startingTime.hour, minute: startingTime.minute),
      );

  Future<TimeOfDay?> endingPickTime() => showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: endingTime.hour, minute: endingTime.minute),
      );
}

class VenNotificationP extends StatefulWidget {
  const VenNotificationP({super.key});

  @override
  State<VenNotificationP> createState() => _VenNotificationPState();
}

class _VenNotificationPState extends State<VenNotificationP> {
  Widget cusSearchbar = Text('Notifications');
  Icon cusIcon = Icon(Icons.search);
  Color cusColor = Color.fromARGB(255, 174, 39, 39);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: cusColor,
        leading: Icon(Icons.notifications),
        title: Text('Notifications',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'codecpro',
                fontWeight: FontWeight.w600,
                letterSpacing: 1)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.refresh_rounded),
          )
        ],
      ),
      body: Center(
        child: Container(
          width: 200,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/search.png'))),
        ),
      ),
    );
  }
}

class VenProfilePage extends StatefulWidget {
  const VenProfilePage({super.key});

  @override
  State<VenProfilePage> createState() => _VenProfilePageState();
}

class _VenProfilePageState extends State<VenProfilePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 80),
          child: Column(
            children: [
              Text(
                'My\nProfile',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Nisebuschgardens',
                    color: Color.fromARGB(255, 174, 39, 39)),
              ),
              Container(
                height: height * 0.3,
                child: LayoutBuilder(builder: (context, constraints) {
                  double innerHeight = constraints.maxHeight;
                  double innerWidth = constraints.maxWidth;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: innerHeight * 0.65,
                          width: innerWidth,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    // spreadRadius: 5,
                                    blurRadius: 15.0,
                                    offset: Offset(0.0, 0.75))
                              ],
                              color: Color.fromARGB(255, 174, 39, 39)),
                          child: Column(
                            children: [
                              SizedBox(height: 115),
                              Text(
                                'Joe Burden',
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              )
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
                    ],
                  );
                }),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: height * 0.4,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Stack(fit: StackFit.expand, children: [
                      Positioned(
                          child: Container(
                        height: height * 0.4,
                        width: width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color.fromARGB(255, 174, 39, 39)),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            SizedBox(
                              height: 50,
                              width: 400,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Setttings()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 174, 39, 39),
                                      side: BorderSide(
                                          width: 0.5, color: Colors.black)),
                                  child: Text(
                                    'Settings',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 50,
                              width: 400,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 174, 39, 39),
                                      side: BorderSide(
                                          width: 0.5, color: Colors.black)),
                                  child: Text(
                                    'Dark Mode',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 50,
                              width: 400,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 174, 39, 39),
                                      side: BorderSide(
                                          width: 0.5, color: Colors.black)),
                                  child: Text(
                                    'N/A',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 50,
                              width: 400,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => HelpPage()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 174, 39, 39),
                                      side: BorderSide(
                                          width: 0.5, color: Colors.black)),
                                  child: Text(
                                    'Help and Feedbook',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 50,
                              width: 400,
                              child: ElevatedButton(
                                  onPressed: () {
                                    final provider =
                                        Provider.of<GoogleSignInProvider>(
                                            context,
                                            listen: false);
                                    provider.googleLogout();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 174, 39, 39),
                                      side: BorderSide(
                                          width: 0.5, color: Colors.black)),
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ))
                    ]);
                  }))
            ],
          ),
        ),
      ),
    );
  }
}

// Google Map Widget ------------------>------------------>------------>

// Ends Here  ------------------------->------------------->----------->

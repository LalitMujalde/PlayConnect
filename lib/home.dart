// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:major_project/db.dart';
import 'package:major_project/notification_services.dart';
import 'package:major_project/pages.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Icon dBoard = Icon(Icons.dashboard);
  Icon map = Icon(Icons.map);
  Icon notification = Icon(Icons.notifications);
  Icon profile = Icon(Icons.person);

  int _currentindex = 0;

  var tabs = [SchedulePage(), SearchPage(), PlayerListPage(), ProfilePage()];

  NotificationServices notificationServices = NotificationServices();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInterectMessage(context);
    // notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) async {
      print('Device token');
      print(value);
      await DatabaseManager().saveToken(value!, user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: tabs[_currentindex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentindex,
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: 15,
          selectedFontSize: 17,
          fixedColor: Color.fromARGB(255, 174, 39, 39),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.map_sharp), label: "Map"),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: "Players "),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
          ],
          onTap: (index) {
            setState(() {
              _currentindex = index;
            });
          },
        ),
      ),
    );
  }
}

class VenderHomePage extends StatefulWidget {
  const VenderHomePage({super.key});

  @override
  State<VenderHomePage> createState() => _VenderHomePageState();
}

class _VenderHomePageState extends State<VenderHomePage> {
  int _currentindex = 0;

  var tabs = [GroundListPage(), VenNotificationP(), VenProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentindex,
        type: BottomNavigationBarType.fixed,
        unselectedFontSize: 0,
        selectedFontSize: 17,
        fixedColor: Color.fromARGB(255, 174, 39, 39),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notification "),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ],
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
        },
      ),
    );
  }
}

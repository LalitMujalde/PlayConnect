// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:major_project/home.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors
    Color black = Colors.black;
    Color white = Colors.white;
    Color primaryColor = Color.fromARGB(255, 174, 39, 39);

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
        title: Text('HELP & FEEDBACK'),
        titleTextStyle: TextStyle(
            color: black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            fontFamily: 'codecpro'),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Icon(
            Icons.help,
            color: black,
          ),
          SizedBox(width: 10)
        ],
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: primaryColor, width: 2),
            top: BorderSide(color: primaryColor, width: 2),
            right: BorderSide(color: primaryColor, width: 2),
            left: BorderSide(color: primaryColor, width: 2),
          )),
          child: Text(
              'Currently We can not provide you any help sorry for inconveniency',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: black, fontSize: 20, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}

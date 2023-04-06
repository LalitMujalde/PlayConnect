// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, avoid_print, must_be_immutable, use_key_in_widget_constructors, no_logic_in_create_state, use_build_context_synchronously, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:major_project/home.dart';
import 'package:provider/provider.dart';
import 'google_sign_in.dart';

// select character page
class SelectChar extends StatefulWidget {
  @override
  State<SelectChar> createState() => _SelectCharState();
}

class _SelectCharState extends State<SelectChar> {
  String charC = '';

  Color primaryColor = Color.fromARGB(255, 174, 39, 39);
  Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Welcome",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "You can sign in as",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/crayon-2088.png'))),
              ),
              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      charC = 'playR';
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Login(charC: charC)));
                    },
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Player",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                      onPressed: () {
                        charC = 'vendR';
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Login(charC: charC)));
                      },
                      color: primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Ground Owner",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// login page
class Login extends StatefulWidget {
  String charC;
  Login({required this.charC});

  @override
  State<Login> createState() => _LoginState(charC);
}

class _LoginState extends State<Login> {
  Color primaryColor = Color.fromARGB(255, 174, 39, 39);
  Color backgroundColor = Colors.white;

  String charC;
  _LoginState(this.charC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SelectChar()));
          },
          icon: Icon(Icons.arrow_back_rounded, color: primaryColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Text(
                      'LOG IN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 38,
                          color: primaryColor,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 35, left: 35),
                      child: Column(
                        children: [
                          makeInput(
                              label: 'Email',
                              icon: Icon(Icons.alternate_email)),
                          SizedBox(height: 10),
                          makeInput(
                              label: 'Password',
                              obsecureText: true,
                              icon: Icon(Icons.lock)),
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
                              onPressed: () {
                                print(charC);
                                if (charC == 'playR') {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => HomePage()));
                                } else if (charC == 'vendR') {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => VenderHomePage()));
                                }
                              },
                              color: primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('or'),
                          SizedBox(height: 10),
                          Container(
                            height: 60,
                            width: 400,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border(
                                  bottom: BorderSide(color: Colors.black),
                                  top: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                )),
                            child: SignInButton(
                              Buttons.Google,
                              onPressed: () async {
                                print(charC);
                                if (charC == 'playR') {
                                  final provider =
                                      Provider.of<GoogleSignInProvider>(context,
                                          listen: false);
                                  await provider.signInWithGoogle(context);
                                } else if (charC == 'vendR') {
                                  final provider =
                                      Provider.of<GoogleSignInProvider>(context,
                                          listen: false);
                                  await provider
                                      .venderSignInWithGoogle(context);
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Container(
                      child: Image.asset(
                        'assets/pablo-sign-in.png',
                        fit: BoxFit.fill,
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}

Widget makeInput({label, obsecureText = false, icon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black87)),
      SizedBox(height: 5),
      TextField(
        obscureText: obsecureText,
        decoration: InputDecoration(
            prefixIcon: icon,
            prefixIconColor: Colors.black,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400))),
      )
    ],
  );
}

// After Login Page
class NavigationForLogin extends StatelessWidget {
  const NavigationForLogin({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              final User? user = FirebaseAuth.instance.currentUser;
              DocumentReference<Map<String, dynamic>> usersRef =
                  FirebaseFirestore.instance
                      .collection('GOwner')
                      .doc(user!.uid);
              usersRef.get().then((docSnapshot) => {
                    if (docSnapshot.exists)
                      {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VenderHomePage()))
                      }
                  });
              return HomePage();
            } else if (snapshot.hasError) {
              return Center(child: Text('Something Gone Wrong!'));
            } else {
              return SelectChar();
            }
          },
        ),
      );
}

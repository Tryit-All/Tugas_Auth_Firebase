// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, sort_child_properties_last, prefer_final_fields

import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:fat_app/home.dart';
import 'package:fat_app/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:get/get_core/get_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  login() async {
    try {
      _firebaseAuth
          .signInWithEmailAndPassword(
              email: emailC.text, password: passwordC.text)
          .then((value) =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => home(),
              )));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // color: Colors.amber,
              child:
                  Image(fit: BoxFit.fill, image: AssetImage("image/login.png")),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    // color: Colors.red,
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, '/splash'),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 320, 0),
                        child: Image(image: AssetImage("image/back.png")),
                      ),
                    ),
                    // child: Padding(
                    //   padding: const EdgeInsets.fromLTRB(10, 0, 320, 0),
                    //   child: Image(image: AssetImage("image/back.png")),
                    // ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    // color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 30, 200, 0),
                      child: Text(
                        "Welcome",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 160,
                  ),
                  Container(
                    width: 322,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          child: Stack(
                            children: [
                              Container(
                                width: 301,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Color(0xffd4d4d4),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3f000000),
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                  color: Color(0xfffefefe),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 20,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 200,
                                    // color: Colors.green,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: TextField(
                                        controller: emailC,
                                        obscureText: false,
                                        decoration: InputDecoration.collapsed(
                                          hintText: "Username",
                                          hintStyle: TextStyle(
                                              color: Color(0xffa4a4a4),
                                              fontSize: 15),
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 322,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Stack(
                            children: [
                              Container(
                                width: 301,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Color(0xffd4d4d4),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3f000000),
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                  color: Color(0xfffefefe),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 20,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 200,
                                    // color: Colors.green,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: TextField(
                                        controller: passwordC,
                                        obscureText: true,
                                        decoration: InputDecoration.collapsed(
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                              color: Color(0xffa4a4a4),
                                              fontSize: 15),
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                    //log in
                    width: 305,
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        login();
                      },
                      child:
                          Text("Log In", style: TextStyle(color: Colors.white)),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Color(0xfffeffff),
                        width: 1,
                      ),
                      color: Color(0xff006bff),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Or",
                        style: TextStyle(
                          color: Color(0xff8a8a8a),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //sign up
                    width: 301,
                    height: 39,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text("Sign up",
                          style: TextStyle(color: Color(0xff006bff))),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Color(0xff006bff),
                        width: 1,
                      ),
                      color: Color(0xfffefefe),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

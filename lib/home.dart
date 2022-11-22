// ignore_for_file: duplicate_import, unused_import, unnecessary_import, prefer_const_constructors, sort_child_properties_last

import 'package:fat_app/main.dart';
import 'package:fat_app/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';
import 'login.dart';
import './models.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:platform/platform.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
  //Data

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _noTelp = TextEditingController();

  //Geolocation $geocoding
  final TextEditingController lokasi = TextEditingController();
  int _counter = 0;
  String location = 'Belum mendapatkan lat dan long, Silahkan tekan betton';
  String address = 'Mencari lokasi.....';

  Future<Position> _getGeolocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permission denied forever, we cannot access',
      );
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image(
                    fit: BoxFit.fill, image: AssetImage("image/home.png"))),
            Column(
              children: [
                Container(
                  width: 220,
                  height: 60,
                  // color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 45, left: 30),
                    child: Text(
                      'Hello, Fathurrahman Dwi K!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Container(
                  width: 220,
                  height: 60,
                  // color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7, left: 30),
                    child: Text(
                      'Fathur attended 3 trainings',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 220,
                ),
                Container(
                    width: 82,
                    height: 120,
                    // color: Colors.amber,
                    child: GestureDetector(
                        onTap: () {},
                        child: Image(
                            image: AssetImage("image/lingkaranBell.png")))),
                Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                        color: Colors.white),
                    // color: Colors.deepOrange,
                    child: InkWell(
                      child: Icon(Icons.logout, color: Colors.blue, size: 30),
                      onTap: () {
                        setState(() {
                          _signOut().then((value) => Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => login(),
                              )));
                        });
                      },
                    )),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 120,
                ),
                Container(
                    width: 350,
                    height: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color(0xffd4d4d4),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                        color: Colors.white),
                    child: Container(
                      // color: Colors.amber,
                      child: Row(
                        children: [
                          Container(
                            width: 55,
                            // color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_history),
                                SizedBox(
                                  height: 15,
                                ),
                                Icon(Icons.location_searching_outlined)
                              ],
                            ),
                          ),
                          Container(
                            // color: Colors.black,
                            width: 290,
                            child: Column(
                              children: [
                                Container(
                                  // color: Colors.blue,
                                  height: 44,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        location,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        '${address}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 5),
                                  child: TextField(
                                    controller: lokasi,
                                    obscureText: false,
                                    decoration: InputDecoration.collapsed(
                                      hintText: "Isikan lokasi anda",
                                      hintStyle: TextStyle(
                                          color: Color(0xffa4a4a4),
                                          fontSize: 15),
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              Position position =
                                  await _getGeolocationPosition();
                              setState(() {
                                location =
                                    '${position.latitude}, ${position.longitude}';
                              });
                              getAddressFromLongLat(position);
                            },
                            child: Icon(Icons.map),
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(30.0),
                            shadowColor: Colors.lightBlueAccent.shade100,
                            elevation: 5.0,
                            child: MaterialButton(
                              minWidth: 40,
                              height: 70.0,
                              onPressed: () {
                                final Intent = AndroidIntent(
                                    action: 'action_view',
                                    data: Uri.encodeFull(
                                        'google.navigation:q=${lokasi.text}&avoid=tf'),
                                    package: 'com.google.android.apps.maps');
                                Intent.launch();
                              },
                              child: Text(
                                'Cari Alamat',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 88, 94, 104)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // color: Colors.deepPurpleAccent,
                  ),
                  height: 40,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data Akun :',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // width: MediaQuery.of(context).size.width,
                // height: 600,
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Row(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           'Koordinat Point :',
                //           style: TextStyle(
                //               fontSize: 20.0,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.white),
                //         ),
                //         SizedBox(
                //           width: 20.0,
                //         ),
                //         Container(
                //           width: 200,
                //           child: Text(
                //             "${location}",
                //             style: TextStyle(
                //                 fontSize: 12.0,
                //                 fontWeight: FontWeight.bold,
                //                 color: Colors.white),
                //           ),
                //         ),
                //       ],
                //     ),
                //     SizedBox(
                //       height: 20.0,
                //     ),
                //     Row(
                //       children: [
                //         const Text(
                //           'Alamat :',
                //           style: TextStyle(
                //               fontSize: 22.0,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.white),
                //         ),
                //         SizedBox(
                //           width: 20.0,
                //         ),
                //         Text(
                //           '${address}',
                //           style: TextStyle(
                //               fontSize: 22.0,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.white),
                //         ),
                //       ],
                //     ),
                //     ElevatedButton(
                //       onPressed: () async {
                //         Position position = await _getGeolocationPosition();
                //         setState(() {
                //           location =
                //               '${position.latitude}, ${position.longitude}';
                //         });
                //         getAddressFromLongLat(position);
                //       },
                //       child: const Text('Get Koordinat'),
                //     ),
                //     SizedBox(
                //       height: 40,
                //     ),
                //     const Text(
                //       'Tujuan Anda',
                //       style: TextStyle(
                //           fontSize: 22.0,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white),
                //     ),
                //     SizedBox(
                //       height: 10.0,
                //     ),
                //     TextFormField(
                //       autofocus: false,
                //       obscureText: false,
                //       controller: lokasi,
                //       decoration: InputDecoration(
                //           hintText: 'Location Tujuan anda',
                //           contentPadding:
                //               EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                //           border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(32.0)),
                //           focusColor: Colors.white),
                //     ),
                //     Padding(
                //       padding: EdgeInsets.symmetric(vertical: 16.0),
                //       child: Material(
                //         borderRadius: BorderRadius.circular(30.0),
                //         shadowColor: Colors.black,
                //         elevation: 5.0,
                //         child: MaterialButton(
                //           minWidth: 200.0,
                //           height: 42.0,
                //           onPressed: () {
                //             final Intent = AndroidIntent(
                //                 action: 'action_view',
                //                 data: lokasi.text,
                //                 package: 'com.google.android.apps.maps');
                //             Intent.launch();
                //           },
                //           child: Text(
                //             'Cari Alamat',
                //             style: TextStyle(
                //                 color: Color.fromARGB(255, 88, 94, 104)),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                // padding: const EdgeInsets.only(right: 25.0, left: 25.0),
                // child: Container(
                //   width: MediaQuery.of(context).size.width,
                //   height: 600,
                //   child: ListView.separated(
                //     itemBuilder: (ctx, i) {
                //       return ListTile(
                //         onTap: () => Get.to(items[i].page),
                //         title: Text(
                //           items[i].name,
                //           style: TextStyle(
                //               color: Colors.white,
                //               fontWeight: FontWeight.bold),
                //         ),
                //         subtitle: Text(
                //           items[i].message,
                //           style: TextStyle(
                //             color: Colors.white,
                //           ),
                //         ),
                //         trailing: Text(
                //           items[i].time,
                //           style: TextStyle(
                //             color: Colors.white,
                //           ),
                //         ),
                //       );
                //     },
                //     separatorBuilder: (ctx, i) {
                //       return Divider();
                //     },
                //     itemCount: items.length,
                //   ),
                //   // color: Colors.brown,
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'dart:ui';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:michelie2/categoryPage.dart';
import 'package:michelie2/drinkPage.dart';
import 'package:michelie2/toiletriesPage.dart';
import 'package:michelie2/snackPage.dart';
import 'package:michelie2/instantFoodPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:michelie2/topupPage.dart';
import 'package:michelie2/historyPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:michelie2/loginPage.dart';
import 'package:michelie2/scanQR.dart';
import 'package:provider/provider.dart';
import 'dataHandler.dart';
import 'registerName.dart';

double containWidth = 70;
double containHeight = 70;
num balance=0;
Stream<DocumentSnapshot> streamBalance =
    FirebaseFirestore.instance.collection('user').doc('dummyData').snapshots();

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final List<String> imgList = [
    'lib/images/3.png',
    'lib/images/instantNudel.png',
    'lib/images/test.jpeg',
  ];
  @override
  void initState()  {
    super.initState();
    
   fetchData();
  }

  void fetchData() async{
     final User? TempUid = FirebaseAuth.instance.currentUser;
    String uidS = TempUid!.uid;//get uid
    
      Provider.of<dataHandler>(context, listen: false).pullUid(TempUid.uid);
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("users").doc(uidS);
          DocumentSnapshot documentSnapshot = await documentReference.get();
          if (documentSnapshot.exists) {
              Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
              if (data != null && data.containsKey('firstName')) { //if field name exist
                } else { //if field name does not exist
                   Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => registerName()),
              );
                }
              } else {
                // The document does not exist
              }
    

  }
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color(0xFFF0F0F0),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 50.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hello,",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Gilroy',
                                  color: Color(0xFF323232)),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Stack(
                              children: [
                                 Align(
                                    alignment: Alignment.topLeft,
                                   child: Container(
                                      width: 350,
                                      height: 35,
                                     child: const Text(
                                      "Frederico Godwyn",
                                      style: TextStyle(
                                          fontSize: 27,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Gilroy',
                                          color: Color(0xFF323232)),
                                                                   ),
                                   ),
                                 ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 280,bottom: 0),
                                  // left: 280,
                                  // // bottom: 0,
                                  // top: 0.4,
                                  child: IconButton(
                                    color: Colors.red.shade400,
                                    iconSize: 32,
                                  icon: const Icon(Icons.logout),
                                  onPressed: ()async {
                                    await _signOut();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) => const LoginPage()),
                                    );
                                  },
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12.0, left: 0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 340,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00A4E4),
                                        borderRadius:
                                            BorderRadius.circular(35.07),
                                        boxShadow: [
                                          // Inner top shadow
                                          BoxShadow(
                                            color: const Color(0xFF000000)
                                                .withOpacity(0.65),
                                            offset: const Offset(0, -3),
                                            blurRadius: 12,
                                            inset: true,
                                          ),
                                          // Inner bottom shadow
                                          BoxShadow(
                                            color: const Color(0xFFFFFFFF)
                                                .withOpacity(0.8),
                                            offset: const Offset(3, 1),
                                            blurRadius: 20,
                                            inset: true,
                                          ),
                                          // Outer drop shadow
                                          BoxShadow(
                                            color: const Color(0xFFCCEDFA)
                                                .withOpacity(1),
                                            offset: const Offset(0, 7),
                                            blurRadius: 20,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, top: 20.0),
                                              child: Container(
                                                width: 142,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(35),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(35),
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 5, sigmaY: 5),
                                                    child: Container(
                                                      color: Colors.white
                                                          .withOpacity(0.2),
                                                      child: const Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons
                                                                    .account_balance_wallet,
                                                                color: Color(
                                                                    0xFFCCEDFA),
                                                              ), // Add your icon here
                                                              SizedBox(
                                                                  width:
                                                                      10), // Add some spacing between the icon and the text
                                                              Text(
                                                                'e-Wallet',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                // Adjust this flex value to control the space allocated to the StreamBuilder
                                                flex: 2,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 30, top: 0.0),
                                                    child: StreamBuilder<
                                                        DocumentSnapshot>(
                                                      stream: streamBalance,
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  DocumentSnapshot>
                                                              snapshot) {
                                                        if (snapshot.hasError) {
                                                          return Text(
                                                              'Error: ${snapshot.error}');
                                                        }
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return  Text(
                                                          "Rp ${NumberFormat('#,##0', 'id_ID').format(balance)}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 26.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily: 'Inter',
                                                            color: Color(
                                                                0xFFEAE3E3),
                                                          ),
                                                        );
                                                        }

                                                        Map<String, dynamic>
                                                            data = snapshot.data
                                                                    ?.data()
                                                                as Map<String,
                                                                    dynamic>;
                                                                    balance=data['value']??0;
                                                        return Text(
                                                          "Rp ${NumberFormat('#,##0', 'id_ID').format(data['value'] ?? 0)}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 24.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily: 'Inter',
                                                            color: Color(
                                                                0xFFEAE3E3),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                               Expanded(
                                                // Adjust this flex value to control the space allocated to the Column
                                                flex: 2,
                                                child: Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const topupPage()),
                                                        );
                                                      },
                                                      child:Container(
                                                        width: 80,
                                                        color: Colors.transparent,
                                                        child: const Icon(
                                                          Icons
                                                              .add_circle_outline_rounded,
                                                          color: Color(0xFFEAE3E3),
                                                          size: 50,
                                                        ),
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5.0),
                                                      child: Text(
                                                        "Top Up",
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Inter',
                                                          color:
                                                              Color(0xFFEAE3E3),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, left: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween, // Add this line
                                    children: [
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      const Text(
                                        "Category",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Gilroy',
                                          color: Color(0xFF323232),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 180,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const CategoryPage()),
                                          );
                                        },
                                        child: Container(
                                          width: 80,
                                        height: 32,
                                        color: Colors.transparent,
                                        alignment: Alignment.center,
                                          child: const Text(
                                            "See All",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Gilroy',
                                              color: Color(0xFF00A4E4),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(height: 18),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0.0, right: 10, left: 0),
                                            child: SizedBox(
                                              height: containHeight,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                          255, 164, 203, 222)
                                                      .withOpacity(0.6),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const drinkTab()),
                                                    );
                                                  },
                                                  child: Image.asset(
                                                    'lib/images/1.png',
                                                    width: containWidth,
                                                    height: containHeight,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, right: 7),
                                            child: Text(
                                              "Drinks",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Gilroy',
                                                  color: Color(0xFF323232)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 18),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0, right: 10, left: 10),
                                            child: SizedBox(
                                              height: containHeight,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                          255, 164, 203, 222)
                                                      .withOpacity(0.6),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ToiletriesTab()),
                                                    );
                                                  },
                                                  child: Image.asset(
                                                    'lib/images/2.png',
                                                    width: containWidth,
                                                    height: containHeight,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Toiletries",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Gilroy',
                                                  color: Color(0xFF323232)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 18),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18.0, right: 10, left: 10),
                                            child: SizedBox(
                                              height: containHeight,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                          255, 164, 203, 222)
                                                      .withOpacity(0.6),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const instantFoodTab()),
                                                    );
                                                  },
                                                  child: Image.asset(
                                                    'lib/images/instantNudel.png',
                                                    width: containWidth,
                                                    height: containHeight,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Instant \n  Food",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Gilroy',
                                                  color: Color(0xFF323232)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0, right: 10, left: 10),
                                            child: SizedBox(
                                              height: containHeight,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                          255, 164, 203, 222)
                                                      .withOpacity(0.6),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const snackTab()),
                                                    );
                                                  },
                                                  child: Image.asset(
                                                    'lib/images/3.png',
                                                    width: containWidth,
                                                    height: containHeight,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Snacks",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Gilroy',
                                                  color: Color(0xFF323232)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 3, left: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 10, left: 15),
                                    child: Text(
                                      "Promotion",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Gilroy',
                                          color: Color(0xFF323232)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 0),
                    child: Column(children: [
                      SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: PageView.builder(
                            itemCount: imgList.length,
                            controller: PageController(
                                initialPage: 1, viewportFraction: 0.9),
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  imgList[index],
                                  fit: BoxFit.contain,
                                ),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 34),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Text(
                                "News",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Gilroy',
                                    color: Color(0xFF323232)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "lib/images/3.png",
                              height: 100,
                              width: 100,
                            )),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: SizedBox(
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30, left: 0),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'lib/images/page1/Home.svg',
                            height: 90,
                            width: 90,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      const Positioned(
                        top: 45,
                        left: 7,
                        right: 0,
                        bottom: 0,
                        child: Text("Home",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gilroy',
                                color: Color(0xFF323232))),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 30, left: 0, top: 10),
                        child: GestureDetector(
                          onTap: () {
                            // Handle your button tap here
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ScanQR()),
                            );
                          },
                          child: SvgPicture.asset(
                            'lib/images/page1/cart.svg',
                            height: 90, // Adjust as needed
                            width: 90, // Adjust as needed
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      const Positioned(
                        top: 52,
                        left: 30,
                        right: 0,
                        bottom: 0,
                        child: Text("Shop",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gilroy',
                                color: Color(0xFF323232))),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30, left: 0),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'lib/images/page1/history.svg',
                            height: 90,
                            width: 90,
                          ),
                          onPressed: () {
                            // Handle your button tap here
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const historyPage()),
                            );
                          },
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      const Positioned(
                        top: 45,
                        left: 3,
                        right: 0,
                        bottom: 0,
                        child: Text("History",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gilroy',
                                color: Color(0xFF323232))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:intl/intl.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:michelie2/homePage.dart';


int topupBalance = 0;
TextEditingController _controller = TextEditingController();
List<String> imagesNames = [
  '1.png',
  '2.png',
  '4.png',
  '6.png',
  '7.png',
  '8.png'
];
List<String> imageDescriptions = [
  'Rp15.000',
  'Rp50.000',
  'Rp100.000',
  'Rp200.000',
  'Rp300.000',
  'Rp500.000'
];

class topupPage extends StatefulWidget {
  const topupPage({super.key});

  @override
  
  State<topupPage> createState() => _topupPageState();
}

class _topupPageState extends State<topupPage> {
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _controller.clear();
    setState(() {
      _controller.text = '0';
    });
  });
}
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                // Top Bar icon
                padding: const EdgeInsets.only(top: 45.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 30,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const Row(
                // Text Top Up
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, top: 8.0),
                    child: Text(
                      "Top Up",
                      style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy',
                          color: Color(0xFF323232)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Row(
                // Text Top Up Amount
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    // Top Up Amount
                    padding: EdgeInsets.only(left: 17.0),
                    child: Text(
                      "Choose an amount or enter your own",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      color: Colors.grey,
                    )), // Underline decoration
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Rp',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy',
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                          width: 10.0), // Space between 'Rp' and the TextField
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              _controller.clear();
                              topupBalance = 0;
                              return;
                            }
                            topupBalance = int.parse(value.replaceAll(
                                RegExp(r'[.,]'),
                                '')); // Update the value variable
                            String newText = NumberFormat('#,##0', 'id_ID')
                                .format(topupBalance);
                            _controller.value = _controller.value.copyWith(
                              text: newText,
                              selection: TextSelection.collapsed(
                                  offset: newText.length),
                            );
                          },
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Gilroy',
                            color: Color(0xFF323232),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder
                                .none, // Remove border of the TextField
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                //List View Builder
                padding: const EdgeInsets.all(5.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: imagesNames.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      mainAxisExtent: 120),
                  itemBuilder: (context, int index) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (imageDescriptions[index] == 'Rp15.000') {
                                topupBalance = 15000;
                              } else if (imageDescriptions[index] ==
                                  'Rp50.000') {
                                topupBalance = 50000;
                              } else if (imageDescriptions[index] ==
                                  'Rp100.000') {
                                topupBalance = 100000;
                              } else if (imageDescriptions[index] ==
                                  'Rp200.000') {
                                topupBalance = 200000;
                              } else if (imageDescriptions[index] ==
                                  'Rp300.000') {
                                topupBalance = 300000;
                              } else if (imageDescriptions[index] ==
                                  'Rp500.000') {
                                topupBalance = 500000;
                              }
                              String newText = NumberFormat('#,##0', 'id_ID')
                                  .format(topupBalance);
                              _controller.value = _controller.value.copyWith(
                                text: newText,
                                selection: TextSelection.collapsed(
                                    offset: newText.length),
                              );
                            },
                            child: Container(
                              height: 100,
                              width: 89,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffF5F5F5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2.2,
                                    blurRadius: 1,
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Center(
                                      child: Image.asset(
                                        'lib/images/topupPage/${imagesNames[index]}',
                                        height: 60,
                                        width: 60, // Adjust as needed
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    imageDescriptions[index],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Gilroy',
                                        color: Color(
                                            0xFF323232)), // Adjust as needed
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  FirebaseFirestore.instance
                      .collection('user')
                      .doc('dummyData')
                      .update({'value': FieldValue.increment(topupBalance)});
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(builder: (context) => homePage()),
                  )
                      .then((_) {
                    // This code will run when you return from the new screen
                    topupBalance = 0;
                    _controller.clear();
                    _controller.value = _controller.value.copyWith(
                      text: '',
                      selection: TextSelection.collapsed(offset: 0),
                    );
                  });
                  FirebaseFirestore.instance
                      .collection('user')
                      .doc('dummyData')
                      .collection('history')
                      .add({'value': (topupBalance),
                      'status': 'Top Up',
                      'date': DateTime.now(),
                      }
                      );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A4E4),
                    borderRadius: BorderRadius.circular(35.07),
                    boxShadow: [
                      // Inner top shadow
                      BoxShadow(
                        color: const Color(0xFF000000).withOpacity(0.65),
                        offset: const Offset(0, -3),
                        blurRadius: 12,
                        inset: true,
                      ),
                      // Inner bottom shadow
                      BoxShadow(
                        color: const Color(0xFFFFFFFF).withOpacity(0.8),
                        offset: const Offset(3, 1),
                        blurRadius: 20,
                        inset: true,
                      ),
                      // Outer drop shadow
                      BoxShadow(
                        color: const Color(0xFFCCEDFA).withOpacity(1),
                        offset: const Offset(0, 7),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                        color:
                            Colors.white.withOpacity(0.85)), // Adjust as needed
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

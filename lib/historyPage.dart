import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class historyPage extends StatefulWidget {
  const historyPage({super.key});

  @override
  State<historyPage> createState() => _historyPageState();
}

class _historyPageState extends State<historyPage> {
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color(0xffF5F5F5),
          appBar: AppBar(
            backgroundColor: Color(0xffF5F5F5),
            elevation: 0,
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 30,
                  color: Color(0xff323232),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "History",
                    style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                        color: Color(0xFF323232)),
                  ),
                ),
              ],
            ),
          ),
          body: Center(
            child: Column(children: [
              Expanded(
                child: StreamBuilder <QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .doc('dummyData')
                        .collection('history')
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          String Status = snapshot.data?.docs[index]['status'];
                          num value = snapshot.data?.docs[index]['value'];
                          Timestamp timestamp = snapshot.data?.docs[index]['date'];
                          String formattedDate = DateFormat('d MMM, HH:mm').format(timestamp.toDate());
                          String statusPic= Status.replaceAll(' ', '');
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 128,
                              width: 128,
                              child: Card(
                                color: Colors.white.withOpacity(0.9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left:7.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top:20.0, left: 20),
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                 color: Colors.transparent,
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'lib/images/historyPhoto/$statusPic.png'),
                                                  fit: BoxFit.fill,
                                                 
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom:18.0,left: 40, top: 20),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom:1.0),
                                                    child: Text(
                                                      Status,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'inter',
                                                          color: Color(0xFF323232)),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Rp ${NumberFormat('#,##0', 'id_ID').format(value)}",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Gilroy',
                                                        color: Color(0xFF323232)),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    formattedDate,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.normal,
                                                        fontFamily: 'inter',
                                                        color: Color(0xFF323232)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    ),
              ),
            ]),
          )),
    );

  }
}
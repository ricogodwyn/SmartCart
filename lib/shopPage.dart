import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dataHandler.dart';
import 'homePage.dart';

class shopPage extends StatefulWidget {
  const shopPage({super.key});

  @override
  State<shopPage> createState() => _shopPageState();
}

class _shopPageState extends State<shopPage> {
  List<DocumentSnapshot> filteredItems = [];
  List<int> hargaList = [];
  List<int> quantityList = [];
  List<num> priceList = [];
  num total = 0;
  num totalPrice = 0;
  int totalAll = 0;
  num? lastKnownValue; // Variable to store the last known numeric value
  void initState() {
    super.initState();
    _pullData();
  }

  void _pullData() async {
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc('dummyData')
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          lastKnownValue = data['value']; // Update the UI with the new value
        });
      }
    } catch (error) {
      // Handle any errors here
    }
  }

  DateTime _parseWaktu(String waktuStr) {
    return DateTime.parse('${waktuStr.substring(0, 4)}-' + // Year
            '${waktuStr.substring(4, 6)}-' + // Month
            '${waktuStr.substring(6, 8)} ' + // Day
            '${waktuStr.substring(8, 10)}:' + // Hour
            '${waktuStr.substring(10, 12)}:' + // Minute
            '${waktuStr.substring(12, 14)}' // Second
        );
  }

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
                  "Item List",
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
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('user')
                      .doc('dummyData')
                      .collection('itemList')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var filteredItems = snapshot.data?.docs
                            .where((element) => element['quantity'] > 0)
                            .toList() ??
                        [];
                    filteredItems.sort((a, b) {
                      DateTime dateTimeA = _parseWaktu(a['waktu'].toString());
                      DateTime dateTimeB = _parseWaktu(b['waktu'].toString());
                      return dateTimeA.compareTo(dateTimeB);
                    });
                    int newTotalPrice = 0;
                    filteredItems.forEach((element) {
                      int price = element['harga'];
                      int quantity = element['quantity'];
                      newTotalPrice += price * quantity;
                    });

                    // snapshot.data?.docs.forEach((element) {
                    //   int price = element['harga'];
                    //   int quantity = element['quantity'];
                    //   newTotalPrice += price * quantity;

                    //   totalAll = newTotalPrice + (newTotalPrice * 0.05).round();
                    // });
                    if (newTotalPrice !=
                        Provider.of<dataHandler>(context, listen: false)
                            .checkoutPrice) {
                      Provider.of<dataHandler>(context, listen: false)
                          .pullCheckoutPrice(newTotalPrice);
                    }

                    // untuk menentukan apakah ada perubahan data atau tidak
                    //jika ada perubahan data maka akan diupdate UInya
                    return ListView.builder(
                      key: PageStorageKey<String>('itemList'),
                      shrinkWrap: true,
                      itemCount: filteredItems
                          .length, // Use the length of the filtered list
                      itemBuilder: (context, index) {
                        var item =
                            filteredItems[index]; // Reference the filtered list
                        String namaItem = item['namaItem'];
                        int harga = item['harga'];
                        int quantity = item['quantity'];
                        int productPrice = harga * quantity;
                        String itemPic = namaItem.replaceAll(' ', '');
                        // totalPrice += productPrice;
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
                              elevation: 0.7,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 7.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 120,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'lib/images/fotoProduk/$itemPic.png'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 18.0, left: 7),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 4.0),
                                                  child: Text(
                                                    namaItem,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'inter',
                                                        color:
                                                            Color(0xFF323232)),
                                                  ),
                                                ),
                                                Text(
                                                  "Rp ${NumberFormat('#,##0', 'id_ID').format(harga)} x $quantity",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Gilroy',
                                                      color: Color.fromARGB(
                                                          255, 135, 133, 133)),
                                                ),
                                                SizedBox(height: 7),
                                                Text(
                                                  "Rp ${NumberFormat('#,##0', 'id_ID').format(productPrice)}",
                                                  // "Rp. ${harga * quantity}",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Gilroy',
                                                      color: Color.fromARGB(
                                                          255, 2, 130, 181)),
                                                )
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
                  }),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 200,
          color: Color(0xffF5F5F5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Product Total",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy',
                          color: Colors.grey[600]),
                    ),
                    Text(
                      NumberFormat.currency(
                              locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                          .format(
                              Provider.of<dataHandler>(context).checkoutPrice),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                        color: Color(0xFF323232),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.0, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Service Fee (5%)",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                        NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0)
                            .format(Provider.of<dataHandler>(context)
                                    .checkoutPrice *
                                0.05),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy',
                          color: Color(0xFF323232),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.0, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Price",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                        NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0)
                            .format(Provider.of<dataHandler>(context)
                                    .checkoutPrice +
                                (Provider.of<dataHandler>(context)
                                        .checkoutPrice *
                                    0.05)),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy',
                          color: Color.fromARGB(255, 2, 130, 181),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: InkWell(
                    onTap: () async {
                      // Ensure that the UI is updated with the latest data
                      _pullData();
                      // Use a microtask to ensure provider state is updated
                      await Future.delayed(Duration.zero);

                      // Fetch the latest checkout price
                      final currentCheckoutPrice =
                          Provider.of<dataHandler>(context, listen: false)
                              .checkoutPrice;

                      if (lastKnownValue != null &&
                          lastKnownValue! >= currentCheckoutPrice && currentCheckoutPrice != 0) {
                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;

                        // Get the item list collection reference
                        CollectionReference itemList = firestore
                            .collection('user')
                            .doc('dummyData')
                            .collection('itemList');

                        // Fetch all item documents
                        QuerySnapshot querySnapshot = await itemList.get();

                        // Update quantity of each item to 0
                        for (QueryDocumentSnapshot item in querySnapshot.docs) {
                          await item.reference.update({'quantity': 0});
                        }
                        // Calculate new value after checkout
                        num newValue =
                            (lastKnownValue ?? 0) - currentCheckoutPrice;
                        await firestore
                            .collection('user')
                            .doc('dummyData')
                            .update({'payStatus': true});
                        // Update user's balance
                        await firestore
                            .collection('user')
                            .doc('dummyData')
                            .update({'value': newValue});

                        // Add a new entry to the history collection
                        await firestore
                            .collection('user')
                            .doc('dummyData')
                            .collection('history')
                            .add({
                          'value': currentCheckoutPrice,
                          'status': 'Payment',
                          'date': DateTime.now(),
                        });

                        // Navigate to the home page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => homePage()),
                        );
                      } else {
                        // Show dialog for insufficient balance
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Insufficient Balance or there is no item in the cart",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Gilroy',
                                  color: Color(0xFF323232),
                                ),
                              ),
                              content: Text("Please top up your balance or add item in the cart",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Inter',
                                    color: Color(0xFF323232),
                                  )),
                              actions: [
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();                                    
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 2, 130, 181),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Checkout",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Gilroy',
                              color: Colors.white),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

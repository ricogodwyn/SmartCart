import 'package:flutter/material.dart';

import 'package:michelie2/homePage.dart';
import 'package:flutter_svg/flutter_svg.dart';

List<String> imagesNames = ['1.png', '2.png', '3.png','instantNudel.png'];
List<String> imageDescriptions = ['Drink', 'Toiletries', 'Snack','Instant Food'];

class snackTab extends StatelessWidget {
  const snackTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 70,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Snacks",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Color(0xFF323232)),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
             Padding(
               padding: const EdgeInsets.all(5.0),
               child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: imagesNames.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 190),
                    itemBuilder: (context, int index) {
                      return SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   // context,
                                  //   // MaterialPageRoute(builder: (context) => homePage()),
                                  // );
                                },
                                child: Container(
                                  height: 150,
                                  width: 170,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[200],
                                  ),
                                    child: Center(
                                      child: Image.asset(
                                        'lib/images/${imagesNames[index]}',
                                        height: 100,
                                        width: 100, // Adjust as needed
                                      ),
                                    ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                imageDescriptions[index],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Inter',
                                    color: Color(0xFF323232)), // Adjust as needed
                              ),
                            ],
                          ),
                      );
                      
                    },
                  ),
             ),
              
            ],
          ),
        ),
         bottomNavigationBar: BottomAppBar(
            child: Container(
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 30, left: 0),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'lib/images/page1/Home(NOTCLICKED).svg',
                            height: 90,
                            width: 90,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => homePage()),
                            );
                          },
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Positioned(
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
                        padding: EdgeInsets.only(bottom: 30, left: 0,top: 10),
                        child: GestureDetector(
                          onTap: () {
                            // Handle your button tap here
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
                      Positioned(
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
                        padding: EdgeInsets.only(bottom: 30, left: 0),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'lib/images/page1/history.svg',
                            height: 90,
                            width: 90,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Positioned(
                        top: 45,
                        left: 3,
                        right: 0,
                        bottom: 0,
                        child: Text("History",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gilroy',
                                color: Color(0xFF323232))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
      ),
      
    );
  }
}
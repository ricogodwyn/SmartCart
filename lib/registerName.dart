import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:michelie2/dataHandler.dart';
import 'package:michelie2/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:michelie2/homePage.dart';
import 'package:flutter/services.dart';

TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
void initState() {
  firstNameController = TextEditingController();
  lastNameController = TextEditingController();
  
}

class registerName extends StatefulWidget {
  const registerName({super.key});

  @override
  State<registerName> createState() => _registerNameState();
}

class _registerNameState extends State<registerName> {
  void initState() {
    super.initState();
    fetchData();
  }
  void fetchData() async{
    uidS=Provider.of<dataHandler>(context, listen: false).uid;

  }
  String uidS ='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 25, top: 55.0, left: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Welcome to Michelie',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy'),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0), // Add this line
              child: TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: "First Name",
                ),
                inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')), // Allow only alphabetic characters
  ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0), // Add this line
              child: TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: "Last Name",
                ),
                inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')), // Allow only alphabetic characters
  ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                String firstName = firstNameController.text;
                String lastName = lastNameController.text;
                String uid =
                    Provider.of<dataHandler>(context, listen: false).uid;
                DocumentReference documentReference =
                    FirebaseFirestore.instance.collection("users").doc(uidS);
                Map<String, dynamic> users = {
                  "firstName": firstName,
                  "lastName": lastName,
                  "uid": uid,
                };
                documentReference.set(users).whenComplete(() {
                  print("$firstName $lastName");
                });
                //navigate to homePage
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => homePage()),
                );
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

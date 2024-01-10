import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:michelie2/registerName.dart';
import 'homePage.dart';
import 'package:michelie2/dataHandler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<User?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut(); // Add this line

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return null; // User cancelled the sign-in
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left:15,top:45.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text('Welcome to Michelie',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy'
                    )),
              ),
            ),
            Image.asset('lib/images/Saly-2.png',
            width: 300,
            height: 300,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:10.0),
              child: Text('Please Login to continue \n using our app', 
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
              ), 
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:48.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 238, 240, 242)),
                  fixedSize: MaterialStateProperty.all<Size>(Size(300, 40)),
                  //add outline color
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.black)
                    )
                  )
                ),
                child: Text('Sign in with Google',
                style: TextStyle(color: Colors.black,
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                                )),
                onPressed: () async {
                  User? user =
                      await signInWithGoogle();
                   //sign in dari google dari firebase auth
                 
                  if (user != null) {
                    //jika ada user
                    //ngecek dari firebase auth bukan firestore
                    //tambahkan or  firstName and lastName = null maka entar masuk ke enter last name and first name
                    //karena jika kita tambahkan user= null maka akan masuk ke home page walaupun firstName dan lastName = null
            
                    String uidS = user.uid;
                     DocumentReference documentReference = FirebaseFirestore.instance
                      .collection("users")
                      .doc(uidS); //when ready change users to user
                    DocumentSnapshot documentSnapshot = await documentReference.get();
                    // Provider.of<dataHandler>(context, listen: false).pullUid(uidS);
                    // // The user successfully signed in. Navigate to your app's main page.
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(builder: (context) => homePage()),
                    // );
                   
                     if (documentSnapshot.exists) {
                    Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
                    if (data != null && data.containsKey('firstName')) { //if field name exist
                        Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => homePage()),
                    );
                      } else { //if field name does not exist
                         
                      }
                    } else {
                      // The document does not exist
                    }
                    if (!documentSnapshot.exists) //if user does not exist
                    {
                      Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => registerName()),
                    );
                      documentReference.set({
                        'value': 0,
                        'uid': '$uidS'
                        // 'firstName': null,
                        // 'lastName': null,
                      });
                    }
                    //add code to check field
                    CollectionReference subcollection =
                        documentReference.collection('itemList');
                    CollectionReference subcollection2 =
                        documentReference.collection('history');
                    QuerySnapshot querySnapshot = await subcollection.get();
                    if (querySnapshot.docs.isEmpty) {
                      subcollection.add({'test': 0});
                    }
                    QuerySnapshot querySnapshot2 = await subcollection2.get();
                    if (querySnapshot2.docs.isEmpty) {
                      subcollection2.add({'test': 0});
                    }
                  } 
                  
                  else {
                    // The user cancelled the sign-in process.
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

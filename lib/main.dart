import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:michelie2/dataHandler.dart';
import 'package:michelie2/firebase_options.dart';
import 'package:michelie2/homepage.dart';
import 'package:michelie2/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( 
    ChangeNotifierProvider(
      create:(context)=> dataHandler(),
      child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: currentUser != null ? homePage() : LoginPage(),
    );
  }
}

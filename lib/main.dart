import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_greenhouse/homepage.dart';
import 'package:my_greenhouse/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(isloged: prefs.getString('UserID') != null));
 
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.isloged});
  final bool isloged;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: const MyHomePage(
      //   title: 'My Green house',
      // ),
      home: (isloged)
          ? const MyHomePage(title: 'My Green house')
          : const signIn(),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_greenhouse/homepage.dart';
import 'package:my_greenhouse/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: const MyHomePage(
      //   title: 'My Green house',
      // ),
      home: signIn(),
    );
  }
}

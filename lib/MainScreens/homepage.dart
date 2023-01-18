import 'package:flutter/material.dart';
import 'package:my_greenhouse/MainScreens/BaseInfo.dart';
import 'package:my_greenhouse/Widgets/SideMenu.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/btnHistoStatistics.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(Icons.menu)),
        bottomOpacity: 0.8,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black38,
      ),
      drawer: const SideMenu(),
      body: Stack(children: [
        Image.asset(
          "assets/image4.jpeg",
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Text(
                        "Green as always",
                        style: GoogleFonts.lato(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: const Color.fromARGB(240, 95, 140, 78),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                      child: Text(
                        "Time spent amongst trees is never wasted time.",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color.fromARGB(240, 164, 190, 123),
                        ),
                      ),
                    ),
                    const BaseInfo(),
                    const SizedBox(
                      height: 60,
                    ),
                    const BtnHistoStatistics()
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

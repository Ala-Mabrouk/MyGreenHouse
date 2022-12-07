import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_greenhouse/InfoBulle.dart';
import 'package:my_greenhouse/Services/MqttDataHouseManager.dart';
import 'package:my_greenhouse/SideMenu.dart';
import 'package:my_greenhouse/loading.dart';

import 'Constants.dart';

class HouseControl extends StatefulWidget {
  const HouseControl({super.key});

  @override
  State<HouseControl> createState() => _HouseControlState();
}

class _HouseControlState extends State<HouseControl> {
  bool light = true;
  bool water = true;
  MqttDataHouseManager mqttClientManager = MqttDataHouseManager();
  String publishTopic = "ISIariana/2ING2/my_GreenHouse/Controllers";
  Future<void> setupMqttClient() async {
    await mqttClientManager.connect();
  }

  @override
  void initState() {
    setupMqttClient();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void displayInfo(String msg) {
      final snackBar = SnackBar(
        content: Text('$msg'),
        backgroundColor: Color.fromARGB(240, 185, 205, 152),
        behavior: SnackBarBehavior.floating,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu)),
        bottomOpacity: 0.8,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black38,
      ),
      drawer: SideMenu(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Current Info",
                  style: GoogleFonts.lato(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(240, 95, 140, 78),
                  ),
                ),
              )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    InfoBulle(
                      myIcon: Icons.thermostat,
                      textInfo: '25' + '°C',
                    ),
                    InfoBulle(
                      myIcon: Icons.water_drop_outlined,
                      textInfo: '25' + '%',
                    ),
                    InfoBulle(
                      myIcon: Icons.light_outlined,
                      textInfo: 'Active',
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 60,
                indent: 25,
                endIndent: 25,
                thickness: 1,
                color: Color.fromARGB(240, 164, 190, 123),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(240, 242, 242, 242),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: Offset(0, 10),
                              blurRadius: 7,
                              spreadRadius: -5)
                        ],
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.1),
                            width: 1.0,
                            style: BorderStyle.solid),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Turn on vans for water ",
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Switch(
                                  // This bool value toggles the switch.
                                  value: water,
                                  activeColor:
                                      const Color.fromARGB(240, 229, 217, 182),
                                  onChanged: (bool value) {
                                    setState(() {
                                      water = value;
                                      mqttClientManager.publishMessage(
                                          publishTopic, "$water|$light");
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.grey[400],
                                  ),
                                  onPressed: () {
                                    displayInfo("message");
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(240, 242, 242, 242),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: Offset(0, 10),
                              blurRadius: 7,
                              spreadRadius: -5)
                        ],
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.1),
                            width: 1.0,
                            style: BorderStyle.solid),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Turn on the light ",
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Switch(
                                  // This bool value toggles the switch.
                                  value: light,
                                  activeColor:
                                      const Color.fromARGB(240, 229, 217, 182),
                                  onChanged: (bool value) {
                                    setState(() {
                                      light = value;
                                      mqttClientManager.publishMessage(
                                          publishTopic, "$water|$light");
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.grey[400],
                                  ),
                                  onPressed: () {
                                    displayInfo("message");
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(240, 242, 242, 242),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: Offset(0, 10),
                              blurRadius: 7,
                              spreadRadius: -5)
                        ],
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.1),
                            width: 1.0,
                            style: BorderStyle.solid),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Call responsable ",
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.call_sharp,
                                    size: 35,
                                    color: Color.fromARGB(240, 95, 140, 78),
                                  ),
                                  onPressed: () {
                                    displayInfo("message");
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.grey[400],
                                  ),
                                  onPressed: () {
                                    displayInfo("message");
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

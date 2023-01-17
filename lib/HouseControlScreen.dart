import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:my_greenhouse/InfoBulle.dart';
import 'package:my_greenhouse/Services/MqttDataHouseManager.dart';
import 'package:my_greenhouse/SideMenu.dart';

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
  String listenTopic = "ISIariana/2ING2/my_GreenHouse/sensors";
  Future<void> setupMqttClient() async {
    await mqttClientManager.connect();
    mqttClientManager.subscribe(listenTopic);
  }

  @override
  void initState() {
    setupMqttClient();
    // TODO: implement initState
    super.initState();
  }

  void displayInfo(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: const Color.fromARGB(240, 185, 205, 152),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<Map> getInfoFromMqtt() async {
    var res = await mqttClientManager.getMessagesStream()?.first.then((value) {
      final recMess = value[0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      return pt;
    });
    return mqttClientManager.getsimpleInfo(res as String);
  }

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
                  "Current informations",
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
                // child: FutureBuilder(
                //     future: getInfoFromMqtt(),
                //     builder: (context, snapshot) {
                //       if (snapshot.hasData) {
                //         Map infoGreenHouse = snapshot.data as Map;
                //         return Row(
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             InfoBulle(
                //               myIcon: Icons.thermostat,
                //               textInfo: infoGreenHouse['temp'] + "°C",
                //             ),
                //             InfoBulle(
                //               myIcon: Icons.water_drop_outlined,
                //               textInfo: infoGreenHouse['hum'] + " %",
                //             ),
                //             InfoBulle(
                //               myIcon: Icons.light_outlined,
                //               textInfo:
                //                   (infoGreenHouse['light'].contains("true"))
                //                       ? " Active"
                //                       : " Close",
                //             ),
                //           ],
                //         );
                //       }
                //       return const Center(
                //         child: SpinKitRipple(
                //           color: Colors.green,
                //           size: 250.0,
                //           duration: Duration(milliseconds: 1500),
                //         ),
                //       );
                //     }),
                child: StreamBuilder(
                    stream: mqttClientManager.getMessagesStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var c = snapshot.data
                            as List<MqttReceivedMessage<MqttMessage?>>;
                        final recMess = c[0].payload as MqttPublishMessage;
                        final pt = MqttPublishPayload.bytesToStringAsString(
                            recMess.payload.message);
                        Map info = mqttClientManager.getsimpleInfo(pt);
                        print(info);
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InfoBulle(
                              myIcon: Icons.thermostat,
                              textInfo: info['temp'] + "°C",
                            ),
                            InfoBulle(
                              myIcon: Icons.water_drop_outlined,
                              textInfo: info['hum'] + " %",
                            ),
                            InfoBulle(
                              myIcon: Icons.light_outlined,
                              textInfo: (info['light'].contains("true"))
                                  ? " Active"
                                  : " Close",
                            ),
                          ],
                        );
                      }

                      return Container();
                    }),
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
                        color: const Color.fromARGB(240, 242, 242, 242),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: const Offset(0, 10),
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
                              "Open / Close water pipe ",
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
                                    displayInfo(
                                        "Open or Close the water pipe in the green house");
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
                        color: const Color.fromARGB(240, 242, 242, 242),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: const Offset(0, 10),
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
                              "Turn on the UV-light ",
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
                                    displayInfo(
                                        "Open or close the Ultra Violet light in the green house");
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
                        color: const Color.fromARGB(240, 242, 242, 242),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: const Offset(0, 10),
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
                              "Call responsible ",
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
                                    FlutterPhoneDirectCaller.callNumber(
                                        "+21622845764");
                                    displayInfo(
                                        "making a call to +216 ** *** ***");
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.grey[400],
                                  ),
                                  onPressed: () {
                                    displayInfo(
                                        "Make a call to the responsible / Gard of the green house");
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

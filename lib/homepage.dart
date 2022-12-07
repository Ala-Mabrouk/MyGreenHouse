import 'package:flutter/material.dart';
import 'package:my_greenhouse/BaseInfo.dart';
import 'package:my_greenhouse/Services/MqttDataHouseManager.dart';
import 'package:my_greenhouse/SideMenu.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MqttDataHouseManager mqttClientManager = MqttDataHouseManager();
  final String pubTopic = "ISIariana/2ING2/my_GreenHouse/sensors";

  @override
  void initState() {
    print("connecting to hive broker ");
    setupMqttClient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      drawer: const SideMenu(),
      body: Container(
          child: Stack(children: [
        Image.asset(
          "assets/image4.jpeg",
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                          child: Expanded(
                            child: Text(
                              "Time spent amongst trees is never wasted time.",
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: const Color.fromARGB(240, 164, 190, 123),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    BaseInfo(mqttClientManager: mqttClientManager),
                  ],
                ),
              ),
            ],
          ),
        ),
      ])),
    );
  }

  Future<void> setupMqttClient() async {
    await mqttClientManager.connect();
    mqttClientManager.subscribe(pubTopic);
  }

  /*  void setupUpdatesListener() {
    mqttClientManager
        .getMessagesStream()!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      setState(() {
          = pt;
      });
      print('MQTTClient::Message received on topic: <${c[0].topic}> is $pt\n');
    });
  } */

  @override
  void dispose() {
    mqttClientManager.disconnect();
    super.dispose();
  }
}
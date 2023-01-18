import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:my_greenhouse/Services/GreenHouseMG.dart';
import 'package:my_greenhouse/Services/MqttDataHouseManager.dart';
import 'package:my_greenhouse/Services/newNotiffication.dart';
import 'package:my_greenhouse/Widgets/Constants.dart';

import '../Widgets/loading.dart';

class BaseInfo extends StatefulWidget {
  const BaseInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<BaseInfo> createState() => _BaseInfoState();
}

class _BaseInfoState extends State<BaseInfo> {
  MqttDataHouseManager mqttClientManager = MqttDataHouseManager();
  final String pubTopic = "ISIariana/2ING2/my_GreenHouse/sensors";
  Future<void> setupMqttClient() async {
    await mqttClientManager.connect();
    mqttClientManager.subscribe(pubTopic);
  }

  @override
  void dispose() {
    mqttClientManager.disconnect();
    super.dispose();
  }

  @override
  void initState() {
    print("connecting to hive broker ");
    setupMqttClient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map prevInfo = {"temp": 0, "hum": -1};
    return StreamBuilder(
      stream: mqttClientManager.getMessagesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Loading());
        } else {
          if (snapshot.hasData) {
            var c = snapshot.data as List<MqttReceivedMessage<MqttMessage?>>;
            final recMess = c[0].payload as MqttPublishMessage;
            final pt = MqttPublishPayload.bytesToStringAsString(
                recMess.payload.message);
            Map info = mqttClientManager.getsimpleInfo(pt);
            if (info["temp"] != prevInfo["temp"] ||
                info["hum"] != prevInfo["hum"]) {
              prevInfo = info;
              String now = DateTime.now().toString().substring(0, 16);
              //send data to firebase
              GreenHouseMG().addNewInfo({now: info});
            }
            if (double.parse(info["temp"].toString()) > 24 ||
                double.parse(info["temp"].toString()) < 18) {
              //send notification
              Notif().getNotification("temperature problem",
                  "critical condition in the green house\n Temperateur is ${info['temp']}");
            }
            if (double.parse(info["hum"].toString()) > 81 ||
                double.parse(info["hum"].toString()) < 79) {
              //send notification

              Notif().getNotification("humudity problem",
                  "critical condition in the green house\n humudity is ${info['hum']}");
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.thermostat,
                      size: 60,
                      color: Kgray,
                    ),
                    Text(
                      info['temp'] + "°C",
                      style: GoogleFonts.lato(
                          fontSize: 65,
                          fontWeight: FontWeight.w300,
                          color: Kgray),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Icon(Icons.water_drop_outlined,
                        size: 60, color: Kgray),
                    Text(
                      info['hum'] + " %",
                      style: GoogleFonts.lato(
                        fontSize: 65,
                        fontWeight: FontWeight.w300,
                        color: Kgray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.light_rounded,
                      size: 60,
                      color: Kgray,
                    ),
                    Text(
                      (info['light'].contains("true")) ? " Active" : " Close",
                      style: GoogleFonts.lato(
                        fontSize: 60,
                        fontWeight: FontWeight.w300,
                        color: Kgray,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        }
        return Container();
      },
    );
  }
}

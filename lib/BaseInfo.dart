import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:my_greenhouse/Constants.dart';
import 'package:my_greenhouse/Services/MqttDataHouseManager.dart';

class BaseInfo extends StatelessWidget {
  const BaseInfo({
    Key? key,
    required this.mqttClientManager,
  }) : super(key: key);

  final MqttDataHouseManager mqttClientManager;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: mqttClientManager.getMessagesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitRipple(
              color: Colors.green,
              size: 250.0,
              duration: Duration(milliseconds: 1500),
            ),
          );
        }
        if (snapshot.hasData) {
          var c = snapshot.data as List<MqttReceivedMessage<MqttMessage?>>;
          final recMess = c[0].payload as MqttPublishMessage;
          final pt =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          String temp = pt.substring(pt.lastIndexOf("t") + 4, pt.indexOf(","));
          String hum = pt.substring(pt.indexOf("h") + 4, pt.lastIndexOf("}"));
          String light =
              pt.substring(pt.lastIndexOf("l") + 4, pt.lastIndexOf("l") + 5);
          print(light);
          print(pt);
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
                    " " + temp + " °C",
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
                  const Icon(Icons.water_drop_outlined, size: 60, color: Kgray),
                  Text(
                    " " + hum + " %",
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
                    (light == "1") ? " Active" : " Close",
                    style: GoogleFonts.lato(
                      fontSize: 60,
                      fontWeight: FontWeight.w300,
                      color: Kgray,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 50, 15, 20),
                child: Container(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(240, 229, 217, 182),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.stacked_bar_chart_outlined,
                          size: 28,
                        ),
                        Text(
                          "Voir historiques ",
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_outlined,
                          size: 28,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        }

        return Text("");
      },
    );
  }
}
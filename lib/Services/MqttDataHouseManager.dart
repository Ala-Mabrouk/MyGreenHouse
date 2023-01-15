import 'dart:io';
import 'dart:math';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttDataHouseManager {
  var pongCount = 0; // Pong counter
  var rng = Random();
  MqttServerClient client = MqttServerClient('broker.hivemq.com', '');

  Future<int> connect() async {
    int id = rng.nextInt(1000);
    client.logging(on: true);
    client.keepAlivePeriod = 5;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier("clientIdentifier_$id")
        .withWillTopic('willtopic')
        .withWillMessage('willMessage')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      print('MQTTClient::Client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      print('MQTTClient::Socket exception - $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }

    return 0;
  }

  /// Pong callback
  void pong() {
    print('EXAMPLE::Ping response client callback invoked');
    pongCount++;
  }

  void disconnect() {
    try {
      client.disconnect();
    } catch (e) {
      print(e.toString());
    }
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void onConnected() {
    print('MQTTClient::Connected');
  }

  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    } else {
      print(
          'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
      exit(-1);
    }
    if (pongCount == 3) {
      print('EXAMPLE:: Pong count is correct');
    } else {
      print('EXAMPLE:: Pong count is incorrect, expected 3. actual $pongCount');
    }
  }

  void onSubscribed(String topic) {
    print('MQTTClient::Subscribed to topic: $topic');
  }

  void publishMessage(String topic, String message) {
    //tpoic: ISIariana/2ING2/my_GreenHouse/Controllers
    //message:1|0
    print("sending message to $topic");
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    print("******       request send with sucssess !!");
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return client.updates;
  }

  // manipulate res mqtt to known data
  Map<String,String> getsimpleInfo(String infoFromMqtt) {
   Map<String,String> res =   <String,String>{};
    List<String> myres = infoFromMqtt.split(",");
    res["water"] = myres[0].substring(myres[0].indexOf(":") + 2).trim();
    res["temp"] = myres[1].substring(myres[1].indexOf(":") + 2).trim();
    res["hum"] = myres[2].substring(myres[2].indexOf(":") + 2).trim();
    res["light"] = myres[3]
        .substring(myres[1].indexOf(":") + 1, myres[3].lastIndexOf("}")).trim();
    
    print("*********\n");
    print(res);
    print("*********\n");

    return res;
  }
}

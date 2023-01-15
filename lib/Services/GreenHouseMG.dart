import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_greenhouse/Models/Humidity.dart';
import 'package:my_greenhouse/statScreen.dart';

import '../Models/Temperature.dart';

class GreenHouseMG {
  final GreenHouseInfos = FirebaseFirestore.instance
      .collection("GreenHouses")
      .doc("fJmcrDKDazMOMYIVh0Z0");

  Future<List<Temperateur>> gethistoriqueTemp() async {
    List<Temperateur> data = [];
    await GreenHouseInfos.get().then((value) {
      final a = value.data() as Map<String, dynamic>;
      var res = a["histoInfo"] as Map<String, dynamic>;
      res.map((key, value) {
        var parsedDate = DateTime.parse(key);
        if (parsedDate.day == DateTime.now().day) {
          data.add(Temperateur(
              "${parsedDate.hour}:${parsedDate.minute}:${parsedDate.second}",
              double.parse(value["temp"].toString())));
        }
        return MapEntry(key, value);
      });
    }).whenComplete(() => data);
    print(data);
    return data;
  }
  Future<List<Humidity>> gethistoriqueHum() async {
    List<Humidity> data = [];
    await GreenHouseInfos.get().then((value) {
      final a = value.data() as Map<String, dynamic>;
      var res = a["histoInfo"] as Map<String, dynamic>;
      res.map((key, value) {
        print("$key $value");
        var parsedDate = DateTime.parse(key);
        if (parsedDate.day == DateTime.now().day) {
          data.add(Humidity(
              "${parsedDate.hour}:${parsedDate.minute}:${parsedDate.second}",
              double.parse(value["hum"].toString())));
        }
        return MapEntry(key, value);
      });
    }).whenComplete(() => data);
        print(data);

    return data;
  }

  addNewInfo(Map info) {
    GreenHouseInfos.set({"histoInfo": info}, SetOptions(merge: true))
        .onError((e, _) => print("Error writing document: $e"));
  }
}

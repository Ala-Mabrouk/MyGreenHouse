import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_greenhouse/Constants.dart';
import 'package:my_greenhouse/Services/GreenHouseMG.dart';

import 'Models/Humidity.dart';
import 'Models/Temperature.dart';
import 'SideMenu.dart';

class StatScreen extends StatelessWidget {
  const StatScreen({super.key});

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
        title: const Text("Today Statistics ",style: TextStyle(fontSize: 25),),
      ),
      drawer: const SideMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                height: 400,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          "Temperature evolution C° ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: KLightGreen,fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                            future: GreenHouseMG().gethistoriqueTemp(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                final data = snapshot.data as List<Temperateur>;
                                List<charts.Series<Temperateur, String>>
                                    series = [
                                  charts.Series(
                                      id: " ",
                                      data: data,
                                      domainFn: (Temperateur series, _) =>
                                          series.date.toString(),
                                      measureFn: (Temperateur series, _) =>
                                          series.temp,
                                      colorFn: (Temperateur series, _) =>
                                          const charts.Color(
                                              r: 234, g: 231, b: 177))
                                ];
                                return Expanded(
                                  child: charts.BarChart(
                                    series,
                                    animate: true,
                                    domainAxis: const charts.OrdinalAxisSpec(
                                        renderSpec:
                                            charts.SmallTickRendererSpec(
                                                labelRotation: 60)),
                                  ),
                                );
                              }
                              return Container();
                            }),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                height: 400,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          "Humidity evolution %  ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: KLightGreen,fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                            future: GreenHouseMG().gethistoriqueHum(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                final data = snapshot.data as List<Humidity>;
                                List<charts.Series<Humidity, String>> series = [
                                  charts.Series(
                                      id: " ",
                                      data: data,
                                      domainFn: (Humidity series, _) =>
                                          series.date.toString(),
                                      measureFn: (Humidity series, _) =>
                                          series.hum,
                                      colorFn: (Humidity series, _) =>
                                          const charts.Color(
                                              r: 234, g: 231, b: 177))
                                ];
                                return Expanded(
                                  child: charts.BarChart(
                                    series,
                                    animate: true,
                                    domainAxis: const charts.OrdinalAxisSpec(
                                        renderSpec:
                                            charts.SmallTickRendererSpec(
                                                labelRotation: 60)),
                                  ),
                                );
                              }
                              return Container();
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

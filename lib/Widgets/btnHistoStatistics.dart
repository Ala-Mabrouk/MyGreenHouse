import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_greenhouse/MainScreens/statScreen.dart';
 
class BtnHistoStatistics extends StatelessWidget {
  const BtnHistoStatistics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
      child: Container(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const StatisticsScreen()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(240, 229, 217, 182),
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
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
                "View history and stat ",
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
    );
  }
}

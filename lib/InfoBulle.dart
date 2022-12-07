import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_greenhouse/Constants.dart';

class InfoBulle extends StatelessWidget {
  const InfoBulle({
    Key? key,
    required this.myIcon,
    required this.textInfo,
  }) : super(key: key);
  final IconData? myIcon;
  final String textInfo;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
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
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              myIcon,
              size: 40,
              color: Kgray,
            ),
            Text(
              textInfo,
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

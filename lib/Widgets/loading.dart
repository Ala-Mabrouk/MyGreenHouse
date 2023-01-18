import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitRipple(
        color: Colors.green,
        size: 250.0,
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
}

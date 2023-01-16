import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class testWidget extends StatelessWidget {
  const testWidget({super.key});

  @override
  Widget build(BuildContext context) {
        Size size = MediaQuery.of(context).size;

    return Container(
              color:Color.fromRGBO(237, 238, 234, 1) ,
              height: size.height,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/newBg.png'),
                  SizedBox(height: 20,),
                  Image.asset('assets/theloading.gif',height: size.height*0.035,),
                 ],
              )
              );
  }
}
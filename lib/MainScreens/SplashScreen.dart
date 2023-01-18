import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:my_greenhouse/MainScreens/homepage.dart';
import 'package:my_greenhouse/MainScreens/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key, this.logedIn}) : super(key: key);
  final logedIn;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: AnimatedSplashScreen(
            centered: true,
            splashIconSize: size.height,
            duration: 1500,
            splash: Container(
                color: const Color.fromRGBO(237, 238, 234, 1),
                height: size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/newBg.png'),
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      'assets/theloading.gif',
                      height: size.height * 0.03,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Devoloped By A.D.M.S"),
                  ],
                )),
            nextScreen: (logedIn)
                ? const MyHomePage(title: 'My Green house')
                : const SignIn(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: const Color.fromRGBO(237, 238, 234, 1)),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_greenhouse/Constants.dart';
import 'package:my_greenhouse/Models/User.dart';
import 'package:my_greenhouse/Services/AuthService.dart';

import 'homepage.dart';

class signIn extends StatefulWidget {
  const signIn({Key? key}) : super(key: key);

  @override
  _signInState createState() => _signInState();
}

class _signInState extends State<signIn> {
  final AuthService _authService = AuthService();

  UserApp user = UserApp();
  bool showPassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  toastMsg(String msg, BuildContext theContext) {
    ScaffoldMessenger.of(theContext).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      elevation: 15,
      backgroundColor: Colors.redAccent,
    ));
  }

  RegExp exp = RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$');
  submitLog(UserApp us, BuildContext theContext) async {
    if (_formKey.currentState!.validate() == true) {
      // _formKey.currentState!.save();
      try {
        /*        _authService
            .signInEmailPassword(us.userMail, us.userPass)
            .
            .whenComplete(() => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false)); */

        if (await _authService.signInEmailPassword(us.userMail, us.userPass) !=
            null) {
          /*        Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false); */

          Navigator.pushNamed(context, '/Home');

          // Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          toastMsg("e-mail adresse introuvable !", theContext);
        } else if (e.code == 'wrong-password') {
          toastMsg("Mot de passe incorrect !", theContext);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      //  type: MaterialType.canvas,
      body: Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/1.png',
                width: size.width * 0.2,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset('assets/2.png', width: size.width * 0.3),
            ),
            Positioned(
              bottom: 0,
              left: 30,
              child: Image.asset(
                'assets/3.png',
                width: size.width * 0.4,
              ),
            ),
            SingleChildScrollView(
              child: Material(
                type: MaterialType.transparency,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/logo.png",
                        width: size.width * 0.5,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Bienvenue !",
                        style: TextStyle(
                            fontSize: 20,
                            color: KBlackColor,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Se connecter pour continuer",
                        style: TextStyle(
                          fontSize: 20,
                          color: KBlackColor,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            //email field
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: KBlackColor.withOpacity(0.1)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: KBlackColor.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 6,
                                        offset: const Offset(1, 6))
                                  ],
                                  color: KWihteColor,
                                  borderRadius: BorderRadius.circular(29)),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == '') {
                                    return "Adesse e-mail est vide !";
                                  } else if (!exp.hasMatch(value!)) {
                                    return "Adesse e-mail incorrect !";
                                  }
                                },
                                decoration: const InputDecoration(
                                    hintText: "Adresse e-mail",
                                    icon: Icon(
                                      Icons.mail_outline,
                                      color: KBlackColor,
                                    ),
                                    border: InputBorder.none),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (newValue) {
                                  user.userMail = newValue.toString();
                                },
                              ),
                            ),
                            //space between
                            const SizedBox(
                              height: 30,
                            ),
                            //password field
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: KBlackColor.withOpacity(0.1)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: KBlackColor.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 6,
                                        offset: const Offset(1, 6))
                                  ],
                                  color: KWihteColor,
                                  borderRadius: BorderRadius.circular(29)),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == '') {
                                    return "Mot de passe est vide !";
                                  } else if (value!.length < 6) {
                                    return "Mot de passe doit étre de 6 caracteres !";
                                  }
                                },
                                obscureText: showPassword,
                                decoration: InputDecoration(
                                    hintText: "Mot de passe ",
                                    icon: const Icon(
                                      Icons.lock,
                                      color: KBlackColor,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        (showPassword)
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: KBlackColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          showPassword = !showPassword;
                                        });
                                      },
                                    ),
                                    border: InputBorder.none),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (newValue) {
                                  user.userPass = newValue.toString();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                          fontSize: 20,
                          backgroundColor: KPrimaryColor,
                          color: KWihteColor,
                        )),
                        child: Text('LOGIN'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const MyHomePage(
                                  title: 'My green house',
                                ),
                              ));
                          // if (true) {
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //     content: const Text(
                          //       'No Internet Connection!!!',
                          //     ),
                          //     backgroundColor: Colors.red,
                          //     behavior: SnackBarBehavior.floating,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(24),
                          //     ),
                          //     action: SnackBarAction(
                          //       label: 'options',
                          //       onPressed: () {
                          //         print("snack is taped ");
                          //         //  AppSettings.openWIFISettings();
                          //       },
                          //       textColor: Colors.white,
                          //       disabledTextColor: Colors.grey,
                          //     ),
                          //   ));
                          // } else {
                          //   submitLog(user, context);
                          // }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

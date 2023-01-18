import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_greenhouse/Widgets/Constants.dart';
import 'package:my_greenhouse/MainScreens/homepage.dart';
import 'package:my_greenhouse/Models/User.dart';
import 'package:my_greenhouse/Services/AuthService.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();

  UserApp user = UserApp();
  bool showPassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RegExp exp = RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    toastMsg(String msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        elevation: 15,
        backgroundColor: Colors.redAccent,
      ));
    }

    submitLog(UserApp us) async {
      if (_formKey.currentState!.validate() == true) {
        _formKey.currentState!.save();
        try {
          if (await _authService.signInEmailPassword(
                  us.userMail, us.userPass) !=
              null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(
                          title: "my green house",
                        )),
                (route) => false);
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            toastMsg("e-mail adresse introuvable !");
          } else if (e.code == 'wrong-password') {
            toastMsg("Mot de passe incorrect !");
          }
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: Colors.white,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/3.png',
                  width: size.width * 0.2,
                ),
              ),
              SingleChildScrollView(
                child: Material(
                  type: MaterialType.transparency,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "My Green house",
                          style: GoogleFonts.lato(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: const Color.fromARGB(240, 95, 140, 78),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Welcome !",
                          style: TextStyle(
                              fontSize: 20,
                              color: KBlackColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Connect to continue ",
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
                                    border: Border.all(color: KGreenColor),
                                    color: KWihteColor,
                                    borderRadius: BorderRadius.circular(10)),
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
                                    border: Border.all(color: KGreenColor),
                                    color: KWihteColor,
                                    borderRadius: BorderRadius.circular(10)),
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
                              backgroundColor: const Color.fromRGBO(164, 190, 123, 1),
                              textStyle: const TextStyle(
                                fontSize: 20,
                                color: KWihteColor,
                              )),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'LOGIN',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            submitLog(user);

                            //in advanced level will be used
                            //----------
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
      ),
    );
  }
}

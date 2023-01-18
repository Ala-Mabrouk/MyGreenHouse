import 'package:flutter/material.dart';
import 'package:my_greenhouse/MainScreens/HouseControlScreen.dart';
import 'package:my_greenhouse/MainScreens/homepage.dart';
import 'package:my_greenhouse/MainScreens/login.dart';
import 'package:my_greenhouse/MainScreens/statScreen.dart';
import 'package:my_greenhouse/Models/User.dart';
import 'package:my_greenhouse/Services/AuthService.dart';
import 'package:my_greenhouse/Services/userServices.dart';
import 'package:my_greenhouse/Widgets/Constants.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future logOut() {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Disconnexion')),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('You are going to disconnect your session ?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('Dismiss'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                child: const Text('Disconnect'),
                onPressed: () {
                  AuthService().logout().whenComplete(() =>
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignIn()),
                          (route) => false));
                },
              )
            ],
          );
        },
      );
    }

    Future shareApp() {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: const Center(
                child: Text(
              'Rate and Share ',
              style: TextStyle(
                  color: KLightGreen,
                  fontStyle: FontStyle.italic,
                  fontSize: 35),
            )),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < 4 ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 45,
                        );
                      })),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Tell your freinds, family and neighbours.\n Hell share it with whole world',
                    style: TextStyle(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          color: const Color.fromARGB(255, 10, 233, 2),
                          iconSize: 50,
                          onPressed: () => print("share what's up"),
                          icon: const Icon(Icons.whatsapp)),
                      IconButton(
                          color: const Color.fromRGBO(56, 83, 149, 1),
                          iconSize: 50,
                          onPressed: () => print("share facebook"),
                          icon: const Icon(Icons.facebook)),
                      IconButton(
                          color: const Color.fromRGBO(3, 169, 244, 0.9),
                          iconSize: 50,
                          onPressed: () => print("share what's up"),
                          icon: const Icon(Icons.message_outlined)),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Close",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
            ],
          );
        },
      );
    }

    UserApp myUserApp = UserServices().getUserInfo();
    return SafeArea(
      child: Drawer(
        child: ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName:
                  Text('${myUserApp.userName} ${myUserApp.userLastName}'),
              accountEmail: Text(myUserApp.userMail),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    myUserApp.userAvatar,
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: KLightGreen,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(myUserApp.userCoverImg)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const MyHomePage(
                      title: 'My green house',
                    ),
                  ),
                  (route) => false,
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Green House Controle'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HouseControl()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.stacked_bar_chart_sharp),
              title: const Text('Statistics'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StatisticsScreen()));
              },
            ),
            const Divider(),

            /*     const ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Request'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Account'),
              onTap: () => null,
            ), */
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () => shareApp(),
            ),
            ListTile(
              title: const Text('Log out'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () => logOut(),
            ),
          ],
        ),
      ),
    );
  }
}

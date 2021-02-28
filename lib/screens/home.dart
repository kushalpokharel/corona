//import 'package:app_settings/app_settings.dart';
import 'package:covid/helpers/screen_navigation.dart';
import 'package:covid/helpers/style.dart';
import 'package:covid/providers/bluetooth.dart';
import 'package:covid/screens/myapp.dart';
import 'package:covid/screens/info.dart';
//import 'package:covid/screens/test.dart';
import 'package:covid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';


//import 'enter_blue_address.dart';

class Home extends StatefulWidget {
  int status;
  Home(this.status);
  @override
  _HomeState createState() => _HomeState(status);
}

class _HomeState extends State<Home> {
  int status;
  _HomeState(this.status);
  @override

  Widget _launchStatsPage() {
    return InkWell(
      onTap: () {
        Alert(
          context: context,
          title: "Open URL",
          desc: "The app is trying to launch https://covid19.mohp.gov.np/",
          buttons: [
            DialogButton(
              child: Text(
                "CANCEL",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              onPressed: () => Navigator.pop(context),
              color: Colors.red,
            ),
            DialogButton(
              child: Text(
                "ALLOW",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              onPressed: () => _launchURL("https://covid19.mohp.gov.np/"),
              color: Colors.green,
            )
          ],
        ).show();
      },
      child: Ink(
        height: 75,
        color: Colors.grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(
                "View Covid Statistics",
                style: Theme.of(context).textTheme.headline4.copyWith(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              trailing: Icon(
                FontAwesomeIcons.database,
                color: Colors.white,
                size: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                'MOHP',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    final blue = Provider.of<BlueToothProvider>(context);
    var count = blue.count;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          title: CustomText(text: "Corona Out"),
          centerTitle: true,
          elevation: 0.5,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.person_outline,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Info(status)),
                );
                print("settings");
              },
            ),
          ],
        ),
        backgroundColor: white,
        body: blue.isOn
            ?
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "images/plp.png",
                  width: 100,
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(
                text: "People Near You!",
                size: 24,
                weight: FontWeight.w300,
                color: primary,
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(
                text: blue.data,
                size: 18,
                weight: FontWeight.w300,
                color: grey,
              ),
            ),
            SizedBox(height: 5),
            IconButton(
                icon: Icon(Icons.add_location),
                onPressed: () {
                  changeScreen(context, Blue());
                }),

            Expanded(child: const SizedBox()),_launchStatsPage(),

            Expanded(
              //expands in remaining space in vertical direction
              child: Row(
                children: <Widget>[
                  Expanded(
                    //expands in row axis, i.e. horizontally
                    child: Container(
                      color: Colors.white54,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              count.toString(),
                              // globals.user.getCountOfDevices().toString(),
                              style: Theme.of(context).textTheme.headline4.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            trailing: Icon(
                              FontAwesomeIcons.exclamationTriangle,
                              color: Colors.black38,
                              size: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'No. of devices \nToday',
                              style: TextStyle(color: Colors.black38),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),

          ]),

        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "images/off.png",
                  width: 160,
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Your Bluetooth is turned off, please turn on the bluetooth and click on 'refresh'",
                textAlign: TextAlign.center,
                style: TextStyle(color: grey),
              ),
            ),
            FlatButton.icon(
                onPressed: () {
                  blue.turnOn();
                },
                icon: Icon(Icons.refresh),
                label: CustomText(text: "refresh")),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
import 'package:covid/helpers/style.dart';
import 'package:covid/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  int status = 1;
  // TODO: Status should be recieved from the database, 0 at default, changes when the user selects- Are you infected?

  List<String> statusDescription = [
    "Based on your ID, you have not \n been near someone who has tested positive.",
    "Based on your ID, you have \n been near someone who has tested positive.Consult health authorities.",
    "You are infected \n Please take care of your health and isolate yourself.",
  ];

  // int done = 0;
  List<Icon> statusIcons = [
    Icon(
      FontAwesomeIcons.userShield,
      size: 40,
      color: Colors.green,
    ), //not been in contact
    Icon(
      FontAwesomeIcons.exclamation,
      size: 40,
      color: Colors.red,
    ), //been in contact
    Icon(
      FontAwesomeIcons.hospitalUser,
      size: 40,
      color: Colors.green,
    ) //infected
  ];

  List<String> statusText = [
    "No Exposure Detected",
    "Exposure Detected",
    "Infected",
  ];

  List<String> questionText = [
    "Are you infected?",
    "Are you infected?",
    "Have you recovered?",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: white,
          title: CustomText(text: "Corona Out"),
          centerTitle: true,
          elevation: 0.5,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: const SizedBox(),
                ),
                _buildHeader(),
                Expanded(
                  child: const SizedBox(),
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).buttonColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(questionText[status]),
                  ),
                  onTap: () {
                    Alert(
                      context: context,
                      title: "Are you sure?",
                      desc: status < 2 ? questionText[1] : questionText[2],
                      buttons: [
                        DialogButton(
                          child: Text(
                            "NO",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.red,
                        ),
                        DialogButton(
                          child: Text(
                            "YES",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          onPressed: () {
                            setState(() {
                              if (status != 2)
                                status = 2;
                              else
                                status = 0;
                            });
                            Navigator.pop(context);
                          },
                          color: Colors.green,
                        )
                      ],
                    ).show();
                  },
                ),
                Expanded(
                  child: const SizedBox(),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildHeader() {
    // setState(() {
    //   status = currentUser.status; //to perform state change
    // });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        statusIcons[status],
        SizedBox(height: 50),
        Text(
          statusText[status],
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          statusDescription[status],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black38,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}

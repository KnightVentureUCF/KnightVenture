import 'package:flutter/material.dart';
import 'package:frontend/utils/pathbuilder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For converting JSON response to a map
import 'package:frontend/widgets/styling/theme.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  static const nameList = [
    "bob",
    "henry",
    "todd",
    "paul",
    "reggie",
    "hermoine",
    "matie",
    "ryan",
    "todd",
    "nancy",
  ];
  static const points = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  static const userPoints = 10;
  static const normalFontSize = 14.0;
  static const largeFontSize = 16.0;
  static const mediumFontWeight = FontWeight.w500;

  Widget createLeaderboardEntry(int place, String name, int points) {
    return Column(
      children: [
        Container(
          color: Color(0xFFDFD7B9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    place.toString(),
                    style: const TextStyle(
                      fontSize: normalFontSize,
                      fontWeight: mediumFontWeight,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 54,
                    child: Image.asset(
                      "assets/logo.png",
                      width: 37.84,
                      height: 50.29,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: normalFontSize,
                      fontWeight: mediumFontWeight,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    points.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: largeFontSize,
                      fontWeight: mediumFontWeight,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 11),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brightGold,
      appBar: AppBar(
        backgroundColor: brightGold,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Image.asset(
                "assets/logo.png",
                width: 92,
                height: 62,
              ),
              const Text(
                "Leaderboard",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 49),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 75,
                        height: 75,
                      ),
                      Text(
                        "1st",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: normalFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        nameList.length >= 1 ? nameList[0] : "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: normalFontSize,
                          fontWeight: mediumFontWeight,
                        ),
                      ),
                      Text(
                        points.length >= 1 ? points[0].toString() : "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: largeFontSize,
                          color: Colors.purple,
                          fontWeight: mediumFontWeight,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 110,
                        height: 110,
                      ),
                      Text(
                        "1st",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: normalFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        nameList.length >= 2 ? nameList[1] : "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: normalFontSize,
                          fontWeight: mediumFontWeight,
                        ),
                      ),
                      Text(
                        points.length >= 2 ? points[1].toString() : "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: largeFontSize,
                          color: Colors.purple,
                          fontWeight: mediumFontWeight,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 75,
                        height: 75,
                      ),
                      Text(
                        "1st",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: normalFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        nameList.length >= 3 ? nameList[2] : "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: normalFontSize,
                          fontWeight: mediumFontWeight,
                        ),
                      ),
                      Text(
                        points.length >= 3 ? points[2].toString() : "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: largeFontSize,
                          color: Colors.purple,
                          fontWeight: mediumFontWeight,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 41),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.75,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var i = 3; i < nameList.length; i++)
                        createLeaderboardEntry(i, nameList[i], points[i]),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Align(
                alignment: Alignment(0, -.5),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Points",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: largeFontSize,
                          fontWeight: mediumFontWeight,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        userPoints.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: largeFontSize,
                          fontWeight: mediumFontWeight,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      )),
    );
  }
}

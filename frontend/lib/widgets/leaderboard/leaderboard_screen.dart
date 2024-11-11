import 'package:flutter/material.dart';
import 'package:frontend/models/user_rankings.dart';
import 'package:frontend/utils/pathbuilder.dart';
import 'package:frontend/widgets/credentials/loading_screen.dart';
import 'package:frontend/widgets/dataprovider/data_provider.dart';
import 'package:frontend/widgets/home/loading_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For converting JSON response to a map
import 'package:frontend/widgets/styling/theme.dart';
import 'package:provider/provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  static const normalFontSize = 14.0;
  static const largeFontSize = 16.0;
  static const mediumFontWeight = FontWeight.w500;
  static const double podiumWidth = 100.0;

  Future<void> _refreshLeaderboard() async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider.refreshLeaderboard();
  }

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
    final dataProvider = Provider.of<DataProvider>(context);
    final List<User> ranks = dataProvider.userRanking?.sortedUserRankings ?? [];
    final int userPoints = dataProvider.userProfile?.points ?? 0;

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
              const SizedBox(height: 49),
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
                      const Text(
                        "2nd",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: normalFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: podiumWidth,
                        child: Text(
                          ranks.length >= 2 ? ranks[1].username : "",
                          textAlign: TextAlign.center,
                          maxLines: 1, // Limit to a single line
                          overflow: TextOverflow
                              .ellipsis, // Show ellipsis on overflow
                          style: const TextStyle(
                            fontSize: normalFontSize,
                            fontWeight: mediumFontWeight,
                          ),
                        ),
                      ),
                      Text(
                        ranks.length >= 2 ? ranks[1].points.toString() : "",
                        textAlign: TextAlign.center,
                        maxLines: 1, // Limit to a single line
                        overflow:
                            TextOverflow.ellipsis, // Show ellipsis on overflow
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
                      const Text(
                        "1st",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: normalFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: podiumWidth,
                        child: Text(
                          ranks.length >= 1 ? ranks[0].username : "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: normalFontSize,
                            fontWeight: mediumFontWeight,
                          ),
                        ),
                      ),
                      Text(
                        ranks.length >= 1 ? ranks[0].points.toString() : "",
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
                      const Text(
                        "1st",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: normalFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: podiumWidth,
                        child: Text(
                          ranks.length >= 3 ? ranks[2].username : "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: normalFontSize,
                            fontWeight: mediumFontWeight,
                          ),
                        ),
                      ),
                      Text(
                        ranks.length >= 3 ? ranks[2].points.toString() : "",
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
              const SizedBox(height: 41),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.75,
                child: RefreshIndicator(
                  onRefresh: _refreshLeaderboard,
                  child: ListView(
                    children: [
                      for (var i = 3; i < ranks.length; i++)
                        createLeaderboardEntry(
                            i + 1, ranks[i].username, ranks[i].points),
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
                      const Text(
                        "Your Points",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: largeFontSize,
                          fontWeight: mediumFontWeight,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        userPoints.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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

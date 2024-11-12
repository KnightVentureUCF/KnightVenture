import 'package:flutter/material.dart';
import 'package:frontend/models/user_profile.dart';
import 'package:frontend/utils/pathbuilder.dart';
import 'package:frontend/widgets/dataprovider/data_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For converting JSON response to a map
import 'package:frontend/widgets/styling/theme.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String accessToken;
  final String username;

  const ProfileScreen(
      {Key? key, required this.accessToken, required this.username})
      : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    String fullName = dataProvider.userProfile?.fullName ?? defaultFullName;
    String email = dataProvider.userProfile?.email ?? defaultEmail;
    int point = dataProvider.userProfile?.points ?? defaultPoints;
    int cachesFound =
        dataProvider.userProfile?.cachesFound ?? defaultCachesFound;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: brightGold,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: brightGold,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User profile picture with edit button
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: const AssetImage('assets/avatar.png'),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 3.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Display full name and username
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 30),
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: IconButton(
                    iconSize: 22,
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: () {
                      _editFullName(context, fullName, dataProvider);
                    },
                  ),
                ),
              ],
            ),
            Text(
              widget.username,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            // Points and Caches Found
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 25),
                _buildStatItem("Point", point.toString(), Icons.emoji_events),
                SizedBox(width: 120),
                _buildStatItem(
                    "Cache Found", cachesFound.toString(), Icons.map),
              ],
            ),
            SizedBox(height: 30),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title "Your Email" above the TextField
                Text(
                  "Your Email",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Adjust color as needed
                  ),
                ),
                SizedBox(
                    height: 8), // Spacing between the title and the TextField
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    filled: true,
                    fillColor: brightGold, // Adjust fill color as needed
                    hintText: email, // Use email from the fetched data
                    hintStyle: TextStyle(
                        color: Colors.grey), // Style for the hint text
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Rounded corners
                      borderSide:
                          BorderSide(color: Colors.black), // Border color
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),
            // Achievements
            _buildAchievements(cachesFound ?? 0),
            //Spacer(),
            // Logout Button
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 28),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildAchievements(int cachesFound) {
    List<Widget> achievements = [];

    // Logic to add achievements based on cachesFound
    if (cachesFound >= 15) {
      achievements.add(
          _buildAchievementItem("Completed 15 Geocaches", Icons.check_circle));
    }
    if (cachesFound >= 10) {
      achievements.add(
          _buildAchievementItem("Completed 10 Geocaches", Icons.check_circle));
    }
    if (cachesFound >= 5) {
      achievements.add(
          _buildAchievementItem("Completed 5 Geocaches", Icons.check_circle));
    }

    if (achievements.isEmpty) {
      achievements.add(
          _buildAchievementItem("Find more caches to unlock achievements!"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Achievements",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...achievements,
      ],
    );
  }

  Widget _buildAchievementItem(String title, [IconData? icon]) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: Colors.black) : null,
      title: Text(title),
    );
  }

  // TODO: Change this to update provider as well.
  Future<void> _editFullName(
      BuildContext context, String fullName, DataProvider dataProvider) async {
    String? newName = await showDialog(
      context: context,
      builder: (context) {
        String tempName = fullName;
        return AlertDialog(
          title: Text("Edit Full Name"),
          content: TextField(
            onChanged: (value) {
              tempName = value;
            },
            decoration: InputDecoration(
              hintText: fullName,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(tempName),
              child: Text("Update"),
            ),
          ],
        );
      },
    );
    dataProvider.updateUserFullName(newName ?? fullName, widget.accessToken);
  }
}

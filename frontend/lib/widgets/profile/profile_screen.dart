//TODO: Add enpoints to update profile in data base, pull the info (points, caches found, email) from database and cache found, think about acchivements
import 'package:flutter/material.dart';
import 'package:frontend/widgets/styling/theme.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = "Full Name";
  String userName = "@username";
  String email = "xxx@gmail.com";
  int points = 15;
  int cachesFound = 8;

  @override
  Widget build(BuildContext context) {
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
                  // Placeholder image for user avatar
                  backgroundImage: AssetImage('assets/avatar.png'),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.black),
                  onPressed: () {
                    _editFullName(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            // Display full name and username
            Text(
              fullName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              userName,
              style: TextStyle(
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
                _buildStatItem("Point", points.toString(), Icons.emoji_events),
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
                    hintText: 'xxx@gmail.com', // Add your email variable
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
            _buildAchievements(),
            Spacer(),
            // Logout Button
            ElevatedButton(
              onPressed: _logoutUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
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

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Achievements",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        _buildAchievementItem("Completed 15 Geocaches", Icons.check_circle),
        _buildAchievementItem("Completed 5 Geocaches", Icons.check_circle),
        _buildAchievementItem("Completed 10 Geocaches", Icons.check_circle),
      ],
    );
  }

  Widget _buildAchievementItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
    );
  }

  Future<void> _editFullName(BuildContext context) async {
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

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        fullName = newName;
      });
    }
  }

  void _logoutUser() {
    // Add AWS Cognito log out functionality here
    print("User logged out");
    // Example: Cognito sign out
    // await CognitoUserPool.signOut();
    // Navigate to login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Login Page"),
      ),
    );
  }
}

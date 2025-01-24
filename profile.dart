import 'package:flutter/material.dart';
class Profile extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profile> {
  // Example state variables
  String userName = "Umair Amjad";
  int gamesCount = 0;
  int upcomingCount = 0;
  int matchesCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/signup.png', // Replace with your actual image path
                fit: BoxFit.cover,
              ),
            ),
            // Content
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  // Back Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
                          onPressed: () {
                            Navigator.pop(context); // Navigate back
                          },
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            backgroundColor: Colors.lightGreenAccent,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Profile Picture and Name
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile_picture.jpg'), // Replace with actual image path
                  ),
                  SizedBox(height: 10),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Changed to black
                    ),
                  ),
                  SizedBox(height: 20),
                  // Stats (Games, Upcoming, Matches)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard(gamesCount.toString(), 'Games'),
                        _buildStatCard(upcomingCount.toString(), 'Upcoming'),
                        _buildStatCard(matchesCount.toString(), 'Matches'),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  // My Teams Section
                  SizedBox(height: 30),
                  // Options Section
                  _buildOptionList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Changed to black
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54, // Changed to dimmed black
          ),
        ),
      ],
    );
  }

  Widget _buildOptionList(BuildContext context) {
    return Column(
      children: [
        _buildOptionTile(Icons.calendar_today, 'My Bookings', () {
          // Navigate to My Bookings
        }),
        _buildOptionTile(Icons.favorite, 'My Favorites', () {
          // Navigate to My Favorites
        }),
        _buildOptionTile(Icons.help, 'Help & Support', () {
          // Navigate to Help & Support
        }),
        _buildOptionTile(Icons.cancel, 'Cancellation/Reschedule', () {
          // Navigate to Cancellation/Reschedule
        }),
        _buildOptionTile(Icons.question_answer, 'FAQ', () {
          // Navigate to FAQ
        }),
      ],
    );
  }

  Widget _buildOptionTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 30, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      onTap: onTap,
    );
  }
}

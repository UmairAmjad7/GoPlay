import 'package:flutter/material.dart';
import 'package:goplay_project/bookings.dart';
import 'package:goplay_project/bookingscreen.dart';
import 'package:goplay_project/historyscreen.dart';
import 'package:goplay_project/login.dart';
import 'package:goplay_project/profile.dart';


class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // List of unique titles and descriptions for the cards
  final List<Map<String, String>> cardData = [
    {
      "title": "CHAMPIONS ARENA",
      "description": "Location: Wapda Town\nHourly Rate: RS 2,000.\nContact No: 0314-1777314\nOnline Payment Method: JazzCash, Sadapay, NayaPay\n"
    },
    {
      "title": "PLAY ON",
      "description": "Location: PCSIR \nHourly Rate: RS 1,800.\nContact No: 0318-1997314\nOnline Payment Method: JazzCash, Sadapay, NayaPay\n"
    },
    {
      "title": "FUTSAL RANGE",
      "description": "Location: Wapda Town\nHourly Rate: RS 2,100.\nContact No: 0314-1777314\nOnline Payment Method: JazzCash, Sadapay, NayaPay\n"
    },
    {
      "title": "PAVILLION",
      "description": "Location: Engineers Town\nHourly Rate: RS 2,500.\nContact No: 0314-1777314\nOnline Payment Method: JazzCash, Sadapay, NayaPay\n"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/signup.png',
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),

          // Back button at the top-left corner
          Positioned(
            top: 40,
            left: 4,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyLogin()),
                ); // Navigate back
              },
              style: IconButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.lightGreenAccent.withOpacity(1),
                foregroundColor: Colors.black,
              ),
            ),
          ),

          // Content overlay
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5, // Limit the PageView height to 50% of the screen
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.85),
                  scrollDirection: Axis.horizontal,
                  itemCount: cardData.length, // Use the length of the cardData list
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            child: Image.asset(
                              'assets/card$index.jpeg', // Replace with your image paths
                              height: 120, // Set a fixed height for the image
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Use the title from the cardData list
                                Text(
                                  cardData[index]['title'] ?? '',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontFamily: 'Times New Roman',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 14),
                                // Use the description from the cardData list
                                Text(
                                  cardData[index]['description'] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Times New Roman',
                                    color: Colors.grey[700],

                                  ),
                                ),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => BookingScreen()),
                                  );
                                  },
                                    child: Text('Book'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightGreenAccent.withOpacity(1),
                                      foregroundColor: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Bottom buttons
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                  icon: Icon(Icons.person),
                  label: Text('Profile'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    backgroundColor: Colors.lightGreenAccent.withOpacity(1), // Background color
                    foregroundColor: Colors.black, // Text and icon color
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Bookings()),
                    );
                  },
                  icon: Icon(Icons.book),
                  label: Text('Bookings'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    backgroundColor: Colors.lightGreenAccent.withOpacity(1),
                    foregroundColor: Colors.black,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HistoryScreen()),
                    );
                  },
                  icon: Icon(Icons.history),
                  label: Text('History'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    backgroundColor: Colors.lightGreenAccent.withOpacity(1),
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// historyscreen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> pastBookings = [];

  @override
  void initState() {
    super.initState();
    fetchPastBookings();
  }

  // Fetch past bookings from Firestore
  Future<void> fetchPastBookings() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('bookings').get();

      List<Map<String, dynamic>> tempPast = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Parse date and time
        DateTime bookingDate =
        DateFormat.yMMMd().parse(data['date']); // e.g., "Aug 20, 2024"
        TimeOfDay bookingTime =
        TimeOfDay.fromDateTime(DateFormat.jm().parse(data['time'])); // e.g., "3:30 PM"

        DateTime combinedDateTime = DateTime(
          bookingDate.year,
          bookingDate.month,
          bookingDate.day,
          bookingTime.hour,
          bookingTime.minute,
        );

        // Add only past bookings
        if (combinedDateTime.isBefore(DateTime.now())) {
          tempPast.add({
            'id': doc.id,
            ...data,
          });
        }
      }

      setState(() {
        pastBookings = tempPast;
      });
    } catch (error) {
      print("Error fetching past bookings: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/signup.png',
              fit: BoxFit.cover,
            ),
          ),
          // Back Button
          Positioned(
            top: 40,
            left: 4,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context); // Navigate back
              },
              style: IconButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.lightGreenAccent.withOpacity(1),
                foregroundColor: Colors.black,
              ),
            ),
          ),
          pastBookings.isEmpty
              ? Center(
            child: Text(
              "No past bookings yet!",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          )
              : Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: ListView.builder(
              itemCount: pastBookings.length,
              itemBuilder: (context, index) {
                final booking = pastBookings[index];
                return Card(
                  color: Colors.white.withOpacity(0.9),
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      "Name: ${booking['name']}",
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${booking['email']}",
                            style: TextStyle(color: Colors.black)),
                        Text("Phone: ${booking['phone']}",
                            style: TextStyle(color: Colors.black)),
                        Text("Date: ${booking['date']}",
                            style: TextStyle(color: Colors.black)),
                        Text("Time: ${booking['time']}",
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Bookings extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<Bookings> {
  List<Map<String, dynamic>> upcomingBookings = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUpcomingBookings();
  }

  Future<void> fetchUpcomingBookings() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('bookings').get();

      List<Map<String, dynamic>> tempUpcoming = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        try {
          print("Fetched booking data: $data");

          String dateStr = data['date']?.toString() ?? '';
          String timeStr = data['time']?.toString() ?? '';

          if (dateStr.isEmpty || timeStr.isEmpty) {
            print("Skipping booking due to missing date or time: $data");
            continue;
          }

          DateTime bookingDate = DateFormat('MMM d, yyyy').parse(dateStr);
          DateTime timeDateTime = DateFormat('h:mm a').parse(timeStr);

          DateTime combinedDateTime = DateTime(
            bookingDate.year,
            bookingDate.month,
            bookingDate.day,
            timeDateTime.hour,
            timeDateTime.minute,
          );

          if (combinedDateTime.isAfter(DateTime.now())) {
            tempUpcoming.add({
              'id': doc.id,
              'name': data['name']?.toString() ?? 'No Name',
              'email': data['email']?.toString() ?? 'No Email',
              'phone': data['phone']?.toString() ?? 'No Phone',
              'date': dateStr,
              'time': timeStr,
            });
          }
        } catch (e) {
          print("Error parsing date/time for document ${doc.id}: $e");
          print("Date string: ${data['date']}, Time string: ${data['time']}");
        }
      }

      setState(() {
        upcomingBookings = tempUpcoming;
        isLoading = false;
      });

      print("Fetched upcoming bookings: $upcomingBookings");
    } catch (error) {
      setState(() {
        errorMessage = "Failed to load bookings: ${error.toString()}";
        isLoading = false;
      });
      print("Error fetching upcoming bookings: $error");
    }
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          "Name: ${booking['name']}",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              "Email: ${booking['email']}",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              "Phone: ${booking['phone']}",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              "Date: ${booking['date']}",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              "Time: ${booking['time']}",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchUpcomingBookings,
              child: Text('Retry'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      );
    }

    if (upcomingBookings.isEmpty) {
      return Center(
        child: Text(
          "No upcoming bookings yet!",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: ListView.builder(
        itemCount: upcomingBookings.length,
        itemBuilder: (context, index) {
          return _buildBookingCard(upcomingBookings[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/signup.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 40,
            left: 4,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreenAccent.withOpacity(1),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.all(8),
                child: Icon(Icons.arrow_back, color: Colors.black, size: 30),
              ),
            ),
          ),
          _buildContent(),
        ],
      ),
    );
  }
}
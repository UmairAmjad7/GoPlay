// booking_screen.dart
import 'package:flutter/material.dart';
import 'package:goplay_project/bookings.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> saveBookingToFirestore() async {
    final String name = nameController.text;
    final String email = emailController.text;
    final String phone = phoneController.text;
    final String date = DateFormat.yMMMd().format(selectedDate!);
    final String time = selectedTime!.format(context);

    await FirebaseFirestore.instance.collection('bookings').add({
      'name': name,
      'email': email,
      'phone': phone,
      'date': date,
      'time': time,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      print("Booking Information Saved");
    }).catchError((error) {
      print("Failed to add booking: $error");
    });
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
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
              style: IconButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.lightGreenAccent.withOpacity(1),
                foregroundColor: Colors.black,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  SizedBox(height: 60),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _selectDate(context),
                        icon: Icon(Icons.calendar_today),
                        label: Text(
                          selectedDate != null
                              ? DateFormat.yMMMd().format(selectedDate!)
                              : "Select Date",
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreenAccent,
                          foregroundColor: Colors.black,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _selectTime(context),
                        icon: Icon(Icons.access_time),
                        label: Text(
                          selectedTime != null
                              ? selectedTime!.format(context)
                              : "Select Time",
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreenAccent,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),

                  // Added View Bookings Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Bookings()),
                      );
                    },
                    child: Text(
                      "View Upcoming Bookings",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      backgroundColor: Colors.lightGreenAccent,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      String name = nameController.text;
                      String email = emailController.text;
                      String phone = phoneController.text;

                      if (name.isEmpty ||
                          email.isEmpty ||
                          phone.isEmpty ||
                          selectedDate == null ||
                          selectedTime == null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Missing Information"),
                            content: Text(
                                "Please fill in all fields and select a date and time."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );
                      } else {
                        saveBookingToFirestore();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Booking Requested"),
                            content: Text(
                                "The turf owner will contact you in a while!\n\nName: $name\nEmail: $email\nPhone: $phone\nDate: ${DateFormat.yMMMd().format(selectedDate!)}\nTime: ${selectedTime!.format(context)}"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Confirm Booking",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      backgroundColor: Colors.lightGreenAccent,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
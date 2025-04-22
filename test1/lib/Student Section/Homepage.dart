import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/Student%20Section/Academic_Calander.dart';
import 'package:test1/Student%20Section/attendance.dart';
import 'package:test1/Student%20Section/attendancesem1.dart';
import 'package:test1/Student%20Section/certificates.dart';
import 'package:test1/Student Section/feedback.dart';
import 'package:test1/Student%20Section/feepay.dart';
import 'package:test1/Student%20Section/mentor.dart';
import 'package:test1/Student Section/profile.dart';
import 'package:test1/Student Section/projects.dart';
import 'package:test1/Student%20Section/result.dart';
import 'package:test1/Student%20Section/schedule.dart';
import 'package:test1/Student%20Section/timetable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:test1/Student%20Section/transport.dart';
import 'package:test1/Student%20Section/session_manager.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}
class _HomepageState extends State<Homepage> {
  String _retrievedData = "Loading...";
  String test = "";
  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Widget targetPage = Homepage();
  Future<void> _fetchData() async {
    try {
      DatabaseReference dataRef = FirebaseDatabase.instance.ref("test");
      DatabaseEvent event = await dataRef.once();
      dynamic data = event.snapshot.value;

      setState(() {
        _retrievedData = data != null ? data.toString() : "No data available";
      });
    } catch (error) {
      setState(() {
        _retrievedData = "Error: $error";
      });
    }
  }
  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0); // Start position (off-screen)
        var end = Offset.zero; // End position (center of screen)
        var curve = Curves.ease; // Define transition curve
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
  String? errorMessage;
  String imageUrl="";
  File? _image;
  final ImagePicker _picker = ImagePicker();
  Future<void> fetchImage() async {
    final String enrollment = globalUsername!;
    if (enrollment.isEmpty) {
      setState(() {
        errorMessage = "Enrollment number is required.";
      });
      return;
    }

    final String url = "http://192.168.1.6:8080/Flutter/firstapp/bring.php?enrollment=$enrollment";
    print("Fetching image from: $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["success"]) {
          setState(() {
            globalImage=data["image_url"];
            imageUrl = data["image_url"];
            errorMessage = null;
          });
        } else {
          setState(() {
            imageUrl = "";
            errorMessage = data["message"];
          });
        }
      } else {
        setState(() {
          imageUrl = "";
          errorMessage = "Server error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        imageUrl = "";
        errorMessage = "Failed to connect to server";
      });
      print("Error fetching image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: () async {
        _fetchData();
        fetchImage();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "BALAJI TECHBIZ",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontFamily: 'Robot',
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.orangeAccent,
          actions: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0, right: 10),
              child: Container(

                color: Colors.white,
                child: InkWell(
                    onTap: () {
                      fetchImage();
                      targetPage = Profile(); // Set the target page to Signup
                      Navigator.push(
                        context,
                        _createPageRoute(targetPage),
                      );
                    },
                    child: ClipOval(
                      child: Image.asset(
                        "assets/image/Profile/IMG-20241128-WA0003-removebg-preview.png",
                        height: 80,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
            )
          ],
        ),
        body: Container( width: screenWidth,
          padding: EdgeInsets.all(20),
          height: screenHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 4),
                Card(
                  color: Colors.white,
                  elevation: 9,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('enrollmentData')
                        .where('enrollmentNumber', isEqualTo: sessionManager.username) // Filter by username
                        .where('password', isEqualTo: sessionManager.password) // Filter by password
                        .snapshots(),

                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'No students found or incorrect credentials.',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }
                      final students = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: students.length,
                        shrinkWrap: true, // Prevents infinite height issues
                        physics: NeverScrollableScrollPhysics(), // Disables inner scrolling
                        itemBuilder: (context, index) {
                          final studentData = students[index].data() as Map<String, dynamic>;
                          return StudentCard(studentData: studentData);
                        },
                      );
                    },
                  )
                ),
                SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing:15,
                  mainAxisSpacing: 15,
                  shrinkWrap: true, // Important for scrolling
                  physics: NeverScrollableScrollPhysics(), // Prevents conflict with outer scrolling
                  children: [
                    buildCard(context, title: "Academic Calendar", imagePath: "assets/image/calendar.png", onTap: () {
                      targetPage = academicCalander();
                      Navigator.push(context, _createPageRoute(targetPage));
                    }),
                    buildCard(context, title: "Timetable", imagePath: "assets/image/academic-schedule.png", onTap: () {
                      targetPage = Timetable();
                      Navigator.push(context, _createPageRoute(targetPage));
                    }),
                    buildCard(context, title: "Attendance", imagePath: "assets/image/attendance.png", onTap: () {
                      targetPage = Attendance();
                      Navigator.push(context, _createPageRoute(targetPage));
                    }),
                    buildCard(context, title: "Projects", imagePath: "assets/image/reading.png", onTap: () {
                      targetPage = Projects();
                      Navigator.push(context, _createPageRoute(targetPage));
                    }),
                    buildCard(context, title: "Feedback", imagePath: "assets/image/good-feedback.png", onTap: () {
                      targetPage = FeedbackScreen(enrollmentNumber: globalUsername);
                      Navigator.push(context, _createPageRoute(targetPage));
                    }),
                    buildCard(context, title: "Fees", imagePath: "assets/image/fees.png", onTap: () {
                      targetPage = feepay();
                      Navigator.push(context, _createPageRoute(targetPage));
                    }),
                    buildCard(context, title: "Transport", imagePath: "assets/image/vehicles.png", onTap: () {
                      fetchImage();
                      targetPage = Transport();
                      Navigator.push(context, _createPageRoute(targetPage));
                    }),
                    buildCard(context, title: "Exam Schedules", imagePath: "assets/image/examination.png", onTap: () {
                      targetPage = Schedule();
                      Navigator.push(context, _createPageRoute(targetPage));
                    }),
                    buildCard(context, title: "Result", imagePath: "assets/image/testing.png", onTap: () {
                      targetPage = Result();
                      Navigator.push(context, _createPageRoute(targetPage));
                    }),
                    buildCard(context, title: "Mentoring", imagePath: "assets/image/mentorship.png", onTap: () {
                      targetPage = MentorPage(enrollmentNumber: globalUsername);
                      Navigator.push(context, _createPageRoute(targetPage));
                    }),
                    buildCard(context, title: "Certificate\nRequest", imagePath: "assets/image/worksheet.png", onTap: () {
                      targetPage = Certificates();
                      Navigator.push(context, _createPageRoute(targetPage));
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildCard(BuildContext context,
      {required String title,
      required String imagePath,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
            // SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class StudentCard extends StatelessWidget {
  final Map<String, dynamic> studentData;
  const StudentCard({Key? key, required this.studentData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    globalBranch =studentData['stream'] ?? "Data not Found";
    globalFaculty = studentData['Mentor'] ?? "Unknown Mentor";
    globalname = studentData['name'] ?? "Unknown Name";
    globalSemester = studentData['semester'] ?? "Unknown Name";
    globalDivision = studentData['division'] ?? "Unknown Name";

    return Card(
      color: Colors.white,
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
         color: Colors.orangeAccent,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Name
            Text(
              studentData['name'] ?? 'Unknown Name',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoColumn(title: "Branch", value: studentData['stream'] ?? 'N/A'),
                InfoColumn(title: "Sem", value: studentData['semester']?.toString() ?? 'N/A'),
                InfoColumn(title: "Division", value: studentData['division'] ?? 'N/A'),
                InfoColumn(title: "Roll No.", value: studentData['rollNumber']?.toString() ?? 'N/A'),
              ],
            ),
            SizedBox(height: 10),
            Divider(color: Colors.white, thickness: 1),
            SizedBox(height: 8),
            Text(
              "Mentor By:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
            Text(
              studentData['Mentor'] ?? 'Unknown Mentor',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    // Add phone call logic
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.greenAccent,
                    child: Icon(Icons.phone, color: Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    // Add email logic
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.mail, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class InfoColumn extends StatelessWidget {
  final String title;
  final String value;
  const InfoColumn({Key? key, required this.title, required this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
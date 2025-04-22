import 'package:faculty2/faculty%20Section/Login.dart';
import 'package:faculty2/faculty%20Section/Student%20Details.dart';
import 'package:faculty2/faculty%20Section/admincalander.dart';
import 'package:faculty2/faculty%20Section/attendancepage.dart';
import 'package:faculty2/faculty%20Section/examSchedule.dart';
import 'package:faculty2/faculty%20Section/facultytimetable.dart';
import 'package:faculty2/faculty%20Section/globals.dart';
import 'package:faculty2/faculty%20Section/projects.dart';
import 'package:faculty2/faculty%20Section/result.dart';
import 'package:flutter/material.dart';

class adminhome extends StatefulWidget {
  const adminhome({super.key});

  @override
  State<adminhome> createState() => _adminhomeState();
}

Widget targetPage = adminhome();

PageRouteBuilder _createPageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0); // Start position (off-screen)
      var end = Offset.zero; // End position (center of screen)
      var curve = Curves.ease; // Define transition curve
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

class _adminhomeState extends State<adminhome> {
  @override
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure $globalUsername want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel logout
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),));
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        automaticallyImplyLeading: false,
        title: Text("Faculy Page",style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: _logout, // Click profile image to logout
              child: Container(
                color: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    "assets/image/Profile/IMG-20241128-WA0003-removebg-preview.png",
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: screenWidth,
            child: Column(
              children: [
                // REMOVE Expanded
                SizedBox(
                  child: GridView.count(
                    crossAxisCount: 3, // Three columns
                    crossAxisSpacing:15,
                    mainAxisSpacing: 15,
                    shrinkWrap: true,  // Ensures GridView does not take infinite height
                    physics: NeverScrollableScrollPhysics(), // Disable internal scrolling
                    children: [
                      buildCard(
                        context,
                        title: "Academic Calendar",
                        imagePath: "assets/image/calendar.png",
                      onTap: () => {targetPage = AdminCalendar(), Navigator.push(context, _createPageRoute(targetPage),),}

                      ),
                      buildCard(
                        context,
                        title: "Timetable",
                        imagePath: "assets/image/academic-schedule.png",
                          onTap: () => {targetPage = facultyTimetable(), Navigator.push(context, _createPageRoute(targetPage),),}

                      ),
                      buildCard(
                        context,
                        title: "Attendance",
                        imagePath: "assets/image/attendance.png",
                          onTap: () => {targetPage = facultyAttendance(), Navigator.push(context, _createPageRoute(targetPage),),}
                      ),
                      buildCard(
                        context,
                        title: "Projects",
                        imagePath: "assets/image/reading.png",
                          onTap: () => {targetPage = semesterList(), Navigator.push(context, _createPageRoute(targetPage),),}
                          ),
                      buildCard(
                        context,
                        title: "Exam Schedule",
                        imagePath: "assets/image/examination.png",
                          onTap: () => {targetPage = examSchedule(), Navigator.push(context, _createPageRoute(targetPage),),}
                     ),
                      buildCard(
                        context,
                        title: "Result",
                        imagePath: "assets/image/testing.png",
                          onTap: () => {targetPage = Result(), Navigator.push(context, _createPageRoute(targetPage),),}
                     ),
                      buildCard(
                          context,
                          title: "Student Info",
                          imagePath: "assets/image/list.png",
                          onTap: () => {targetPage = StudentDEtails(), Navigator.push(context, _createPageRoute(targetPage),),}
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
  Widget buildCard(BuildContext context, {required String title, required String imagePath, required VoidCallback onTap}) {
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
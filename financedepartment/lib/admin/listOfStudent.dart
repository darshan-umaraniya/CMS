import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financedepartment/admin/bcafees.dart';
import 'package:flutter/material.dart';

import 'global.dart';

class ListOfStudent extends StatefulWidget {
  const ListOfStudent({super.key});

  @override
  State<ListOfStudent> createState() => _ListOfStudentState();
}

Widget targetPage = ListOfStudent();

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

class _ListOfStudentState extends State<ListOfStudent> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "$globalBranch List Of Students",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "List of Students",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('enrollmentData').where("stream",isEqualTo: globalBranch).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No students found in the database.',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }

                final students = snapshot.data!.docs;

                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final studentData = students[index].data() as Map<String, dynamic>;
                    final studentId = studentData['enrollmentNumber'] ?? 'Unknown ID';

                    return InkWell(
                      onTap: () {
                        setState(() {
                          globalEnrollmentNumber = studentId; // Store the selected student's enrollment number globally
                        });
                        print("Selected Enrollment Number: $globalEnrollmentNumber");
                        targetPage = BcaFees(); // Navigate without explicitly passing data
                        Navigator.push(context, _createPageRoute(targetPage));
                      },
                      child: Card(
                        elevation: 10, // Increased for a more noticeable shadow
                        shadowColor:  Colors.blueAccent.withOpacity(0.5), // More vibrant shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Better spacing
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            title: Center(
                              child: Text(
                                studentId,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2, // Spacing makes it more readable
                                ),
                              ),
                            ),
                            leading: const Icon(Icons.person, color: Colors.orangeAccent, size: 30), // Icon for aesthetics
                            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20), // Subtle navigation hint
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

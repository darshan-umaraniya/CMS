import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faculty2/faculty%20Section/adminhomepage.dart';
import 'package:faculty2/faculty%20Section/globals.dart';
import 'package:faculty2/faculty%20Section/studentProject.dart';
import 'package:flutter/material.dart';


class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}
Widget targetPage = Projects();

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
class _ProjectsState extends State<Projects> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State variables for dropdowns
  String? selectedSemester;
  String? selectedDivision;

  // Available options
  List<String> semesters = ['1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th'];
  List<String> divisions = ['A', 'B', 'C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "$globalProject List",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            // Dropdowns for Semester & Division
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Semester Dropdown
                  DropdownButton<String>(
                    value: selectedSemester,
                    hint: const Text("Select Semester"),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSemester = newValue;
                      });
                    },
                    items: semesters.map((String semester) {
                      return DropdownMenuItem<String>(
                        value: semester,
                        child: Text(semester),
                      );
                    }).toList(),
                  ),

                  // Division Dropdown
                  DropdownButton<String>(
                    value: selectedDivision,
                    hint: const Text("Select Division"),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDivision = newValue;
                      });
                    },
                    items: divisions.map((String division) {
                      return DropdownMenuItem<String>(
                        value: division,
                        child: Text(division),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // "Load Students" Button
            ElevatedButton(
              onPressed: () {
                setState(() {}); // Refresh the list based on selection
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
              child: const Text(
                "Load Students",
                style: TextStyle(color: Colors.white),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: (selectedSemester != null && selectedDivision != null)
                  ? _firestore
                  .collection('enrollmentData')
                  .where("stream", isEqualTo: globalProject)
                  .where("semester", isEqualTo: selectedSemester)
                  .where("division", isEqualTo: selectedDivision)
                  .snapshots()
                  : null, // Prevents error if filters are not selected
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No students found. Please select Semester and Division.',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }

                final students = snapshot.data!.docs;

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final studentData = students[index].data() as Map<String, dynamic>;
                    final studentId = studentData['enrollmentNumber'] ?? 'Unknown ID';

                    return InkWell(
                      onTap: () {
                        targetPage = studentProject();
                        globalStudentList = studentId;
                        Navigator.push(context, _createPageRoute(targetPage));
                      },
                      child: Card(
                        elevation: 8,
                        color: Colors.white,
                        shadowColor: Colors.blueAccent.withOpacity(0.5),
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          title: Center(
                            child: Text(
                              studentId,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          leading: const Icon(Icons.person, color: Colors.orangeAccent, size: 30),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
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


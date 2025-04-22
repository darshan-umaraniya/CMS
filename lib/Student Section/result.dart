import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Student%20Section/session_manager.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double gradeToNumeric(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return 4.0;
      case 'B+':
        return 3.5;
      case 'B':
        return 3.0;
      case 'C+':
        return 2.5;
      case 'C':
        return 2.0;
      case 'F':
      default:
        return 0.0;
    }
  }

  int calculateBacklogCount(List<QueryDocumentSnapshot> results) {
    int backlogCount = 0;
    for (var result in results) {
      final data = result.data() as Map<String, dynamic>;
      final subjects = data['subjects'] as List<dynamic>? ?? [];
      backlogCount += subjects.where((subject) => subject['grade'] == 'F').length;
    }
    return backlogCount;
  }

  double calculateCGPA(List<QueryDocumentSnapshot> results) {
    double totalSGPA = 0.0;
    int totalSemesters = results.length;
    for (var result in results) {
      final data = result.data() as Map<String, dynamic>;
      final subjects = data['subjects'] as List<dynamic>? ?? [];
      double totalGradePoints = 0.0;
      int totalSubjects = 0;
      for (var subject in subjects) {
        totalGradePoints += gradeToNumeric(subject['grade']);
        totalSubjects++;
      }
      double semesterSGPA = totalSubjects > 0 ? totalGradePoints / totalSubjects : 0.0;
      totalSGPA += semesterSGPA;
    }
    return totalSemesters > 0 ? totalSGPA / totalSemesters : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        title: Text(
          'Result',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Robot',
            fontSize: 30,
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('enrollmentData')
              .doc(globalUsername) // Assuming this is the enrollment document ID
              .collection("result")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data found.'));
            }
            final results = snapshot.data!.docs;
            double cgpa = calculateCGPA(results);
            int backlogCount = calculateBacklogCount(results);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        color: Colors.greenAccent,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'CGPA: ${cgpa.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.redAccent,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Total Backlogs: $backlogCount',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final semester = results[index].id;
                      final data = results[index].data() as Map<String, dynamic>;
                      final subjects = data['subjects'] as List<dynamic>? ?? [];
                      bool hasBacklog = subjects.any((subject) => subject['grade'] == 'F');
                      return Card(
                        color: Colors.white,
                        elevation: 10,
                        margin: EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              Text('Semester: $semester',
                                  style: TextStyle(fontSize: 20, color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                              if (hasBacklog) ...[
                                SizedBox(width: 5),
                                Icon(Icons.circle, color: Colors.red, size: 10), // Red dot if any subject has F grade
                              ]
                              else ...[
                                SizedBox(width: 5),
                                Icon(Icons.circle, color: Colors.green, size: 10), // Red dot if any subject has F grade
                              ]
                            ],
                          ),
                          children: subjects.map((subject) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                color: Colors.white,
                                elevation: 4,
                                child: ListTile(
                                    title: Text('Subject: ${subject['name']}',
                                        style: TextStyle(color: Colors.orangeAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                    'Subject Code: ${subject['code']}\n'
                                        'Grade: ${subject['grade']}',
                                    style: TextStyle(fontSize: 20),
                                  ),

                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

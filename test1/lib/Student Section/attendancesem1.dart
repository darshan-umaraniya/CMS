import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Student%20Section/session_manager.dart';

String globalUserName = "22030401001"; // Ensure this matches Firestore's enrollmentNumber

class AttendanceSem1 extends StatefulWidget {
  const AttendanceSem1({super.key});

  @override
  State<AttendanceSem1> createState() => _AttendanceSem1State();
}

class _AttendanceSem1State extends State<AttendanceSem1> {
  DateTime selectedDate = DateTime.now();

  Future<Map<String, dynamic>?> fetchStudentByEnrollment(String date) async {
    final studentDocRef = FirebaseFirestore.instance
        .collection('Attendance')
        .doc(date)
        .collection('Students')
        .doc(globalUsername);

    print("📌 Fetching Firestore path: Attendance -> $date -> Students -> $globalUserName");

    try {
      final studentDoc = await studentDocRef.get();

      if (!studentDoc.exists) {
        print("❌ No record found for enrollment: $globalUserName on $date");
        return null;
      }

      print("✅ Student Found: ${studentDoc.data()}");
      return studentDoc.data();
    } catch (e) {
      print('🔥 Firestore Error: $e');
      return null;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

    return RefreshIndicator(
      onRefresh: () async => fetchStudentByEnrollment,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Attendance Records',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Robot',
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          backgroundColor: Colors.orangeAccent,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        elevation: 10,
                      ),
                      child: const Text(
                        "Pick Date",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<Map<String, dynamic>?>(
                future: fetchStudentByEnrollment(formattedDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No attendance record found.'));
                  }

                  final student = snapshot.data!;
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        child: Text(
                          student['Name'] != null && student['Name'].isNotEmpty
                              ? student['Name'][0]
                              : '',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        student['Name'] ?? 'Unknown',
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Enrollment: ${student['enrollmentNumber']}'),
                          Text(
                            'Attendance: ${student['Attendance'] == true ? "Present" : "Absent"}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

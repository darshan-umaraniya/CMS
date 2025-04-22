import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faculty2/faculty%20Section/globals.dart';
import 'package:flutter/material.dart';

class BcaAttendance extends StatefulWidget {
  const BcaAttendance({super.key});

  @override
  State<BcaAttendance> createState() => _BcaAttendanceState();
}

class _BcaAttendanceState extends State<BcaAttendance> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> studentData = [];
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();

  // New state variables for dropdown selections
  String? selectedSemester;
  String? selectedDivision;
  bool selectAll = false;

  // Sample semester and division lists (modify as needed)
  List<String> semesters = ['1st', '2nd', '3rd', '4th', '5th', '6th','7th','8th'];
  List<String> divisions = ['A', 'B', 'C'];

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchStudents() async {
    if (selectedSemester == null || selectedDivision == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Semester and Division')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      print("Fetching students for:");
      print("Stream: $globalBranch");
      print("Semester: $selectedSemester");
      print("Division: $selectedDivision");

      QuerySnapshot snapshot = await _firestore
          .collection('enrollmentData')
          .where('stream', isEqualTo: globalBranch) // Matches "BCA"
          .where('semester', isEqualTo: selectedSemester) // Must match "1st"
          .where('division', isEqualTo: selectedDivision) // Must match "A"
          .get();

      print("Documents found: ${snapshot.docs.length}");

      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No students found!')),
        );
      }

      setState(() {
        studentData = snapshot.docs.map((doc) {
          return {
            'Enrollment': doc.id,
            'Name': doc['enrollmentNumber'] ?? 'No Data',
            'Attendance': false, // Default to false
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching student data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching student data: $e')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveAttendance(String date) async {
    setState(() {
      isLoading = true;
    });

    try {
      for (var student in studentData) {
        await _firestore
            .collection('Attendance')
            .doc(date)
            .collection('Students')
            .doc(student['Enrollment'])
            .set({
          'enrollmentNumber': student['Enrollment'],
          'Name': student['Name'],
          'Attendance': student['Attendance'],
          'Semester': selectedSemester,
          'Division': selectedDivision,
        }, SetOptions(merge: true));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance saved for $date')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving attendance: $e')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "$globalBranch Attendance",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Semester and Division Dropdowns
          Padding(
            padding: const EdgeInsets.all(8.0),
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

                // Fetch Students Button
                ElevatedButton(
                  onPressed: fetchStudents,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                  ),
                  child: const Text("Load Students",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectAll = !selectAll;
                        for (var student in studentData) {
                          student['Attendance'] = selectAll;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                    ),
                    child: Text(
                      selectAll ? "Unselect All" : "Select All",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _pickDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                  ),
                  child: const Text("Pick Date",
                      style: TextStyle(
                          color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: studentData.length,
              itemBuilder: (context, index) {
                final student = studentData[index];
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        child: Text(
                          student['Name'][0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(student['Name']),
                      subtitle:
                      Text('Enrollment: ${student['Enrollment']}'),
                      trailing: Checkbox(
                        value: student['Attendance'],
                        onChanged: (value) {
                          setState(() {
                            studentData[index]['Attendance'] = value!;
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: ElevatedButton(
              onPressed: () => saveAttendance(formattedDate),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
              child: const Text(
                "Save Attendance",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
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
}

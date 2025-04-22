import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BcaDivisionA extends StatefulWidget {
  const BcaDivisionA({super.key});

  @override
  State<BcaDivisionA> createState() => _BcaDivisionAState();
}

class _BcaDivisionAState extends State<BcaDivisionA> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> studentData = []; // Store fetched data locally
  Map<String, bool> attendanceMap = {}; // Track attendance locally
  bool isLoading = true; // Track loading state for initial fetch

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data on initialization
  }

  /// Fetches data from Firestore and updates local state
  Future<void> fetchData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('students').get();
      final List<Map<String, dynamic>> data = snapshot.docs.map((doc) {
        final student = doc.data() as Map<String, dynamic>;
        attendanceMap[doc.id] = student['attendance'] ?? false; // Initialize attendance map
        return {'id': doc.id, ...student};
      }).toList();

      setState(() {
        studentData = data; // Update local data
        isLoading = false; // Data fetching is complete
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Updates attendance for a single student in Firestore
  Future<void> updateAttendance(String id, bool value) async {
    try {
      await _firestore.collection('students').doc(id).update({'attendance': value});
      print('Updated attendance for $id: $value');
    } catch (e) {
      print('Error updating attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update attendance.')),
      );
    }
  }

  /// Adds a new student to Firestore
  Future<void> addStudent(String name) async {
    try {
      await _firestore.collection('students').add({
        'name': name,
        'attendance': false, // Default attendance
      });
      print('Added new student: $name');
      fetchData(); // Refresh data after adding a new student
    } catch (e) {
      print('Error adding student: $e');
    }
  }

  /// Shows a dialog to add a new student
  void showAddStudentDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Student'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Enter student full name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  addStudent(name);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "BCA Division A Timetable",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Playfair',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Click to Update Attendance",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Playfair',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: studentData.length,
              itemBuilder: (context, index) {
                final item = studentData[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: InkWell(
                    onTap: () {
                      // Toggle attendance locally
                      final newValue = !(attendanceMap[item['id']] ?? false);
                      setState(() {
                        attendanceMap[item['id']] = newValue;
                      });

                      // Update Firestore in the background
                      updateAttendance(item['id'], newValue);
                    },
                    child: ListTile(
                      title: Text(item['name']),
                      trailing: Checkbox(
                        value: attendanceMap[item['id']] ?? false,
                        onChanged: (value) {
                          setState(() {
                            attendanceMap[item['id']] = value!;
                          });

                          // Update Firestore in the background
                          updateAttendance(item['id'], value!);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Attendance submitted successfully!')),
                );
              },
              child: const Text(
                'Submit Attendance',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddStudentDialog(context),
        child: const Icon(Icons.add),
        tooltip: 'Add Student',
      ),
    );
  }
}

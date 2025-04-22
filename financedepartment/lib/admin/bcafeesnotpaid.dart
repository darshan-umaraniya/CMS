import 'package:flutter/material.dart';
class bcafeesnotpaid extends StatefulWidget {
  const bcafeesnotpaid({super.key});
  @override
  State<bcafeesnotpaid> createState() => _bcafeesnotpaidState();
}
class _bcafeesnotpaidState extends State<bcafeesnotpaid> {
  // Updated student list with semester information
  final List<Map<String, dynamic>> students =
  [
    {"name": "Alice", "semester": "Semester 1", "isFeesPaid": true},
    {"name": "Bob", "semester": "Semester 1", "isFeesPaid": false},
    {"name": "Charlie", "semester": "Semester 2", "isFeesPaid": true},
    {"name": "Diana", "semester": "Semester 2", "isFeesPaid": false},
    {"name": "Eve", "semester": "Semester 3", "isFeesPaid": false},
    {"name": "Frank", "semester": "Semester 4", "isFeesPaid": true},
    {"name": "Grace", "semester": "Semester 5", "isFeesPaid": false},
    {"name": "Hannah", "semester": "Semester 6", "isFeesPaid": false},
  ];
  String selectedSemester = "All Semesters"; // Default selected semester
  String selectedPaymentStatus = "Unpaid Fees"; // Default selected payment status
  @override
  Widget build(BuildContext context) {
    // Filter the students based on the selected semester and payment status
    List<Map<String, dynamic>> filteredStudents = students;
    if (selectedPaymentStatus == "Unpaid Fees") {
      filteredStudents = selectedSemester == "All Semesters"
          ? students.where((student) => !student["isFeesPaid"]).toList()
          : students
          .where((student) =>
      student["semester"] == selectedSemester && !student["isFeesPaid"])
          .toList();
    }
    else if (selectedPaymentStatus == "Paid All Fees") {
      filteredStudents = selectedSemester == "All Semesters"
          ? students.where((student) => student["isFeesPaid"]).toList()
          : students
          .where((student) =>
      student["semester"] == selectedSemester && student["isFeesPaid"])
          .toList();
    }
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "BCA Fees",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontFamily: 'Playfair',
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Dropdown to select semester
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedSemester,
              isExpanded: true,
              items: ["All Semesters", "Semester 1", "Semester 2", "Semester 3", "Semester 4", "Semester 5", "Semester 6"]
                  .map((semester) {
                return DropdownMenuItem<String>(
                  value: semester,
                  child: Text(semester),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSemester = value!;
                });
              },
            ),
          ),
          // Dropdown to select payment status
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedPaymentStatus,
              isExpanded: true,
              items: ["Unpaid Fees", "Paid All Fees"]
                  .map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPaymentStatus = value!;
                });
              },
            ),
          ),
          // List of filtered students
          Expanded(
            child: filteredStudents.isEmpty
                ? Center(
              child: Text(
                selectedPaymentStatus == "Unpaid Fees"
                    ? "No unpaid fees for the selected semester."
                    : "No students have paid all fees for the selected semester.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
                return Card(color: Colors.white,
                  child: ListTile(
                    title: Text(student["name"], style: TextStyle(fontSize: 18)),
                    subtitle: Text("Semester: ${student["semester"]}"),
                    trailing: Icon(
                      student["isFeesPaid"] ? Icons.check_circle : Icons.cancel,
                      color: student["isFeesPaid"] ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
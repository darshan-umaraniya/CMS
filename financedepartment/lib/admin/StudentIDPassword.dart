import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BcaStudentIDPassword extends StatefulWidget {
  const BcaStudentIDPassword({super.key});

  @override
  State<BcaStudentIDPassword> createState() => _BcaStudentIDPasswordState();
}

class _BcaStudentIDPasswordState extends State<BcaStudentIDPassword> {
  TextEditingController numberController = TextEditingController();
  String selectedEnrollment = "";

  List<String> generatedPasswords = [];

  String selectedStream = "BCA";
  String selectedSemester = "1st";
  String selectedDivision = "A";

  final List<String> streams = ["BCA", "MCA", "BSC-IT", "BBA"];
  final List<String> semesters = ["1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th"];
  final List<String> divisions = ["A", "B", "C"];

  /// Fetch last enrollment number and increment
  Future<int> fetchLastEnrollmentNumber() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('enrollmentData')
          .orderBy('enrollmentNumber', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        int lastEnrollment = int.tryParse(snapshot.docs.first['enrollmentNumber']) ?? 22030401000;
        return lastEnrollment + 1;
      }
    } catch (e) {
      print('Error fetching last enrollment number: $e');
    }
    return 22030401000;
  }

  /// Generate a random 6-character password
  String generateSixDigitPassword() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  /// Generate random names
  String generateRandomName() {
    List<String> firstNames = ["Aarav", "Viren", "Rohan", "Ishaan", "Aryan", "Riya", "Priya", "Meera"];
    List<String> lastNames = ["Sharma", "Patel", "Mehta", "Joshi", "Kapoor", "Singh", "Gupta", "Desai"];

    Random random = Random();
    String firstName = firstNames[random.nextInt(firstNames.length)];
    String lastName = lastNames[random.nextInt(lastNames.length)];
    return "$firstName $lastName";
  }

  /// Generate enrollment numbers and passwords
  Future<void> generatePasswordsWithEnrollment(int count) async {
    int startEnrollment = await fetchLastEnrollmentNumber();

    setState(() {
      generatedPasswords = List.generate(count, (index) {
        String enrollmentNumber = (startEnrollment + index).toString();
        String password = generateSixDigitPassword();
        return '$enrollmentNumber: $password';
      });
    });
  }

  /// Save generated passwords to Firestore
  Future<void> saveGeneratedPasswordsToFirestore() async {
    try {
      for (var entry in generatedPasswords) {
        List<String> parts = entry.split(':');
        String enrollmentNumber = parts[0].trim();
        String generatedPassword = parts[1].trim();
        String randomName = generateRandomName();

        await FirebaseFirestore.instance.collection('enrollmentData').doc(enrollmentNumber).set({
          'enrollmentNumber': enrollmentNumber,
          'password': generatedPassword,
          'stream': selectedStream,
          'semester': selectedSemester,
          'division': selectedDivision,
          'name': randomName,
          'rollNumber': "No Data",
          'phoneNumber': "No Data",
          'email': "No Data",
          'momContact': "No Data",
          'dadContact': "No Data",
          'Mentor': "No Data",
        }, SetOptions(merge: true));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Generated passwords saved successfully!')),
        );
      }

      setState(() {
        generatedPasswords.clear();
      });
    } catch (e) {
      print('Error saving passwords: $e');
    }
  }

  Future<void> saveEnrollmentDataToMySQL() async {
    try {
      for (var entry in generatedPasswords) {
        List<String> parts = entry.split(':');
        String enrollmentNumber = parts[0].trim();
        String imageURL = ''; // Update this when implementing image uploads

        // Save to MySQL (PHP API)
        var url = Uri.parse('https://192.168.1.7/Flutter/firstapp/save_student.php'); // Replace with your actual API URL
        var response = await http.post(url, body: {
          'enrollmentNumber': enrollmentNumber,
          'stream': selectedStream,
          'imageURL': imageURL,
        });

        // Log the response
        print('Response for $enrollmentNumber: ${response.body}');

        // Handle Response
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == "success") {
            print('Saved to MySQL: $enrollmentNumber');
          } else {
            print('Error saving $enrollmentNumber: ${jsonResponse['message']}');
          }
        } else {
          print('Server error: ${response.statusCode}');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enrollment numbers saved successfully!')),
      );

      setState(() {
        generatedPasswords.clear();
      });
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.orangeAccent,
        title: Text("Manage Student Logins", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Generate New Enrollment Numbers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            /// Stream Dropdown
            DropdownButtonFormField<String>(
              value: selectedStream,
              items: streams.map((stream) {
                return DropdownMenuItem(value: stream, child: Text(stream));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStream = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Stream',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            /// Semester Dropdown
            DropdownButtonFormField<String>(
              value: selectedSemester,
              items: semesters.map((semester) {
                return DropdownMenuItem(value: semester, child: Text(semester));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSemester = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Semester',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            /// Division Dropdown
            DropdownButtonFormField<String>(
              value: selectedDivision,
              items: divisions.map((division) {
                return DropdownMenuItem(value: division, child: Text(division));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDivision = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Division',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter number of students',
                prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
              onPressed: () async {
                int count = int.tryParse(numberController.text) ?? 0;
                if (count > 0) {
                  await generatePasswordsWithEnrollment(count);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid number!')),
                  );
                }
              },
              child: Text("Generate Passwords", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            Expanded(
              child: generatedPasswords.isNotEmpty
                  ? ListView.builder(
                itemCount: generatedPasswords.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    color: Colors.grey.shade200,
                    child: ListTile(
                      title: Text(generatedPasswords[index]),
                      leading: Icon(Icons.lock, color: Colors.orangeAccent),
                    ),
                  );
                },
              )
                  : Center(child: Text("No passwords generated yet")),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
              onPressed: () async {
                await saveEnrollmentDataToMySQL();
                await saveGeneratedPasswordsToFirestore();
              },
              child: Text("Save Passwords", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

}

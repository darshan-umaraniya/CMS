import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'global.dart';

class BcaFees extends StatefulWidget {
  const BcaFees({super.key});

  @override
  State<BcaFees> createState() => _BcaFeesState();
}

class _BcaFeesState extends State<BcaFees> {
  @override
  void initState() {
    super.initState();
    fetchSemesterDetails(globalEnrollmentNumber);

  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _tuitionFees = TextEditingController();
  final TextEditingController _semesterRegistrationFees = TextEditingController();
  final TextEditingController _examFees = TextEditingController();
  final TextEditingController _enrollmentFees = TextEditingController();
  final TextEditingController _depositeFees = TextEditingController();
  final TextEditingController _uniformFees = TextEditingController();
  final TextEditingController _degreeCertificateTest = TextEditingController();
  String selectedSemester = 'Sem1'; // Default semester
  Map<String, dynamic>? semesterDetails;
  String total = "";

  String formatFees(dynamic fees) {
    if (fees == null || fees.toString().isEmpty) return '0';
    final numericValue = int.tryParse(fees.toString().replaceAll(',', ''));
    if (numericValue == null) return fees.toString();
    return numericValue.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
          (Match match) => '${match[1]},',
    );
  }


  Future<void> addStudentData(String enrollmentNumber) async {
    try {
      if (globalEnrollmentNumber.isNotEmpty) {
        fetchSemesterDetails(globalEnrollmentNumber);
      }

      DocumentReference docRef = _firestore.collection('enrollmentData').doc(enrollmentNumber);

      Map<String, dynamic> semesterFees = {
        "tuitionFees": _tuitionFees.text.replaceAll(',', ''),
        "semesterRegistrationFees": _semesterRegistrationFees.text.replaceAll(',', ''),
        "examFees": _examFees.text.replaceAll(',', ''),
        "enrollmentFees": _enrollmentFees.text.replaceAll(',', ''),
        "depositeFees": _depositeFees.text.replaceAll(',', ''),
        "uniformFees": _uniformFees.text.replaceAll(',', ''),
      };

      if (selectedSemester == 'Sem6') {
        semesterFees["degreeCertificate"] = _degreeCertificateTest.text.replaceAll(',', '');
      }

      await docRef.set({
        'fees': {
          selectedSemester: semesterFees,
        }
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fees updated successfully!')),
      );
      fetchSemesterDetails(enrollmentNumber);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating data: $e')),
      );
    }
  }

  Future<void> fetchSemesterDetails(String enrollmentNumber) async {
    try {
      if (enrollmentNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid enrollment number!')),
        );
        return;
      }

      DocumentSnapshot snapshot = await _firestore
          .collection('enrollmentData')
          .doc(enrollmentNumber)
          .get();

      if (snapshot.exists) {
        print("Document Data: ${snapshot.data()}");
      } else {
        print("No document found for $enrollmentNumber");
      }

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        Map<String, dynamic>? feesData = data?['fees'] as Map<String, dynamic>?;

        if (feesData != null && feesData.containsKey(selectedSemester)) {
          setState(() {
            semesterDetails = feesData[selectedSemester];
          });
          calculateTotal();
        } else {
          setState(() {
            semesterDetails = {};
            total = '0';
          });
        }
      } else {
        setState(() {
          semesterDetails = {};
          total = '0';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  void calculateTotal() {
    if (semesterDetails == null || semesterDetails!.isEmpty) {
      setState(() {
        total = '0';
      });
      return;
    }

    int tuition = int.tryParse(semesterDetails?['tuitionFees']?.toString() ?? '0') ?? 0;
    int semester = int.tryParse(semesterDetails?['semesterRegistrationFees']?.toString() ?? '0') ?? 0;
    int exam = int.tryParse(semesterDetails?['examFees']?.toString() ?? '0') ?? 0;
    int enrollment = int.tryParse(semesterDetails?['enrollmentFees']?.toString() ?? '0') ?? 0;
    int deposite = int.tryParse(semesterDetails?['depositeFees']?.toString() ?? '0') ?? 0;
    int uniform = int.tryParse(semesterDetails?['uniformFees']?.toString() ?? '0') ?? 0;

    int totalSum = tuition + semester + exam + enrollment + deposite + uniform;

    setState(() {
      total = totalSum.toString();
    });
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontSize: 20, color: Colors.black45, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void updateFeesInFirestore(String enrollmentNumber, String semester, Map<String, String> updatedFees) async {
    if (enrollmentNumber.isEmpty) return; // Prevent empty updates

    try {
      DocumentReference docRef = _firestore.collection('enrollmentData').doc(enrollmentNumber);
      DocumentSnapshot docSnap = await docRef.get();

      if (docSnap.exists) {
        await docRef.update({'fees.$semester': updatedFees});
      } else {
        await docRef.set({
          'fees': {semester: updatedFees}
        }, SetOptions(merge: true));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fees updated successfully!')),
      );

      fetchSemesterDetails(enrollmentNumber); // Refresh UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating fees: $e')),
      );
    }
  }

  void _showUpdateDialog(String selectedSemester) {
    Map<String, TextEditingController> controllers = {
      'tuitionFees': TextEditingController(text: semesterDetails?['tuitionFees']?.toString() ?? ''),
      'semesterRegistrationFees': TextEditingController(text: semesterDetails?['semesterRegistrationFees']?.toString() ?? ''),
      'examFees': TextEditingController(text: semesterDetails?['examFees']?.toString() ?? ''),
      'enrollmentFees': TextEditingController(text: semesterDetails?['enrollmentFees']?.toString() ?? ''),
      'depositeFees': TextEditingController(text: semesterDetails?['depositeFees']?.toString() ?? ''),
      'uniformFees': TextEditingController(text: semesterDetails?['uniformFees']?.toString() ?? ''),
      'degreeCertificate': TextEditingController(text: semesterDetails?['degreeCertificate']?.toString() ?? ''),
    };

    List<String> fieldsToUpdate = [];

    if (selectedSemester == 'Sem1') {
      fieldsToUpdate = [
        'tuitionFees', 'semesterRegistrationFees', 'examFees', 'enrollmentFees', 'depositeFees', 'uniformFees'
      ];
    } else if (['Sem2', 'Sem3', 'Sem4', 'Sem5'].contains(selectedSemester)) {
      fieldsToUpdate = ['tuitionFees', 'semesterRegistrationFees', 'examFees'];
    } else if (selectedSemester == 'Sem6') {
      fieldsToUpdate = ['tuitionFees', 'semesterRegistrationFees', 'examFees', 'degreeCertificate'];
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Update Fees - $selectedSemester',
            style: TextStyle(color: Colors.orangeAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: fieldsToUpdate.map((field) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: controllers[field],
                    decoration: InputDecoration(
                      labelText: field.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}').trim(),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Map<String, String> updatedFees = {};
                for (var field in fieldsToUpdate) {
                  if (controllers[field]!.text.trim().isNotEmpty) {
                    updatedFees[field] = controllers[field]!.text.trim();
                  }
                }
                if (updatedFees.isNotEmpty) {
                  print("Updating Firestore with: $updatedFees");
                  updateFeesInFirestore(globalEnrollmentNumber, selectedSemester, updatedFees);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No fees entered to update!')),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Update'),
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
          'BCA Fees',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: selectedSemester,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSemester = newValue!;
                    });
                    fetchSemesterDetails(globalEnrollmentNumber);
                  },
                  items: ['Sem1', 'Sem2', 'Sem3', 'Sem4', 'Sem5', 'Sem6']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  dropdownColor: Colors.white,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.orangeAccent,
                    size: 28,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.orangeAccent,
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.orangeAccent,
                  ),
                ),
                const SizedBox(height: 16),
                semesterDetails == null
                    ? const Center(
                  child: Text(
                    'No data found for the selected semester',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                )
                    : Card(
                  elevation: 12,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "$selectedSemester",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Divider(color: Colors.orangeAccent, height: 2),
                          ),
                          if (selectedSemester == 'Sem1') ...[
                            _buildRow('Tuition Fees', formatFees(semesterDetails?['tuitionFees'] ?? '0')),
                            _buildRow('Semester Registration Fees', formatFees(semesterDetails?['semesterRegistrationFees'] ?? '0')),
                            _buildRow('Exam Fees', formatFees(semesterDetails?['examFees'] ?? '0')),
                            _buildRow('Enrollment Fees', formatFees(semesterDetails?['enrollmentFees'] ?? '0')),
                            _buildRow('Deposit Fees', formatFees(semesterDetails?['depositeFees'] ?? '0')),
                            _buildRow('Uniform Fees', formatFees(semesterDetails?['uniformFees'] ?? '0')),
                          ],
                          if (['Sem2', 'Sem3', 'Sem4', 'Sem5'].contains(selectedSemester)) ...[
                            _buildRow('Tuition Fees', formatFees(semesterDetails?['tuitionFees'] ?? '0')),
                            _buildRow('Semester Registration Fees',
                                formatFees(semesterDetails?['semesterRegistrationFees'] ?? '0')),
                            _buildRow('Exam Fees', formatFees(semesterDetails?['examFees'] ?? '0')),
                          ],
                          if (selectedSemester == 'Sem6') ...[
                            _buildRow('Tuition Fees', formatFees(semesterDetails?['tuitionFees'] ?? '0')),
                            _buildRow('Semester Registration Fees',
                                formatFees(semesterDetails?['semesterRegistrationFees'] ?? '0')),
                            _buildRow('Exam Fees', formatFees(semesterDetails?['examFees'] ?? '0')),
                            _buildRow('Degree Certificate',
                                formatFees(semesterDetails?['degreeCertificate'] ?? '0')),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Divider(color: Colors.orangeAccent, height: 2),
                          ),
                          _buildRow('Total Fees', formatFees(total)),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Divider(color: Colors.orangeAccent, height: 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () => _showUpdateDialog(selectedSemester),
                child: const Text(
                  'Update Fees',
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

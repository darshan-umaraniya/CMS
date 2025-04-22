import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Student%20Section/session_manager.dart';

class feepay extends StatefulWidget {
  const feepay({super.key});

  @override
  State<feepay> createState() => _feepayState();
}

class _feepayState extends State<feepay> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String selectedSemester = 'Sem1'; // Default semester
  Map<String, dynamic>? semesterDetails;
  String total = "";

  // Utility function to format fees with commas
  String formatFees(String fees) {
    if (fees.isEmpty) return '';
    final numericValue = int.tryParse(fees);
    if (numericValue == null) return fees; // Return original string if not numeric
    return numericValue.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
          (Match match) => '${match[1]},',
    );
  }

  // Function to fetch semester details
  Future<void> fetchSemesterDetails() async {
    try {
      // Get student document from Firestore
      DocumentSnapshot snapshot = await _firestore
          .collection('enrollmentData')
          .doc(globalUsername) // Use enrollment number as document ID
          .get();

      if (snapshot.exists) {
        // Convert document data to a map
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // Extract fees for selected semester
        Map<String, dynamic>? feesData = data['fees'] as Map<String, dynamic>?;

        if (feesData != null && feesData.containsKey(selectedSemester)) {
          // Get semester data
          Map<String, dynamic> semesterData = feesData[selectedSemester];

          setState(() {
            semesterDetails = semesterData;
          });

          // **Call calculateTotal() after fetching semester details**
          calculateTotal();
        } else {
          setState(() {
            semesterDetails = null;
            total = '0';
          });
        }
      } else {
        setState(() {
          semesterDetails = null;
          total = '0';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

// **Modified calculateTotal()**
  void calculateTotal() {
    if (semesterDetails == null) return;

    int totalSum = 0;

    // **Sum up all available fee fields**
    semesterDetails!.forEach((key, value) {
      totalSum += int.tryParse(value.toString()) ?? 0;
    });

    setState(() {
      total = totalSum.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSemesterDetails();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: () async{
        fetchSemesterDetails();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.orangeAccent,
          title: const Text(
            'BCA Fees',
            style: TextStyle(
                fontFamily: 'Robot',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
        ),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.orangeAccent,width: 2.5),// Rounded border
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orangeAccent.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ], // Adding shadow to make it pop
                    ),
                    child: DropdownButton<String>(
                      value: selectedSemester,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSemester = newValue!;
                        });
                        fetchSemesterDetails();
                      },
                      items: ['Sem1', 'Sem2', 'Sem3', 'Sem4', 'Sem5', 'Sem6']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: Colors.orangeAccent, // Adjusting text color for better readability
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      dropdownColor: Colors.white, // Background color of the dropdown menu
                      borderRadius: BorderRadius.circular(10), // Rounded corners for the dropdown menu
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.orangeAccent, // Custom icon color
                        size: 32, // Custom icon size
                      ),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent, // Text color when selected
                      ),
                      underline: Container(),
                      isExpanded: true, // Make the dropdown button wide to fit the screen width
                    ),
                  ),
                ),
                semesterDetails == null
                    ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No data found for the selected semester'),
                )
                    : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 8,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.orangeAccent, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                Column(
                                  children: [
                                    if (selectedSemester == 'Sem1') ...[
                                      _buildRow('Tuition Fees', formatFees(semesterDetails?['tuitionFees']?.toString() ?? '0')),
                                      _buildRow('Semester Registration Fees', formatFees(semesterDetails?['semesterRegistrationFees']?.toString() ?? '0')),
                                      _buildRow('Exam Fees', formatFees(semesterDetails?['examFees']?.toString() ?? '0')),
                                      _buildRow('Enrollment Fees', formatFees(semesterDetails?['enrollmentFees']?.toString() ?? '0')),
                                      _buildRow('Deposit Fees', formatFees(semesterDetails?['depositeFees']?.toString() ?? '0')),
                                      _buildRow('Uniform Fees', formatFees(semesterDetails?['uniformFees']?.toString() ?? '0')),
                                    ],
                                    if (['Sem2', 'Sem3', 'Sem4', 'Sem5'].contains(selectedSemester)) ...[
                                      _buildRow('Tuition Fees', formatFees(semesterDetails?['tuitionFees']?.toString() ?? '0')),
                                      _buildRow('Semester Registration Fees', formatFees(semesterDetails?['semesterRegistrationFees']?.toString() ?? '0')),
                                      _buildRow('Exam Fees', formatFees(semesterDetails?['examFees']?.toString() ?? '0')),
                                    ],
                                    if (selectedSemester == 'Sem6') ...[
                                      _buildRow('Tuition Fees', formatFees(semesterDetails?['tuitionFees']?.toString() ?? '0')),
                                      _buildRow('Semester Registration Fees', formatFees(semesterDetails?['semesterRegistrationFees']?.toString() ?? '0')),
                                      _buildRow('Exam Fees', formatFees(semesterDetails?['examFees']?.toString() ?? '0')),
                                      _buildRow('Degree Certificate', formatFees(semesterDetails?['degreeCertificate']?.toString() ?? '0')),
                                    ],
                                  ],
                                ),
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
                        // Positioned dot (Top Right Only)
                        Positioned(
                          top: 20,
                          right: 20,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: _getDotColor(total),
                          ),
                        ),
                      ],
                    ),
                  ),

                )
              ]

            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 20)),
        Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'Roboto',
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  // Function to determine the dot color based on value
  Color _getDotColor(String value) {
    // Remove commas and try to parse the value as an integer
    int feeValue = int.tryParse(value.replaceAll(',', '')) ?? 0;

    // Case 1: If the fee is 35,000
    if (feeValue == 35000 || feeValue == 24500 || feeValue == 27000 ) {
      return Colors.greenAccent;
    }
    else {
      return Colors.redAccent;
    }
  }
}


import 'package:flutter/material.dart';
import 'package:test1/Student%20Section/Homepage.dart';
import 'package:test1/Student%20Section/studentFinalExam.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  String selectedSemester = 'Select Exam';
  bool isExpanded = false; // Controls animation visibility
  Map<String, dynamic>? semesterDetails;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "Schedule",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  Homepage(),
                ));
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "List of Exam Types",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),

                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded; // Toggle animation
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      width: isExpanded ? 250 : 220, // Expands smoothly
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.orangeAccent, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedSemester,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              AnimatedRotation(
                                turns: isExpanded ? 0.5 : 0.0, // Rotates the icon on expand
                                duration: const Duration(milliseconds: 300),
                                child: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.orangeAccent,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: AnimatedOpacity(
                              opacity: isExpanded ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Visibility(
                                visible: isExpanded,
                                child: Column(
                                  children: ['Unit', 'Mid 1', 'Mid 2', 'Final']
                                      .map((String value) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedSemester = value;
                                        isExpanded = false; // Close dropdown on selection
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ),

              Column(
                children: [
                  if (selectedSemester == 'Select Exam') ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Select an Exam")
                      ),
                    ),
                  ],
                  if (selectedSemester == 'Unit') ...[
                    Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: buildExamRow(
                          context,
                          exam1: "Unit Exam",
                        ),
                      ),
                    ),
                  ],
                  if (selectedSemester == 'Mid 1') ...[
                    Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: buildExamRow(
                          context,
                          exam1: "Mid Exam 1",
                        ),
                      ),
                    ),
                  ],if (selectedSemester == 'Mid 2') ...[
                    Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: buildExamRow(
                          context,
                          exam1: "Mid Exam 2",
                        ),
                      ),
                    ),
                  ],if (selectedSemester == 'Final') ...[
                    Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: buildExamRow(
                          context,
                          exam1: "Final Exam",
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildExamRow(BuildContext context,
      {required String exam1,}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildExamCard(context, examTitle: exam1),

        ],
      ),
    );
  }

  Widget buildExamCard(BuildContext context, {required String examTitle}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const studentFinalExam()));
        },
        child: Column(
          children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Hero(
                      tag: examTitle,
                      child: Image.asset("assets/image/exam-time.png",
                          height: 90, width: 90),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Text(
              examTitle,
              style: const TextStyle(
                fontFamily: 'Playfair',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

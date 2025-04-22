import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Timetable extends StatefulWidget {
  const Timetable({super.key});
  @override
  State<Timetable> createState() => _TimetableState();
}
class _TimetableState extends State<Timetable> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, Map<String, dynamic>>? timetable; // Variable to store all timetables
  bool isLoading = true; // To manage loading state
  // List of days in the desired order
  final List<String> daysOrder = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  @override
  void initState() {
    super.initState();
    fetchAndDisplayTimetable(); // Fetch timetable on page load
  }
  // Fetch and display timetable
  void fetchAndDisplayTimetable() async {
    final data = await fetchAllTimetables();
    setState(() {
      timetable = data;
      isLoading = false; // Mark loading as complete
    });
  }
  // Fetch all timetable data
  Future<Map<String, Map<String, dynamic>>> fetchAllTimetables() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('users').get();
      Map<String, Map<String, dynamic>> allData = {};

      for (var doc in querySnapshot.docs) {
        allData[doc.id] = doc.data() as Map<String, dynamic>;
      }
      return allData;
    } catch (e) {
      print("Error fetching data: $e");
      return {};
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: () async => fetchAllTimetables(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Timetable',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Robot',
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Container(
          width: screenWidth,
          height: screenHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                timetable != null
                    ? Column(
                  children: daysOrder.map((day) {
                    if (timetable!.containsKey(day)) {
                      Map<String, dynamic> lectures = timetable![day]!;
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ExpansionTile(
                            title: Text(
                              day,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: lectures.entries.map((lecture) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Card(
                                  color: Colors.white,
                                  elevation: 10,
                                  shadowColor: Colors.blueAccent.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide( color: Colors.blueAccent.withOpacity(0.1), width: 4),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Image.asset("assets/image/Attendance/lecture.png", height: 30, width: 30,),
                                    ),
                                    subtitle: Text(
                                      lecture.value.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Robot',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    } else {
                      return Container(); // Return an empty container if no data for the day
                    }
                  }).toList(),
                )
                    : const Center(
                  child: Text(
                    'No timetable data available.',
                    style: TextStyle(fontSize: 20,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: 450,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueAccent.withOpacity(0.1)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1. Mobile Application Development using Flutter (MADF)\n   Taken by Sheron Ma'am",
                              style: TextStyle(
                                fontFamily: 'PlayfairDisplay',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "2. Software Testing (ST)\n   Taken by Devangi Ma'am",
                              style: TextStyle(
                                fontFamily: 'PlayfairDisplay',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "3. Operating System Concepts (OSC)\n   Taken by Umesh Sir",
                              style: TextStyle(
                                fontFamily: 'PlayfairDisplay',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "4. JavaScript Framework (JSF)\n   Taken by Chirag Sir",
                              style: TextStyle(
                                fontFamily: 'PlayfairDisplay',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "5. Introduction to Advanced Technologies (IAT)\n   Taken by Umesh Sir",
                              style: TextStyle(
                                fontFamily: 'PlayfairDisplay',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
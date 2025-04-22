import 'package:faculty2/faculty%20Section/globals.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart';

class bcatimetable extends StatefulWidget {
  const bcatimetable({super.key});

  @override
  State<bcatimetable> createState() => _bcatimetableState();
}

class _bcatimetableState extends State<bcatimetable>  {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, Map<String, dynamic>>? timetable; // Variable to store all timetables
  bool isLoading = true; // To manage loading state

  final List<String> daysOrder = [
    "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
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

  // Show a dialog to edit a specific lecture
  void showEditDialog(BuildContext context, String day, String key, String currentValue) {
    TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Edit $key for $day'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'New Subject name',
            labelStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            hintText: 'Enter subject code (e.g., MATH101)',
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.black,
                  width: 1
              ),
            ),
            prefixIcon: Icon(
              Icons.code,
              color: Colors.blueAccent,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            filled: true,
            fillColor: Color.fromARGB(100,240, 240 ,240),
            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          ),
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent
            ),
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel',style: TextStyle(fontSize: 20,color: Colors.black),),
          ),
          TextButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent
            ),
            onPressed: () async {
              // Update Firestore with the new value
              await firestore.collection('users').doc(day).update({
                key: controller.text,
              });

              // Update the local timetable
              setState(() {
                timetable![day]![key] = controller.text;
              });

              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Save',style: TextStyle(fontSize: 20,color: Colors.black),),
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
        backgroundColor: Colors.orangeAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '$globalTimetable Timetable',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : timetable != null
          ? ListView(
        children: daysOrder.where((day) => timetable!.containsKey(day)).map((day) {
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
                  padding: const EdgeInsets.only(top: 5,bottom: 5),
                  child: Card(
                    shadowColor: Colors.blueAccent.withOpacity(0.5),
                    color: Colors.white,
                    elevation: 8,
                    child: ListTile(
                      subtitle: Text(lecture.value.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      trailing: IconButton(
                        icon: const Icon(
                            Icons.edit,
                            color: Colors.blue
                        ),
                        onPressed: () {
                          showEditDialog(context, day, lecture.key, lecture.value.toString());
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            ),
          );
        }).toList(),
      )
          : const Center(
        child: Text(
          'No timetable data available.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

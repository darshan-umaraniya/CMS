import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faculty2/faculty%20Section/globals.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class studentProject extends StatefulWidget {
  const studentProject({super.key});

  @override
  State<studentProject> createState() => _studentProjectState();
}

class _studentProjectState extends State<studentProject> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  // Controllers for input fields
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _testDateController = TextEditingController();
  final TextEditingController _testTimeController = TextEditingController();
  final TextEditingController _enrollmentController = TextEditingController();

  void _addProject() async {
    if (_formKey.currentState!.validate()) {
      final newProject = {
        'subjectName': _subjectNameController.text,
        'projectName': _projectNameController.text,
        'testDate': _testDateController.text,
        'testTime': _testTimeController.text,
        'enrollment': _enrollmentController.text,
        'mark': '-', // Default mark as not available
      };

      try {
        await _firestore.collection('projects').add(newProject);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Project added successfully!')),
        );
        _subjectNameController.clear();
        _projectNameController.clear();
        _testDateController.clear();
        _testTimeController.clear();
        _enrollmentController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add project: $e')),
        );
      }
    }
  }

  String request="";
  Future<void> createDatabase() async {
    try {
      // Create a new document in 'projectRequest' collection
      await _firestore.collection('projectRequest').add({
        'enrollment': globalStudentList, // Include enrollment in data
        'name': 'Darshan',
        'request': request,
      });

      print('Data added successfully!');
    } catch (e) {
      print('Error creating database: $e');
    }
  }


  String _currentView = 'mark'; // Tracks the current view ('all', 'tips', 'completed')

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "Projects",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: screenWidth,
          child: Column(
            children: [
              // Buttons for switching views
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        elevation: 10
                    ),
                    onPressed: () => setState(() => _currentView = 'mark'),
                    child: Text("Marks",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20,),),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        elevation: 10
                    ),
                    onPressed: () => setState(() => _currentView = 'request'),
                    child: Text("Request",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                ],
              ),
              Expanded(
                child: _buildBody(), // Dynamically build the body based on the view
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_currentView == 'mark') {
      return _buildTipsView();
    } else {
      return _buildCompletedProjectsView();
    }
  }

  Map<String, dynamic> projectDataMap = {};

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      // Fetch all documents from the 'projects' collection
      print("$globalStudentList");
      QuerySnapshot snapshot = await _firestore.collection('projects').where('enrollment',isEqualTo: globalStudentList).get();

      // Map the documents into a list of maps
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Optionally store the data in projectDataMap
        projectDataMap[doc.id] = {
          'enrollment': data['enrollment'] ?? '',
          'mark': data['mark'] ?? '',
          'projectName': data['projectName'] ?? '',
          'subjectName': data['subjectName'] ?? '',
          'testDate': data['testDate'] ?? '',
          'testTime': data['testTime'] ?? '',
        };

        return {'id': doc.id, ...data};
      }).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }


  Future<void> submitMarkChanges() async {
    try {
      for (var entry in projectDataMap.entries) {
        final documentId = entry.key;
        final newMark = entry.value['mark'];

        // Update the mark field directly without fetching the document first
        await _firestore.collection('projects').doc(documentId).update({
          'mark': newMark,
        });
      }

      // Notify the user of a successful update
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marks updated successfully!')),
      );
    } catch (e) {
      // Handle errors during the update process
      print('Error updating marks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update marks.')),
      );
    }
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
///Marks
  Widget _buildTipsView() {
    return Center(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red, fontSize: 18)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No projects found.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
          } else {
            final data = snapshot.data!;
            return Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "List of Projects",
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold,),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Glassmorphism effect
                                child: Card(
                                  elevation: 10,
                                  shadowColor:  Colors.blueAccent.withOpacity(0.5),
                                  color: Colors.white, // Semi-transparent effect
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Project Name
                                        Center(
                                          child: Text(
                                            item['projectName'] ?? 'No Project Name',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrangeAccent,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ),
                                        const Divider(thickness: 1, color: Colors.orangeAccent),

                                        // Details Section
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _infoRow('Enrollment:', item['enrollment']),
                                              _infoRow('Subject:', item['subjectName']),
                                              _infoRow('Date:', item['testDate']),
                                              _infoRow('Time:', item['testTime']),
                                            ],
                                          ),
                                        ),

                                        const Divider(thickness: 1, color: Colors.orangeAccent),

                                        // Marks Input Field with Stylish Border
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Marks:',
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: TextField(
                                                  keyboardType: TextInputType.number,
                                                  style: const TextStyle(fontSize: 18),
                                                  decoration: InputDecoration(
                                                    hintText: 'Enter marks',
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      borderSide: const BorderSide(color: Colors.black, width: 2),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      borderSide: const BorderSide(
                                                          color: Colors.orangeAccent, width: 2),
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    final newMarks = int.tryParse(value) ?? 0;
                                                    if (projectDataMap[item['id']]['mark'] != newMarks) {
                                                      projectDataMap[item['id']]['mark'] = newMarks;
                                                    }
                                                  },
                                                  controller: TextEditingController(
                                                    text: projectDataMap[item['id']]['mark'].toString(),
                                                  )..selection = TextSelection.fromPosition(
                                                    TextPosition(offset: projectDataMap[item['id']]['mark'].toString().length),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Floating Save Button
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.orangeAccent,
                    elevation: 10,
                    onPressed: submitMarkChanges,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text('Save Changes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }



  Map<String, dynamic> projectRequestMap = {};

  Future<List<Map<String, dynamic>>> fetchProjectRequest() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('projectRequest').where('enrollment', isEqualTo: globalStudentList).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        projectDataMap[doc.id] = {
          'name': data['name'],
          'projectRequest': data['request'],
          'YNO': temp,
        };
        return {'id': doc.id, ...data};
      }).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  String temp = "";

  // Function to update the YON field in Firestore
  Future<void> updateYON(String documentId, String value) async {
    try {
      await _firestore
          .collection('projectRequest')
          .doc(documentId)
          .update({'yesOrNo': value});
      print('YON updated to $value for document $documentId');
    } catch (e) {
      print('Failed to update YON: $e');
    }
  }
///Request
  Widget _buildCompletedProjectsView() {
    return FutureBuilder<QuerySnapshot>(
      future: _firestore.collection('projectRequest').where('enrollment', isEqualTo: globalStudentList).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No completed projects found."));
        }

        // Create a local list of projects
        List<QueryDocumentSnapshot> projects = snapshot.data!.docs;

        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(child: Text("List Of Request",style: TextStyle(fontSize: 30),)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index].data() as Map<String, dynamic>;
                      final documentId = projects[index].id;

                      return Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 10,
                          shadowColor:  Colors.blueAccent.withOpacity(0.5),
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Student Name: ${project['name'] ?? 'N/A'}",
                                    style: TextStyle( fontSize: 20)),
                                Text("Project Name: ${project['request'] ?? 'N/A'}",
                                    style: TextStyle( fontSize: 20)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          updateYON(documentId, "Accept");
                                          setState(() {
                                            projects.removeAt(index); // Remove the card
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.greenAccent),
                                        child: Text(
                                          "Accept",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          updateYON(documentId, "Decline");
                                          setState(() {
                                            projects.removeAt(index); // Remove the card
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent),
                                        child: Text(
                                          "Decline",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faculty2/faculty%20Section/globals.dart';
import 'package:flutter/material.dart';

class FacultyResult extends StatefulWidget {
  const FacultyResult({super.key});

  @override
  State<FacultyResult> createState() => _FacultyResultState();
}

class _FacultyResultState extends State<FacultyResult> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _subjectCodeController = TextEditingController();

  String _selectedGrade = 'F';
  String _selectedSemester = '1';

  /// ✅ Add or Update Subject Data in Firestore
  void _addOrUpdateData() async {
    String subjectName = _subjectNameController.text.trim();
    String subjectCode = _subjectCodeController.text.trim();
    String grade = _selectedGrade;
    String? enrollmentNumber = globalStudentid;
    String semester = _selectedSemester;

    if (subjectName.isEmpty || subjectCode.isEmpty || grade.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    try {
      DocumentReference docRef = _firestore
          .collection('enrollmentData')
          .doc(enrollmentNumber)
          .collection('result')
          .doc(semester);

      await docRef.set({
        'subjects': FieldValue.arrayUnion([
          {'name': subjectName, 'code': subjectCode, 'grade': grade}
        ])
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subject added successfully!')),
      );

      _subjectNameController.clear();
      _subjectCodeController.clear();
      setState(() {
        _selectedGrade = 'F';
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  /// ✅ UI: Faculty Result Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        title: Text(
          '$globalStudentid',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('enrollmentData')
                  .doc(globalStudentid)
                  .collection('result')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No subjects found.'));
                }

                final results = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final semester = results[index].id;
                    final data = results[index].data() as Map<String, dynamic>;
                    final subjects = data['subjects'] as List<dynamic>? ?? [];

                    return Card(
                      elevation: 10,
                      shadowColor:  Colors.blueAccent.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.all(8.0),
                      color: Colors.white,
                      child: ExpansionTile(
                        title: Text(
                          'Semester: $semester',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        children: subjects.isEmpty
                            ? [ListTile(title: Text("No subjects added yet"))]
                            : subjects.map((subject) {
                          return ListTile(
                            title: Text(
                              '${subject['name']} (${subject['code']})',
                              style: TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              'Grade: ${subject['grade']}',
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /// ✅ Input Fields to Add New Subject
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _subjectNameController,
                  decoration: InputDecoration(
                    labelText: "Subject Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _subjectCodeController,
                  decoration: InputDecoration(
                    labelText: "Subject Code",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedSemester,
                  decoration: InputDecoration(labelText: "Semester"),
                  items: List.generate(8, (index) {
                    return DropdownMenuItem(
                      value: (index + 1).toString(),
                      child: Text("Semester ${index + 1}"),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedSemester = value!;
                    });
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedGrade,
                  decoration: InputDecoration(labelText: "Grade"),
                  items: ['A', 'B', 'C', 'D', 'F','A+', 'B+', 'C+', 'D+', 'F+'].map((grade) {
                    return DropdownMenuItem(
                      value: grade,
                      child: Text(grade),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGrade = value!;
                    });
                  },
                ),
                SizedBox(height: 15),

                /// ✅ Add Subject Button
                ElevatedButton(
                  onPressed: _addOrUpdateData,
                  child: Text(
                    'Add Subject',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

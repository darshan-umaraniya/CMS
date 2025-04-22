import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/Student%20Section/Homepage.dart';
import 'package:test1/Student%20Section/session_manager.dart';

class studentFinalExam extends StatefulWidget {
  const studentFinalExam({super.key});

  @override
  State<studentFinalExam> createState() => _studentFinalExamState();
}

class _studentFinalExamState extends State<studentFinalExam> {

  final _firestore = FirebaseFirestore.instance;

  /// Fetch project data from Firestore
  Future<List<Map<String, dynamic>>> fetchProjectRequest() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Exam').where('stream',isEqualTo: globalBranch,).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {'id': doc.id, ...data};
      }).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "Final Exam",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Playfaair',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Expanded(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchProjectRequest(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No data available'),
                );
              }

              final projects = snapshot.data!;

              return ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return Card(
                    elevation: 5,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        'Subject: ${project['subject'] ?? 'N/A'}',
                        style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.orangeAccent),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Exam Code: ${project['examCode'] ?? 'N/A'}',style: TextStyle(fontFamily: 'Playfaair',fontSize: 20),),
                          Text('Time: ${project['time'] ?? 'N/A'}',style: TextStyle(fontFamily: 'Playfaair',fontSize: 20)),
                          Text('Date: ${project['date'] ?? 'N/A'}',style: TextStyle(fontFamily: 'Playfaair',fontSize: 20)),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

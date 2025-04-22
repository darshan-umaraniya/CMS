import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class bcaProjects extends StatefulWidget {
  const bcaProjects({super.key});

  @override
  State<bcaProjects> createState() => _bcaProjectsState();
}

class _bcaProjectsState extends State<bcaProjects>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> projectDataMap = {};

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('projects').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        projectDataMap[doc.id] = {
          'attendance': data['attendance'] ?? false,
          'marks': data['marks'] ?? 0,
        };
        return {'id': doc.id, ...data};
      }).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  Future<void> submitChanges() async {
    try {
      for (var entry in projectDataMap.entries) {
        await _firestore.collection('projects').doc(entry.key).update({
          'attendance': entry.value['attendance'],
          'marks': entry.value['marks'],
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully!')),
      );
    } catch (e) {
      print('Error updating data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save changes.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: const Text(
          'Projects Tracker',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              fontFamily: 'Playfaair',
              color: Colors.white
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No projects found.'));
          } else {
            final data = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text("List of projects",style: TextStyle(fontFamily: 'Playfaair',fontSize: 25),),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(item['projectName'] ?? 'No Project Name'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Enrollnement: ${item['enrollment'] ?? 'N/A'}'),
                              Text('Subject: ${item['subjectName'] ?? 'N/A'}'),
                              Text('Date: ${item['testDate'] ?? 'N/A'}'),
                              Text('Time: ${item['testTime'] ?? 'N/A'}'),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text('Marks: '),
                                  Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Enter marks',
                                      ),
                                      onChanged: (value) {
                                        final newMarks = int.tryParse(value) ?? 0;
                                        projectDataMap[item['id']]['marks'] = newMarks;
                                      },
                                      controller: TextEditingController(
                                        text: projectDataMap[item['id']]['marks'].toString(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: submitChanges,
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

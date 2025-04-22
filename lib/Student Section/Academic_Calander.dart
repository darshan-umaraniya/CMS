import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class academicCalander extends StatefulWidget {
  const academicCalander({super.key});

  @override
  State<academicCalander> createState() => _academicCalanderState();
}

class _academicCalanderState extends State<academicCalander> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchEvents() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('AcademicCalander').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'Event': data['Event'] ?? '',
          'Date': data['Date'] != null ? DateTime.parse(data['Date']) : null,
        };
      }).toList();
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return  RefreshIndicator(
      onRefresh: () async {
        fetchEvents();
      },
      child: Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.orangeAccent,
          title: Text("Academic Calander",style: TextStyle(color: Colors.white,fontFamily: 'Robot',fontWeight: FontWeight.bold,fontSize: 30, ),),
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        ),
        body:Container(
          height: screenHeight,
          width: screenWidth,
          child: Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No events found.'));
                } else {
                  final events = snapshot.data!;
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final item = events[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: Image.asset(
                              "assets/image/Attendance/google-calendar.png",
                              height: 30,
                              width: 30,
                            ),
                            title: Text('Date: ${item['Date'] != null ? item['Date'].toString().split(' ')[0] : 'N/A'}',style: TextStyle(fontFamily: 'Robot',fontSize: 20),),
                            subtitle:  Text('Event: ${item['Event']}',style: TextStyle(fontFamily: 'Robot',fontSize: 20)),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );

  }
}


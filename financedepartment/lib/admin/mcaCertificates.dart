import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class mcaCertificates extends StatefulWidget {
  const mcaCertificates({super.key});

  @override
  State<mcaCertificates> createState() => _mcaCertificatesState();
}

class _mcaCertificatesState extends State<mcaCertificates> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchAllDetails() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Certificate').get();
      return snapshot.docs
          .where((doc) => (doc['stream'] ?? '') == 'MCA') // Filter only bca stream
          .map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'name': data['name'] ?? 'N/A',
          'enrollment': data['enrollment'] ?? 'N/A',
          'reason': data['reason'] ?? 'N/A',
          'request': data['request'] ?? 'N/A',
          'stream': data['stream'] ?? 'N/A',
        };
      }).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.orangeAccent,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('MCA Certificates',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAllDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No certificates found.'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Center(
                      child: Text(
                        'Name: ${item['name']}',
                        style: const TextStyle(
                             fontSize: 20,color: Colors.orangeAccent,fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enrollment: ${item['enrollment']}',
                          style: const TextStyle(
                               fontSize: 16),
                        ),
                        Text(
                          'Stream: ${item['stream']}',
                          style: const TextStyle(
                               fontSize: 16),
                        ),
                        Text(
                          'Certificate Name: ${item['request']}',
                          style: const TextStyle(
                               fontSize: 16),
                        ),
                        Text(
                          'Reason: ${item['reason']}',
                          style: const TextStyle(
                               fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

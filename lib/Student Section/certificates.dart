import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Student%20Section/session_manager.dart';

class Certificates extends StatefulWidget {
  const Certificates({super.key});

  @override
  State<Certificates> createState() => _CertificatesState();
}

class _CertificatesState extends State<Certificates> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  String? selectedCertificate;

  Future<void> addData() async {
    try {
      await firestore.collection('Certificate').add({
        'name': globalname,
        'enrollment': globalUsername,
        'Branch': globalBranch,
        'request': selectedCertificate,
        'reason': _reasonController.text,
        'Semester': globalSemester,
        'Division':globalDivision,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Certificate request added successfully!')),
      );
      _clearFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding request: $e')),
      );
    }
  }

  void _clearFields() {
    _nameController.clear();
    _reasonController.clear();
    setState(() {
      selectedCertificate = null;
    });
  }

  final List<String> certificateList = [
    'Bonafide',
    'Transfer Certificate',
    'Character Certificate',
    'Migration Certificate',
  ];

  void _showCertificateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Center(
            child: Text(
              "Certificate Request Form",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDropdown(),
                _buildTextField(_reasonController, "Reason", Icons.edit, maxLines: 3),
              ],
            ),
          ),
          actions: [
            _buildDialogButton(context, "Cancel", Colors.redAccent, () {
              Navigator.of(context).pop();
            }),
            _buildDialogButton(context, "Submit", Colors.greenAccent, () {
              if (
                  selectedCertificate == null ||
                  _reasonController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All fields are required!")),
                );
              } else {
                addData();
                Navigator.of(context).pop();
              }
            }),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Select Certificate Type",
          prefixIcon: const Icon(Icons.document_scanner, color: Colors.blueAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        value: selectedCertificate,
        items: certificateList.map((String certificate) {
          return DropdownMenuItem<String>(
            value: certificate,
            child: Text(certificate),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedCertificate = newValue;
          });
        },
      ),
    );
  }

  Widget _buildDialogButton(BuildContext context, String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      onPressed: onPressed,
    );
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Certificate Request',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
            fontFamily: 'Robot',
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('Certificate').where("enrollment",isEqualTo: globalUsername).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final data = snapshot.data?.docs;

                    if (data == null || data.isEmpty) {
                      return const Center(child: Text('No Certificates Found'));
                    }

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final doc = data[index];
                        final certificate = doc.data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 8,
                            shadowColor: Colors.orangeAccent,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                              title:  StreamBuilder<QuerySnapshot>(
                                stream: _firestore
                                    .collection('enrollmentData')
                                    .where('enrollmentNumber', isEqualTo: sessionManager.username) // Filter by username
                                    .where('password', isEqualTo: sessionManager.password) // Filter by password
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          'No students found or incorrect credentials.',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  }
                                  final students = snapshot.data!.docs;
                                  return ListView.builder(
                                    itemCount: students.length,
                                    shrinkWrap: true, // Prevents infinite height issues
                                    physics: NeverScrollableScrollPhysics(), // Disables inner scrolling
                                    itemBuilder: (context, index) {
                                      final studentData = students[index].data() as Map<String, dynamic>;
                                      return Center(
                                        child: Text(
                                          studentData['name'] ?? 'Unknown Name',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(thickness: 2,color: Colors.orangeAccent,),
                                  _buildInfoRow(Icons.person, 'Enrollment', certificate['enrollment'] ?? 'Unknown'),
                                  _buildInfoRow(Icons.school, 'Branch', certificate['Branch'] ?? 'Unknown'),
                                  _buildInfoRow(Icons.file_copy, 'Request', certificate['request'] ?? 'Unknown'),
                                  _buildInfoRow(Icons.comment, 'Reason', certificate['reason'] ?? 'Unknown'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 8,
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                ),
                icon: const Icon(Icons.add, color: Colors.white, size: 24),
                label: const Text(
                  'Request Certificate',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () => _showCertificateDialog(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.orangeAccent),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
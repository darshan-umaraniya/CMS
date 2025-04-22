import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Certificates extends StatefulWidget {
  const Certificates({super.key});

  @override
  State<Certificates> createState() => _CertificatesState();
}

class _CertificatesState extends State<Certificates> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late String fullName;
  late String fullEnrollment;
  late String streaM;
  late String requestForCertificate;
  late String reasonForCertificate;

  Future<void> addData() async {
    try {
      await firestore.collection('Certificate').add({
        'name': fullName,
        'enrollment': fullEnrollment,
        'stream': streaM,
        'request': selectedCertificate,
        'reason': reasonForCertificate,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Certificate request added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding request: $e')),
      );
    }
  }

  // Predefined list of certificates
  final List<String> certificateList = [
    'Bonafide',
    'Transfer Certificate',
    'Character Certificate',
    'Migration Certificate',
  ];

  void _showCertificateDialog(BuildContext context) {
    final TextEditingController _name = TextEditingController();
    final TextEditingController _enrollment = TextEditingController();
    final TextEditingController _stream = TextEditingController();
    final TextEditingController _reason = TextEditingController();

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
                _buildTextField(_name, "Full Name", Icons.person),
                _buildTextField(_enrollment, "Enrollment Number", Icons.confirmation_number),
                _buildTextField(_stream, "Stream", Icons.school),
                _buildDropdown(),
                _buildTextField(_reason, "Reason", Icons.edit, maxLines: 3),
              ],
            ),
          ),
          actions: [
            _buildDialogButton(context, "Cancel", Colors.redAccent, () {
              Navigator.of(context).pop();
            }),
            _buildDialogButton(context, "Submit", Colors.greenAccent, () {
              if (_name.text.isEmpty ||
                  _enrollment.text.isEmpty ||
                  _stream.text.isEmpty ||
                  selectedCertificate == null ||
                  _reason.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All fields are required!")),
                );
              } else {
                // Save Data
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

  // Variable to store the selected certificate
  String? selectedCertificate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('Certificate').snapshots(),
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
                          shadowColor: Colors.orangeAccent.withOpacity(0.4),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Center(
                                  child: Text(
                                    certificate['name'] ?? 'No Name',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orangeAccent,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                          color: Colors.black26,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow(Icons.person, 'Enrollment', certificate['enrollment'] ?? 'Unknown'),
                                  _buildInfoRow(Icons.school, 'Stream', certificate['stream'] ?? 'Unknown'),
                                  _buildInfoRow(Icons.file_copy, 'Request', certificate['request'] ?? 'Unknown'),
                                  _buildInfoRow(Icons.comment, 'Reason', certificate['reason'] ?? 'Unknown'),
                                ],
                              ),
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
    );
  }

  // Helper Widget for cleaner code
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




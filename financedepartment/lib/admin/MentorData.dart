import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financedepartment/admin/global.dart';
import 'package:flutter/material.dart';

class MentorData extends StatefulWidget {
  const MentorData({super.key});

  @override
  State<MentorData> createState() => _MentorDataState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _MentorDataState extends State<MentorData> {
  void _updateMentorData(String docId, String name, String email, String contact, String department, String setting) {
    _firestore.collection('Faculty_id_password').doc(docId).update({
      'name': name,
      'email': email,
      'contact': contact,
      'department': department,
      'setting': setting,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data updated successfully!',style: TextStyle(color: Colors.white),),backgroundColor: Colors.greenAccent,),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update data: $error',style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,),
      );
    });
  }
  void _deleteMentor(String mentorId) async {
    try {
      await _firestore.collection('Faculty_id_password').doc(mentorId).delete();
      setState(() {}); // Ensure the UI updates after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mentor deleted successfully!", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.greenAccent,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting mentor: $e", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          'Mentor Data',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 28,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Faculty_id_password').where('userId',isEqualTo: globalFacultyID).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No mentor data found.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }
          final mentors = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: mentors.length,
            itemBuilder: (context, index) {
              final mentorDoc = mentors[index];
              final mentorData = mentorDoc.data() as Map<String, dynamic>;
              final name = mentorData['username'] ?? 'Unknown';
              final email = mentorData['email'] ?? 'No Email';
              final contact = mentorData['contact'] ?? 'No Contact';
              final department = mentorData['department'] ?? 'Unknown Department';
              final setting = mentorData['setting'] ?? 'Default Setting';

              return Dismissible(
                key: Key(mentorDoc.id), // Unique key for animation
                direction: DismissDirection.endToStart, // Swipe right to left to delete
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red, // Background color when swiped
                  child: const Icon(Icons.delete, color: Colors.white, size: 30),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Confirm Delete"),
                      content: const Text("Are you sure you want to delete this mentor?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteMentor(mentorDoc.id);
                            Navigator.pop(context, true);
                          },
                          child: const Text("Delete", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) {
                  // Called when dismissed successfully
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name deleted successfully!')),
                  );
                },
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadowColor:Colors.blueAccent.withOpacity(0.1),
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.orangeAccent,
                      child: Text(
                        name[0].toUpperCase(),
                        style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text('📧 Email: $email', style: const TextStyle(fontSize: 16)),
                        Text('📞 Contact: $contact', style: const TextStyle(fontSize: 16)),
                        Text('🏢 Department: $department', style: const TextStyle(fontSize: 16)),
                        Text('⚙️ Setting: $setting', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                TextEditingController nameController = TextEditingController(text: name);
                                TextEditingController emailController = TextEditingController(text: email);
                                TextEditingController contactController = TextEditingController(text: contact);
                                TextEditingController departmentController = TextEditingController(text: department);
                                TextEditingController settingController = TextEditingController(text: setting);

                                return AlertDialog(
                                  title: const Text(
                                    'Edit Mentor Data',
                                    style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                                      TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                                      TextField(controller: contactController, decoration: const InputDecoration(labelText: 'Contact')),
                                      TextField(controller: departmentController, decoration: const InputDecoration(labelText: 'Department')),
                                      TextField(controller: settingController, decoration: const InputDecoration(labelText: 'Setting')),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _updateMentorData(
                                          mentorDoc.id,
                                          nameController.text,
                                          emailController.text,
                                          contactController.text,
                                          departmentController.text,
                                          settingController.text,
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Update', style: TextStyle(color: Colors.orangeAccent)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Confirm Delete"),
                                content: const Text("Are you sure you want to delete this mentor?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deleteMentor(mentorDoc.id);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignIdPass extends StatefulWidget {
  const AssignIdPass({super.key});

  @override
  State<AssignIdPass> createState() => _AssignIdPassState();
}

class _AssignIdPassState extends State<AssignIdPass> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  Map<String, double> opacityMap = {}; // Track opacity per item

  Future<void> addUserToFirebase(String userId, String password, String role) async {
    try {
      await FirebaseFirestore.instance.collection('Faculty_id_password').doc(role).set({
        'userId': userId,
        'password': password,
        'username': role,
        'contact': 'No data',
        'department': 'No data',
        'email': 'No data',
        'setting': 'No data',
        'name': 'No data',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding user: $e')),
      );
    }
  }

  Stream<QuerySnapshot> getFacultyData() {
    return FirebaseFirestore.instance.collection('Faculty_id_password').snapshots();
  }

  void showDeleteDialog(String role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Faculty Account"),
        content: Text("Are you sure you want to delete the faculty account for $role?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                opacityMap[role] = 0.0; // Fade out effect
              });

              await Future.delayed(Duration(milliseconds: 300)); // Wait for animation

              await FirebaseFirestore.instance.collection('Faculty_id_password').doc(role).delete();

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Faculty account deleted successfully")),
              );
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Assign ID & Password",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Enter Username:", roleController, Icons.person),
              SizedBox(height: 20),
              _buildTextField("Enter User ID:", userIdController, Icons.account_box),
              SizedBox(height: 20),
              _buildTextField("Enter Password:", passwordController, Icons.lock),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String userId = userIdController.text.trim();
                    String password = passwordController.text.trim();
                    String role = roleController.text.trim();

                    if (userId.isNotEmpty && password.isNotEmpty && role.isNotEmpty) {
                      addUserToFirebase(userId, password, role);
                      userIdController.clear();
                      passwordController.clear();
                      roleController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill out all fields!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.orangeAccent,
                  ),
                  child: Text("Submit", style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Existing Faculty Information:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: getFacultyData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No faculty members found.'));
                  }

                  var facultyData = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: facultyData.length,
                    itemBuilder: (context, index) {
                      var data = facultyData[index];
                      String role = data.id;

                      opacityMap.putIfAbsent(role, () => 1.0); // Ensure initial opacity

                      return AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: opacityMap[role]!,
                        child: ListTile(
                          onLongPress: () {
                            showDeleteDialog(role);
                          },
                          title:Card(
                            color: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person, color: Colors.orangeAccent),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Username: ${data['username']}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10), // Spacing between rows
                                  Row(
                                    children: [
                                      Icon(Icons.lock, color: Colors.redAccent),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Password: ${data['password']}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Card(
          color: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: Icon(icon, color: Colors.blueAccent),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            ),
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/Student%20Section/Homepage.dart';
import 'package:test1/Student%20Section/Login.dart';
import 'package:test1/Student%20Section/attendancesem1.dart';
import 'package:http/http.dart' as http;
import 'package:test1/Student%20Section/session_manager.dart'; // Import SessionManager
class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  Map<String, dynamic>? studentData;
  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }
  /// Fetch student data based on logged-in username and password
  Future<void> fetchStudentData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('enrollmentData')
          .where('enrollmentNumber', isEqualTo: sessionManager.username) // Filtering by username
          .where('password', isEqualTo: sessionManager.password) // Filtering by password
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          studentData = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        });
      } else {
        print('No student data found or incorrect credentials.');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
  String? errorMessage;
  String imageUrl="";
  File? _image;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      print("Selected image path: ${_image!.path}");
    } else {
      print("No image selected");
    }
  }
  Future<void> _updateStudentData(String studentId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('students').doc(studentId).set(data, SetOptions(merge: true));
  }
  Future<void> _uploadImage(String studentId) async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an image")),
      );
      return;
    }

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://192.168.1.6:8080/Flutter/firstapp/upload.php"),
    );

    request.files.add(await http.MultipartFile.fromPath("image", _image!.path));
    request.fields["enrollment"] = globalUsername!;
    request.fields["semester"] = globalSemester;
    request.fields["division"] = globalDivision;
    request.fields["stream"] = globalBranch;

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      print("Upload Response: $responseData");

      final jsonResponse = jsonDecode(responseData);
      if (jsonResponse["success"]) {
        setState(() {
          imageUrl = jsonResponse["image_url"];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image uploaded successfully!")),
        );
        _updateStudentData(studentId, {'imageUrl': imageUrl});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: ${jsonResponse["message"]}")),
        );
      }
    } catch (e) {
      print("Error uploading: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed! Check your server connection.")),
      );
    }
  }
  Future<void> fetchImage() async {
    final String enrollment = globalUsername!;
    if (enrollment.isEmpty) {
      setState(() {
        errorMessage = "Enrollment number is required.";
      });
      return;
    }

    final String url = "http://192.168.1.6:8080/Flutter/firstapp/bring.php?enrollment=$enrollment";
    print("Fetching image from: $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["success"]) {
          setState(() {
            globalImage=data["image_url"];
            imageUrl = data["image_url"];
            errorMessage = null;
          });
        } else {
          setState(() {
            imageUrl = "";
            errorMessage = data["message"];
          });
        }
      } else {
        setState(() {
          imageUrl = "";
          errorMessage = "Server error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        imageUrl = "";
        errorMessage = "Failed to connect to server";
      });
      print("Error fetching image: $e");
    }
  }
  void _updateImage() {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Update Image",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _image != null
                ? Image.file(_image!, height: 150)
                : Container(
              height: 150,
              width: 150,
              color: Colors.grey[300],
              child: Icon(Icons.image, size: 50, color: Colors.grey),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.photo_library),
              label: Text("Pick Image"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                _uploadImage(studentData?['enrollmentNumber']);
                fetchImage();
                Navigator.pop(context);
              },
              icon: Icon(Icons.cloud_upload),
              label: Text("Upload"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
            fontFamily: 'Robot',
          ),
        ),
        leading: IconButton(
          onPressed: () {
            globalImage="";
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: studentData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: fetchImage,  // ✅ Calls fetchImage on pull-down refresh
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(), // ✅ Ensures pull-to-refresh works
            children: [
              Card(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: _updateImage,  // ✅ Calls the update image function
                        child: Container(
                          child: Column(
                            children: [
                              globalImage != null
                                  ? CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(globalImage!),
                              )
                                  : CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey[300],
                                child: Icon(Icons.person, size: 60, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        studentData?['name'] ?? "N/A",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Enrollment: ${studentData?['enrollmentNumber'] ?? "N/A"}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _infoCard("Branch", studentData?['stream'] ?? "N/A", Icons.school),
                    _infoCard("Semester", studentData?['semester']?.toString() ?? "N/A", Icons.calendar_month),
                    _infoCard("Division", studentData?['division'] ?? "N/A", Icons.group),
                    _infoCard("Roll No.", studentData?['rollNumber']?.toString() ?? "N/A", Icons.confirmation_number),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _sectionTitle("Student Contact"),
              _contactCard("Phone", studentData?['phoneNumber'] ?? "N/A", Icons.phone),
              _contactCard("Email", studentData?['email'] ?? "N/A", Icons.email),
              SizedBox(height: 20),
              _sectionTitle("Father Contact"),
              _contactCard("Phone", studentData?['dadContact'] ?? "N/A", Icons.phone),
              SizedBox(height: 20),
              _sectionTitle("Mother Contact"),
              _contactCard("Phone", studentData?['momContact'] ?? "N/A", Icons.phone),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  ),
                  onPressed: openLogOut,
                  child: Text(
                    "Log Out",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _infoCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.orangeAccent),
            SizedBox(height: 5),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            SizedBox(height: 5),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  Widget _contactCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orangeAccent),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
  Widget _sectionTitle(String title) {
    return Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87));
  }
  Future openLogOut() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Are you sure you want to log out?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text("Yes"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
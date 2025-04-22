import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:faculty2/faculty%20Section/globals.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
class Studentdata extends StatefulWidget {
  const Studentdata({super.key});
  @override
  State<Studentdata> createState() => _StudentdataState();
}
class _StudentdataState extends State<Studentdata> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Widget _buildDetailCard(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        shadowColor:  Colors.blueAccent.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Colors.orangeAccent),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  final ImagePicker _picker = ImagePicker();
  final studentId="0";
  Future<void> _updateStudentData(String studentId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('students').doc(studentId).set(data, SetOptions(merge: true));
  }
  String imageUrl = "";
  String? errorMessage;
  // Dropdown Lists
  List<String> streams = ['BCA', 'MCA', 'BBA', 'BSC-IT'];
  List<String> semesters = ['1st', '2nd', '3rd', '4th', '5th', '6th','7th','8th'];
  List<String> divisions = ['A', 'B', 'C'];
  File? _image;
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
    request.fields["enrollment"] = globalEnrollmentNumber!;
    request.fields["semester"] = semesters.first;
    request.fields["division"] = divisions.first;
    request.fields["stream"] = streams.first;
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
  Future<void> fetchImage() async {
    final String enrollment = globalEnrollmentNumber!;
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
  void _showUpdateDialog(String studentId, Map<String, dynamic> studentData) {
    final _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: studentData['name']);
    final mentorController = TextEditingController(text: studentData['Mentor']);
    final rollNumberController = TextEditingController(text: studentData['rollNumber']);
    final phoneController = TextEditingController(text: studentData['phoneNumber']);
    final emailController = TextEditingController(text: studentData['email']);
    final momContactController = TextEditingController(text: studentData['momContact']);
    final dadContactController = TextEditingController(text: studentData['dadContact']);
    final passwordController = TextEditingController();
    String selectedStream = studentData['stream'] ?? streams.first;
    String selectedSemester = studentData['semester'] ?? semesters.first;
    String selectedDivision = studentData['division'] ?? divisions.first;
    if (!streams.contains(selectedStream)) selectedStream = streams.first;
    if (!semesters.contains(selectedSemester)) selectedSemester = semesters.first;
    if (!divisions.contains(selectedDivision)) selectedDivision = divisions.first;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Update Student Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    _buildTextField('Name', nameController, Icons.person),
                    _buildTextField('Mentor', mentorController, Icons.person),
                    SizedBox(height: 10),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          children: [
                            _buildDropdown(
                              'Stream',
                              selectedStream,
                              streams,
                                  (newValue) => setState(() => selectedStream = newValue),
                            ),
                            _buildDropdown(
                              'Semester',
                              selectedSemester,
                              semesters,
                                  (newValue) => setState(() => selectedSemester = newValue),
                            ),
                            _buildDropdown(
                              'Division',
                              selectedDivision,
                              divisions,
                                  (newValue) => setState(() => selectedDivision = newValue),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    _buildTextField('Roll Number', rollNumberController, Icons.confirmation_number),
                    _buildTextField('Phone Number', phoneController, Icons.phone, isPhone: true),
                    _buildTextField('Email', emailController, Icons.email, isEmail: true),
                    _buildTextField("Mom's Contact", momContactController, Icons.phone_android, isPhone: true),
                    _buildTextField("Dad's Contact", dadContactController, Icons.phone_android, isPhone: true),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      enabled: globalUsername == studentData['Mentor'],
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (globalUsername == studentData['Mentor']) {
                            _updateStudentData(studentId, {
                              'name': nameController.text,
                              'Mentor': mentorController.text,
                              'stream': selectedStream,
                              'semester': selectedSemester,
                              'division': selectedDivision,
                              'rollNumber': rollNumberController.text,
                              'phoneNumber': phoneController.text,
                              'email': emailController.text,
                              'momContact': momContactController.text,
                              'dadContact': dadContactController.text,
                              'password': passwordController.text.isNotEmpty
                                  ? passwordController.text
                                  : studentData['password'],
                            });
                            _uploadImage(studentId); // Correct function call
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('You are not authorized to update the password.')),
                            );
                          }
                        }
                      },
                      icon: Icon(Icons.save),
                      label: Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  void _showImageUploadDialogImageUpload() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Upload Image", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
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
                  _uploadImage(studentId);
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
      },
    );
  }
  Widget _buildDropdown(String label, String selectedValue, List<String> items, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              underline: SizedBox(),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTextField(String label, TextEditingController controller, IconData icon,
      {bool isPhone = false, bool isEmail = false, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isPhone ? TextInputType.phone : (isEmail ? TextInputType.emailAddress : TextInputType.text),
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          return null;
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        title: Text(
          'Student Data',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
      body: Column(
        children: [
          RefreshIndicator(
            onRefresh: () async => fetchImage(),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: AlwaysScrollableScrollPhysics(),
              child: Center(
                child: InkWell(
                  onTap: () {
                    _showImageUploadDialogImageUpload();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // ✅ Prevent unnecessary stretching
                      children: [
                        imageUrl != null
                            ? CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(imageUrl!),
                        )
                            : CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.person, size: 60, color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Tap to upload new image",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('enrollmentData')
                  .where('enrollmentNumber', isEqualTo: globalEnrollmentNumber,)
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
                        'No matching student found.',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }
                final studentData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                final studentId = snapshot.data!.docs.first.id;
                return SingleChildScrollView(
                  child: Container(
                    width: screenWidth,
                    padding: EdgeInsets.all(15),
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shadowColor:  Colors.blueAccent.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                studentData['enrollmentNumber'] ?? 'Unknown ID',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(color: Colors.orangeAccent, thickness: 3),
                            SizedBox(height: 10),
                            // Display student details
                            _buildDetailCard("Name", studentData['name'] ?? 'Unknown'),
                            _buildDetailCard("Branch", studentData['stream'] ?? 'Unknown'),
                            _buildDetailCard("Semester", studentData['semester'] ?? 'Unknown'),
                            _buildDetailCard("Division", studentData['division'] ?? 'Unknown'),
                            _buildDetailCard("Roll Number", studentData['rollNumber'] ?? 'Unknown'),
                            _buildDetailCard("Phone Number", studentData['phoneNumber'] ?? 'Unknown'),
                            _buildDetailCard("Email", studentData['email'] ?? 'Unknown'),
                            _buildDetailCard("Mom's Contact", studentData['momContact'] ?? 'Unknown'),
                            _buildDetailCard("Dad's Contact", studentData['dadContact'] ?? 'Unknown'),
                              _buildDetailCard("Mentor", studentData['Mentor'] ?? 'Unknown'),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () => _showUpdateDialog(studentId, studentData),
                                icon: Icon(Icons.person
                                ),
                                label: Text('Edit'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
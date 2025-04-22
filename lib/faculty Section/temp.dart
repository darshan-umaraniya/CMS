import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}
File? _image;
class _UploadImageScreenState extends State<UploadImageScreen> {
  String imageUrl = "";
  final picker = ImagePicker();

  // Controllers for text fields
  final TextEditingController enrollmentController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController divisionController = TextEditingController();
  final TextEditingController streamController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  String? errorMessage;

  Future<void> _uploadImage() async {
    if (_image == null ||
        enrollmentController.text.isEmpty ||
        semesterController.text.isEmpty ||
        divisionController.text.isEmpty ||
        streamController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fill all fields and select an image")),
      );
      return;
    }

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://192.168.1.7:8080/Flutter/firstapp/upload.php"),
    );

    request.files.add(await http.MultipartFile.fromPath("image", _image!.path));
    request.fields["enrollment"] = enrollmentController.text;
    request.fields["semester"] = semesterController.text;
    request.fields["division"] = divisionController.text;
    request.fields["stream"] = streamController.text;

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    final jsonResponse = jsonDecode(responseData);
    if (jsonResponse["success"]) {
      setState(() {
        imageUrl = jsonResponse["image_url"];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image uploaded successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed!")),
      );
    }
  }

  Future<void> fetchImage() async {
    final String enrollment = enrollmentController.text.trim();
    if (enrollment.isEmpty) {
      setState(() {
        errorMessage = "Enrollment number is required.";
      });
      return;
    }

    final String url =
        "http://192.168.1.7:8080/Flutter/firstapp/bring.php?enrollment=$enrollment";

    try {
      final response = await http.get(Uri.parse(url));

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload & Fetch Image")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: enrollmentController,
              decoration: InputDecoration(labelText: "Enrollment Number"),
            ),
            TextField(
              controller: semesterController,
              decoration: InputDecoration(labelText: "Semester"),
            ),
            TextField(
              controller: divisionController,
              decoration: InputDecoration(labelText: "Division"),
            ),
            TextField(
              controller: streamController,
              decoration: InputDecoration(labelText: "Stream"),
            ),
            SizedBox(height: 10),
            _image != null
                ? Image.file(_image!, height: 150)
                : Text("No image selected"),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _pickImage, child: Text("Pick Image")),
                SizedBox(width: 10),
                ElevatedButton(onPressed: _uploadImage, child: Text("Upload Image")),
              ],
            ),
            Divider(),
            ElevatedButton(
              onPressed: () {
                if (enrollmentController.text.isNotEmpty) {
                  fetchImage();
                }
              },
              child: Text("Fetch Image"),
            ),
            SizedBox(height: 20),
            if (errorMessage != null)
              Text(errorMessage!, style: TextStyle(color: Colors.red)),
            if (imageUrl.isNotEmpty)
              Image.network(imageUrl, height: 200, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}

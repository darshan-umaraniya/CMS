import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/Student%20Section/session_manager.dart';
import 'session_manager.dart';

class MentorPage extends StatefulWidget {
  final String enrollmentNumber; // Pass enrollment number to fetch specific data

  const MentorPage({super.key, required this.enrollmentNumber});

  @override
  State<MentorPage> createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> {
  Map<String, dynamic>? mentorData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMentorData();
  }

  Future<void> fetchMentorData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Faculty_id_password')
          .where('username', isEqualTo: globalFaculty)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          mentorData = querySnapshot.docs.first.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          mentorData = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching mentor data: $e");
      setState(() {
        mentorData = null;
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "Mentor",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : mentorData == null
          ? const Center(child: Text("No mentor data found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        "assets/image/mentorship.png",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mentorData?["username"] ?? "Unknown",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Text(
                          "Assistant Professor",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const Text(
                          "Current Mentor",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: InfoCard(
                    icon: "assets/image/Profile/phone-call.png",
                    title: "Mobile Number",
                    value: mentorData?["contact"] ?? "No Data",
                  ),
                ),
                Expanded(
                  child: InfoCard(
                    icon: "assets/image/mentor/office-building.png",
                    title: "Office Number",
                    value: mentorData?["setting"] ?? "No Data"
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            InfoCard(
              icon: "assets/image/Profile/mail.png",
              title: "Email",
              value: mentorData?["email"] ?? "No Data",
            ),
            const SizedBox(height: 20),
            InfoCard(
              icon: "assets/image/mentor/networking.png",
              title: "Department",
              value:  mentorData?["department"] ?? "No Data"
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;

  const InfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(

      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Image.asset(
                icon,
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

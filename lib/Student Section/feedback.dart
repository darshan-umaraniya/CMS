import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  final String enrollmentNumber; // Pass the enrollment number

  const FeedbackScreen({super.key, required this.enrollmentNumber});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, Map<String, dynamic>> allFeedback = {};
  bool isLoading = true;
  String? errorMessage;
  int totalSemesters = 6; // Default (for non-B.Tech branches)
  List<String> facultyNames = ["Faculty 1", "Faculty 2", "Faculty 3"];

  /// Fetch student details and feedback
  Future<void> fetchAllFeedback() async {
    setState(() {
      isLoading = true;  // Show loading indicator
      errorMessage = null;
    });

    try {
      DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
          .collection("enrollmentData")
          .doc(widget.enrollmentNumber)
          .get();

      if (!studentSnapshot.exists) {
        setState(() {
          errorMessage = "No data found for this enrollment number.";
          isLoading = false;
        });
        return;
      }

      var data = studentSnapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        setState(() {
          errorMessage = "Invalid student data.";
          isLoading = false;
        });
        return;
      }

      // 🔹 Get the branch and determine the semester count
      String branch = data["branch"] ?? "Other";
      int totalSemesters = (branch.toLowerCase() == "b.tech") ? 8 : 6;

      // 🔹 Get feedback data safely
      var feedbackData = data["feedback"];

      // Check if feedbackData is missing or incorrectly formatted
      if (feedbackData == null || feedbackData is! Map<String, dynamic>) {
        setState(() {
          allFeedback = {}; // Ensure it's an empty map
          isLoading = false;
        });
        return;
      }

      // 🔹 Convert feedbackData to Map<String, Map<String, dynamic>> safely
      setState(() {
        allFeedback = feedbackData.map<String, Map<String, dynamic>>(
                (key, value) => MapEntry(key, value is Map ? Map<String, dynamic>.from(value) : {})
        );
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        errorMessage = "Error fetching feedback: $e";
        isLoading = false;
      });
      print("Error fetching feedback: $e");
    }
  }


  /// Check if feedback has already been submitted
  bool isFeedbackSubmitted(String semester, String faculty) {
    return allFeedback[semester]?[faculty] != null;
  }

  /// Update feedback for a specific semester and faculty
  Future<void> updateFeedback(String semester, String faculty, String newFeedback) async {
    try {
      await _firestore
          .collection("enrollmentData")
          .doc(widget.enrollmentNumber)
          .update({
        "feedback.$semester.$faculty": newFeedback
      });

      setState(() {
        allFeedback.putIfAbsent(semester, () => {});
        allFeedback[semester]![faculty] = newFeedback;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Feedback updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating feedback: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "Feedback",
          style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Text(
          errorMessage!,
          style: const TextStyle(fontSize: 18, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: totalSemesters,
          itemBuilder: (context, index) {
            String semester = "Sem ${index + 1}";

            // 🔹 Check if all faculty feedback is filled
            bool isAllFeedbackSubmitted = facultyNames.every((facultyName) =>
            allFeedback[semester]?[facultyName] != null &&
                allFeedback[semester]![facultyName].toString().trim().isNotEmpty
            );

            return Card(
              color: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      semester,
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Icon(
                      Icons.circle,
                      color: isAllFeedbackSubmitted ? Colors.green : Colors.red, // ✅ Show Green/Red Dot
                      size: 15,
                    ),
                  ],
                ),
                children: facultyNames.map((facultyName) {
                  String feedback = allFeedback[semester]?[facultyName] ?? "No Feedback";
                  return Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      title: Text(facultyName),
                      subtitle: Text("Feedback: $feedback"),
                      onTap: () => _showUpdateDialog(semester, facultyName, feedback),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),

      ),
    );
  }

  /// Show a dialog to update feedback
  void _showUpdateDialog(String semester, String faculty, String currentFeedback) {
    if (isFeedbackSubmitted(semester, faculty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Feedback already submitted, cannot be updated!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final List<String> performanceRatings = ['Excellent', 'Good', 'Average', 'Poor'];
    String? selectedFeedback = performanceRatings.contains(currentFeedback) ? currentFeedback : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Center(
            child: Text(
              "Update Feedback",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
            ),
          ),
          content: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "Select New Feedback",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              prefixIcon: const Icon(Icons.feedback, color: Colors.orangeAccent),
            ),
            value: selectedFeedback,
            items: performanceRatings.map((rating) {
              return DropdownMenuItem(
                value: rating,
                child: Text(rating, style: const TextStyle(fontSize: 16)),
              );
            }).toList(),
            onChanged: (value) {
              selectedFeedback = value!;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedFeedback != null) {
                  updateFeedback(semester, faculty, selectedFeedback!);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Update", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}

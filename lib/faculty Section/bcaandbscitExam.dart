import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faculty2/faculty%20Section/globals.dart';
import 'package:flutter/material.dart';

class BcaAndBSCITExam extends StatefulWidget {
  const BcaAndBSCITExam({super.key});

  @override
  State<BcaAndBSCITExam> createState() => _BcaAndBSCITExamState();
}

class _BcaAndBSCITExamState extends State<BcaAndBSCITExam> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _examCodeController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  /// Fetch data from the `Exam` collection
  Future<List<Map<String, dynamic>>> fetchExams() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Exam')
          .where('stream', isEqualTo: globalBranch)  // Condition: Fetch exams for CSE branch
          .get();
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  /// Delete a document from Firestore with animation
  Future<void> deleteExam(String id) async {
    try {
      await _firestore.collection('Exam').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deleted successfully!')),
      );
      setState(() {}); // Refresh the list
    } catch (e) {
      print('Error deleting document: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete.')),
      );
    }
  }

  /// Add a new exam to the `Exam` collection
  Future<void> addExam() async {
    final String examCode = _examCodeController.text;
    final String subject = _subjectController.text;
    final String date = _dateController.text;
    final String time = _timeController.text;

    if (examCode.isEmpty || subject.isEmpty || date.isEmpty || time.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields!')),
      );
      return;
    }

    try {
      await _firestore.collection('Exam').add({
        'examCode': examCode,
        'subject': subject,
        'date': date,
        'time': time,
        'stream':globalBranch,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exam added successfully!')),
      );
      _examCodeController.clear();
      _subjectController.clear();
      _dateController.clear();
      _timeController.clear();
      setState(() {}); // Refresh the list
    } catch (e) {
      print('Error adding data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add exam.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '$globalBranch Schedule',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Column(
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: _examCodeController,
                          decoration: InputDecoration(
                            labelText: 'Exam Code',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            hintText: 'Enter your exam code',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.code,
                              color: Colors.blueAccent,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        color: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: _subjectController,
                          decoration: InputDecoration(
                            labelText: 'Subject',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            hintText: 'Enter your subject',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.subject,
                              color: Colors.blueAccent,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),

                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        color: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: _dateController,
                          readOnly: true, // Prevent manual input
                          decoration: InputDecoration(
                            labelText: 'Date',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            hintText: 'Select a date',
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: Colors.blueAccent,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),

                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          onTap: () async {
                            // Open the date picker with custom styles
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000), // Earliest allowed date
                              lastDate: DateTime(2100), // Latest allowed date
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData(
                                    primaryColor: Colors.blueAccent, // Header color
                                    hintColor: Colors.blueAccent, // Selected date color
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.blueAccent, // Header text color
                                      onSurface: Colors.black, // Body text color
                                    ),
                                    buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            // If a date is selected, update the controller
                            if (pickedDate != null) {
                              _dateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        color: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: _timeController,
                          readOnly: true, // Prevent manual input
                          decoration: InputDecoration(
                            labelText: 'Time',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            hintText: 'Select a time',
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(
                              Icons.access_time,
                              color: Colors.blueAccent,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          onTap: () async {
                            // Open the time picker with custom styles
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData(
                                    primaryColor: Colors.blueAccent, // Custom header color
                                    hintColor: Colors.blueAccent, // Color of selected time
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.blueAccent, // Header text color
                                      onSurface: Colors.black, // Body text color
                                    ),
                                    buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            // If a time is selected, update the controller
                            if (pickedTime != null) {
                              final String formattedTime =
                                  "${pickedTime.hourOfPeriod}:${pickedTime.minute.toString().padLeft(2, '0')} ${pickedTime.period == DayPeriod.am ? 'AM' : 'PM'}";
                              _timeController.text = formattedTime;
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: addExam,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            elevation: 5
                        ),
                        child: const Text('Add Exam',style: TextStyle(fontSize: 20,color: Colors.white),),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchExams(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No exams found.'));
                    } else {
                      final exams = snapshot.data!;
                      return ListView.builder(
                        itemCount: exams.length,
                        itemBuilder: (context, index) {
                          final exam = exams[index];
                          return ExamCard(exam: exam, onDelete: deleteExam);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Card(
      color: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.orangeAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          filled: true,
          fillColor: Colors.black,
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        ),
      ),
    );
  }

}
class ExamCard extends StatefulWidget {
  final Map<String, dynamic> exam;
  final Function(String) onDelete;

  const ExamCard({Key? key, required this.exam, required this.onDelete})
      : super(key: key);

  @override
  _ExamCardState createState() => _ExamCardState();
}

class _ExamCardState extends State<ExamCard> with SingleTickerProviderStateMixin {
  bool isDeleting = false;
  bool isDialogOpen = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showDeleteConfirmationDialog() {
    setState(() {
      isDialogOpen = true; // Reduce opacity when dialog is open
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Are You Sure You Want to Delete?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isDialogOpen = false; // Restore opacity when closed
                });
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                setState(() {
                  isDialogOpen = false; // Restore opacity
                  isDeleting = true; // Start delete animation
                });

                _controller.forward().then((_) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    widget.onDelete(widget.exam['id'] ?? '');
                  });
                });
              },
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isDialogOpen ? 0.5 : 1.0, // Reduce opacity when dialog is open
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            color: Colors.white,
            elevation: 10,
            shadowColor:  Colors.blueAccent.withOpacity(0.5),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                widget.exam['examCode'] ?? 'No Exam Code',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Subject: ${widget.exam['subject'] ?? 'N/A'}'),
                  Text('Date: ${widget.exam['date'] ?? 'N/A'}'),
                  Text('Time: ${widget.exam['time'] ?? 'N/A'}'),
                  const SizedBox(height: 12.0),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showDeleteConfirmationDialog();
                      },
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text('Delete', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

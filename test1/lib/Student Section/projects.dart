import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Student%20Section/Global.dart';
import 'package:test1/Student%20Section/Homepage.dart';
import 'package:test1/Student%20Section/attendancesem1.dart';
import 'package:test1/Student%20Section/session_manager.dart';
import 'package:intl/intl.dart';



class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  // Controllers for input fields
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _testDateController = TextEditingController();
  final TextEditingController _testTimeController = TextEditingController();
  final TextEditingController _enrollmentController = TextEditingController();

  void _addProject() async {
    if (_formKey.currentState!.validate()) {
      final newProject = {
        'subjectName': _subjectNameController.text,
        'projectName': _projectNameController.text,
        'testDate': _testDateController.text,
        'testTime': _testTimeController.text,
        'enrollment': globalUsername,
        'mark': '-', // Default mark as not available
      };

      try {
        await _firestore.collection('projects').add(newProject);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Project added successfully!')),
        );
        _subjectNameController.clear();
        _projectNameController.clear();
        _testDateController.clear();
        _testTimeController.clear();
        _enrollmentController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add project: $e')),
        );
      }
    }
  }
  String request="";
  Future<void> createDatabase() async {
    try {
      // Create a new collection with documents
      await _firestore.collection('projectRequest').add({
        'enrollment': globalUsername,
        'name': globalname,
        'request': request,
        'yesOrNo': '-',
      });

      print('Data added successfully!');
    } catch (e) {
      print('Error creating database: $e');
    }
  }
  Future<List<Map<String, dynamic>>> fetchFirestoreData() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('projectRequest').get();

      // Map each document to its data
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return [];
    }
  }
  String _currentView = 'completed'; // Tracks the current view ('completed','discription)
  Future openDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                "Enter Project Details",
                style: TextStyle(

                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 20),

              // Subject Name Field
              TextFormField(
                controller: _subjectNameController,
                decoration: InputDecoration(
                  labelText: 'Subject Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.subject, color: Colors.orangeAccent),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subject name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Project Name Field
              TextFormField(
                controller: _projectNameController,
                decoration: InputDecoration(
                  labelText: 'Project Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.assignment, color: Colors.orangeAccent),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter project name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Pick Date & Time Button
              ElevatedButton.icon(
                onPressed: () async {
                  // Show Date Picker
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (selectedDate != null) {
                    // Show Time Picker after Date is selected
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (selectedTime != null) {
                      // Convert TimeOfDay to DateTime for formatting
                      final now = DateTime.now();
                      final selectedDateTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );

                      // Format Date and Time
                      final formattedDate =
                      DateFormat('yyyy-MM-dd').format(selectedDate);
                      final formattedTime =
                      DateFormat('hh:mm a').format(selectedDateTime);

                      _testDateController.text = formattedDate;
                      _testTimeController.text = formattedTime;
                    }
                  }
                },
                icon: Icon(Icons.calendar_today, color: Colors.white),
                label: Text('Pick Date & Time'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Add Project Button
              OutlinedButton.icon(
                onPressed: () {
                  _addProject();
                },
                icon: Icon(Icons.add, color: Colors.orangeAccent),
                label: Text("Add Project"),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.orangeAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  Future showRequestSend() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Request of $request is send.",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Robot',fontSize: 20),)
            ],
          ),
        ),
      ),
    ),
  );
  Widget _buildBody() {
    if (_currentView == 'completed') {
      return _buildCompletedProjectsView();
    } else if(_currentView == 'discription'){
      return _buildTipsView();
    }
    else {
      return _requests();
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: ()async => _addProject,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Text(
            "Projects",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Robot',
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Buttons for switching views
              Container(
                width: screenWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 4,backgroundColor: Colors.orangeAccent
                        ),
                        onPressed: () => setState(() => _currentView = 'discription'),
                        child: Text("Discription",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 4,backgroundColor: Colors.orangeAccent
                        ),
                        onPressed: () => setState(() => _currentView = 'completed'),
                        child: Text("Completed",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 4,backgroundColor: Colors.orangeAccent
                        ),
                        onPressed: () => setState(() => _currentView = 'request'),
                        child: Text("Requested",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _buildBody(), // Dynamically build the body based on the view
              ),
            ],
          ),
        ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              openDialog();
            },
            label: const Text(
              'Add New Project',
              style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.orangeAccent, // Customize the color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Add custom border shape if desired
            ),
          ),

      ),
    );
  }
  //Discription Page
  Widget _buildTipsView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Projects Discription:\n\n",
                  style: TextStyle(fontSize: 16,),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            Card(
              color: Colors.white,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between Text and Icon
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "1. Food Delivery System.\n",
                      style: TextStyle(fontSize: 16,),
                      textAlign: TextAlign.left,
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          request='Food Delivery System';

                          createDatabase();
                          showRequestSend();
                        },
                        child: Icon(Icons.send,color: Colors.orangeAccent,)
                    )
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between Text and Icon
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "2. Library Management.\n",
                      style: TextStyle(fontSize: 16,),
                      textAlign: TextAlign.left,
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          request='Library Management';
                          createDatabase();
                          showRequestSend();
                        },
                        child: Icon(Icons.send,color: Colors.orangeAccent,)
                    )
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between Text and Icon
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "3. Online Web Builder.\n",
                      style: TextStyle(fontSize: 16,),
                      textAlign: TextAlign.left,
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          request='Online Web Builder';
                          createDatabase();
                          showRequestSend();
                        },
                        child: Icon(Icons.send,color: Colors.orangeAccent,)
                    )
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between Text and Icon
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "4. Admission Management System.\n",
                      style: TextStyle(fontSize: 16,),
                      textAlign: TextAlign.left,
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          request='Admission Management System';
                          createDatabase();
                          showRequestSend();
                        },
                        child: Icon(Icons.send,color: Colors.orangeAccent,)
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //Completed page
  Widget _buildCompletedProjectsView() {
    return FutureBuilder<QuerySnapshot>(
      future: _firestore
          .collection('projects')
      .where('enrollment',isEqualTo: globalUsername)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No completed projects found."));
        }

        final projects = snapshot.data!.docs;

        return ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index].data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white,
                shadowColor: Colors.orange,
                elevation: 8, // Increased elevation for a more pronounced shadow
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.orangeAccent,width: 1.5),
                  borderRadius: BorderRadius.circular(20), // Rounded corners for a smoother look
                ),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15), // Adjusted margin for more spacing
                child: Padding(
                  padding: const EdgeInsets.all(15.0), // Increased padding for a cleaner layout
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject Name
                      Center(
                        child: Text(
                          "Name: ${project['subjectName'] ?? 'N/A'}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                            fontSize: 25,
                            letterSpacing: 1.2, // Slightly more spaced letters for elegance
                          ),
                        ),
                      ),
                      Center(child: Divider(color: Colors.orangeAccent,thickness: 3,)),
                      SizedBox(height: 10), // Spacing between rows

                      // Project Name
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.orangeAccent,
                            size: 30, // Larger icon for better visual impact
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Subject Name: ${project['projectName'] ?? 'N/A'}",
                            style: TextStyle(fontSize: 20, color: Colors.black87), // Improved contrast for text
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Test Date
                      Row(
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            color: Colors.orangeAccent,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Test Date: ${project['testDate'] ?? 'N/A'}",
                            style: TextStyle(fontSize: 20, color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Test Time
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_filled_sharp,
                            color: Colors.orangeAccent,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Test Time: ${project['testTime'] ?? 'N/A'}",
                            style: TextStyle(fontSize: 20, color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Enrollment
                      Row(
                        children: [
                          Icon(
                            Icons.numbers,
                            color: Colors.orangeAccent,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Enrollment: $globalUsername",
                            style: TextStyle(fontSize: 20, color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Mark
                      Row(
                        children: [
                          Icon(
                            Icons.mark_chat_unread_outlined,
                            color: Colors.orangeAccent,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Mark: ${project['mark'] ?? 'Not Marking Yet'}",
                            style: TextStyle(fontSize: 20, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );

          },
        );
      },
    );
  }
  Future<List<Map<String, dynamic>>> fetchFirestore() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('projectRequest').where("enrollment",isEqualTo: globalUserName).get();

      // Map each document to its data
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return [];
    }
  }
//Request page
  Widget _requests(){
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchFirestoreData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Data Found'));
        } else {
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text("Project Name: ${item['name'] ?? 'N/A'}",
                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orangeAccent,fontSize: 20),), // Replace `fieldName` with actual field name
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Project Name: ${item['request'] ?? 'N/A'}",
                          style: TextStyle(fontFamily: 'Robot',fontSize: 20),),
                        Text("Faculty Respons: ${item['yesOrNo'] ?? 'N/A'}",
                          style: TextStyle(fontFamily: 'Robot',fontSize: 20),),
                      ],
                    ), // Replace `anotherField`
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financedepartment/admin/MentorData.dart';
import 'package:financedepartment/admin/global.dart';
import 'package:flutter/material.dart';
class MentorListPage extends StatefulWidget {
  const MentorListPage({super.key});

  @override
  State<MentorListPage> createState() => _MentorListPageState();
}

Widget targetPage = MentorListPage();

PageRouteBuilder _createPageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0); // Start position (off-screen)
      var end = Offset.zero; // End position (center of screen)
      var curve = Curves.ease; // Define transition curve
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
class _MentorListPageState extends State<MentorListPage> {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text(
          "Mentor Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection("Faculty_id_password").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No students found in the database.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }

              final Faculty = snapshot.data!.docs;

              return ListView.builder(
                itemCount: Faculty.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context,index){
                  final FacultyData = Faculty[index].data() as Map<String, dynamic>;
                  final FacultyName = FacultyData["username"] ?? "Unknown name";
                  final FacultyID = FacultyData["userId"] ?? "Unknown ID";
                   return InkWell(
                     onTap: () {
                       print(FacultyID);
                       globalFacultyID = FacultyID;
                       targetPage = MentorData();
                       print(FacultyID);
                       Navigator.push(context, _createPageRoute(targetPage),);
                     },
                     child: Card(
                       elevation: 8,
                       color: Colors.white,
                       shadowColor: Colors.blueAccent.withOpacity(0.5), // More vibrant shadow
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(20),
                       ),
                       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                       child: ListTile(
                         contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                         title: Column(

                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               "USER ID :- $FacultyID ",
                               style: TextStyle(
                                 fontSize: 22,
                                 fontWeight: FontWeight.bold,
                                 letterSpacing: 1.2, // Spacing makes it more readable
                               ),
                             ),
                             Text(
                               "User Name :- $FacultyName",
                               style: TextStyle(
                                 fontSize: 22,
                                 fontWeight: FontWeight.bold,
                                 letterSpacing: 1.2, // Spacing makes it more readable
                               ),
                             ),
                           ],
                         ),
                         leading: const Icon(Icons.person, color: Colors.orangeAccent, size: 30), // Icon for aesthetics
                         trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20), // Subtle navigation hint
                       ),
                     ),
                   );
                }
              );
            },
        ),
      )
    );
  }
}

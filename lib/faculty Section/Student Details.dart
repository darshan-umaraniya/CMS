
import 'package:faculty2/faculty%20Section/List_of_Student.dart';
import 'package:faculty2/faculty%20Section/globals.dart';
import 'package:flutter/material.dart';
class StudentDEtails extends StatefulWidget {
  const StudentDEtails({super.key});

  @override
  State<StudentDEtails> createState() => _StudentDEtailsState();
}

late AnimationController _controller;
late Animation<double> _animation;
double _scale = 1.0;

Widget targetPage = StudentDEtails();

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

class _StudentDEtailsState extends State<StudentDEtails> {
  @override

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text("Student Details",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 30),),
        actions: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0,right: 10),
            child: Container(color: Colors.white,
              child: ClipOval(child: Image.asset("assets/image/Profile/IMG-20241128-WA0003-removebg-preview.png", height: 80, width: 50,fit: BoxFit.cover,),),
            ),
          )
        ],
      ),
      body: Container(
        width: screenWidth,
        child: Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: (
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GridView.builder(
                      shrinkWrap: true, // Ensures it takes only the required space
                      physics: NeverScrollableScrollPhysics(), // Prevents internal scrolling if used inside another scrollable widget
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 columns
                        crossAxisSpacing: 16, // Horizontal spacing between items
                        mainAxisSpacing: 16, // Vertical spacing between items
                        childAspectRatio: 1.5, // Adjust the aspect ratio for better layout
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final branches = ["BCA", "MCA", "BSC-IT", "BBA"];
                        return GestureDetector(
                          onTapDown: (_) => _controller.forward(), // Press Animation
                          onTapUp: (_) => _controller.reverse(), // Release Animation
                          onTap: () {
                            targetPage = ListOfStudent();
                            globalBranch = branches[index];
                            Navigator.push(context, _createPageRoute(targetPage));
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            transform: Matrix4.diagonal3Values(_scale, _scale, 1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white.withOpacity(0.2), // Glassmorphism effect
                              border: Border.all(color: Colors.black, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(3, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.school, color: Colors.orange, size: 50), // Added icon
                                  SizedBox(width: 10), // Space between icon and text
                                  Text(
                                    branches[index],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}

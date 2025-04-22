import 'package:faculty2/faculty%20Section/bcaandbscitExam.dart';
import 'package:faculty2/faculty%20Section/globals.dart';
import 'package:flutter/material.dart';
class finalExam extends StatefulWidget {
  const finalExam({super.key});

  @override
  State<finalExam> createState() => _finalExamState();
}

late AnimationController _controller;
late Animation<double> _animation;
double _scale = 1.0;

Widget targetPage = finalExam();

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

class _finalExamState extends State<finalExam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text(
          "$globalExamtyp",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,

            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: (
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text("Click on button to edit timetable",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'PLayfaair',fontSize: 25,),),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    child: Text(
                      "List of Stream",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,

                      ),
                    ),
                  ),
                ),
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
                        targetPage = BcaAndBSCITExam();
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
    );
  }
}

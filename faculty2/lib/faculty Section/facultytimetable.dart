import 'package:faculty2/faculty%20Section/bcatimetable.dart';
import 'package:faculty2/faculty%20Section/globals.dart';
import 'package:flutter/material.dart';
class facultyTimetable extends StatefulWidget {
  const facultyTimetable({super.key});

  @override
  State<facultyTimetable> createState() => _facultyTimetableState();
}

Widget targetPage = facultyTimetable();

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

class _facultyTimetableState extends State<facultyTimetable> {
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
        title: Text("Timetable",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30,),),
      ),
      body: Container(
        width: screenWidth,
        child: Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: (
              Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("Click on button to edit timetable",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'PLayfaair',fontSize: 25,),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "List of Stream",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        targetPage = bcatimetable();
                        globalTimetable="BCA";
                        Navigator.push(context, _createPageRoute(targetPage),);
                      },
                      child: Card(
                        color: Colors.white,
                       elevation: 8,
                        shadowColor: Colors.blueAccent.withOpacity(0.5),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "BCA",
                                  style: TextStyle(

                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        targetPage = bcatimetable();
                        globalTimetable="BSC-IT";
                        Navigator.push(context, _createPageRoute(targetPage),);
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 8,
                        shadowColor: Colors.blueAccent.withOpacity(0.5),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "BSC-IT",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        targetPage = bcatimetable();
                        globalTimetable="MCA";
                        Navigator.push(context, _createPageRoute(targetPage),);                  },
                      child: Card(color: Colors.white,
                       elevation: 8,
                        shadowColor: Colors.blueAccent.withOpacity(0.5),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "MCA",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        targetPage = bcatimetable();
                        globalTimetable="BBA";
                        Navigator.push(context, _createPageRoute(targetPage),);                  },
                      child: Card(color: Colors.white,
                       elevation: 8,
                        shadowColor: Colors.blueAccent.withOpacity(0.5),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "BBA",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        ),
      )
    );
  }
}

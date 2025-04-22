import 'package:financedepartment/admin/StudentIDPassword.dart';
import 'package:financedepartment/admin/global.dart';
import 'package:flutter/material.dart';
class Listofstrem extends StatefulWidget {
  const Listofstrem({super.key});

  @override
  State<Listofstrem> createState() => _ListofstremState();
}
Widget targetPage = Listofstrem();

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
class _ListofstremState extends State<Listofstrem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("List of Stream",
        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
        backgroundColor: Colors.orangeAccent,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "List of Streams",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          targetPage = BcaStudentIDPassword();
                          globalBranch="BCA";
                          Navigator.push(context, _createPageRoute(targetPage),);
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 2,color: Colors.orangeAccent),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "BCA",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black87,),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          targetPage = BcaStudentIDPassword();
                          globalBranch="MCA";
                          Navigator.push(context, _createPageRoute(targetPage),);
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 2,color: Colors.orangeAccent),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "MCA",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black87,),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          targetPage = BcaStudentIDPassword();
                          globalBranch="BSC-IT";
                          Navigator.push(context, _createPageRoute(targetPage),);
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 2,color: Colors.orangeAccent),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "BCA",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black87,),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          targetPage = BcaStudentIDPassword();
                          globalBranch="BBA";
                          Navigator.push(context, _createPageRoute(targetPage),);
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 2,color: Colors.orangeAccent),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "BBA",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black87,),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

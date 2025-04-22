import 'package:financedepartment/admin/ListOfStrem.dart';
import 'package:financedepartment/admin/Login.dart';
import 'package:financedepartment/admin/StudentIDPassword.dart';
import 'package:financedepartment/admin/asignidpass.dart';
import 'package:financedepartment/admin/certificate.dart';
import 'package:financedepartment/admin/feespayment.dart';
import 'package:financedepartment/admin/financepage_transportation.dart';
import 'package:financedepartment/admin/global.dart';
import 'package:financedepartment/admin/mentorDetails.dart';
import 'package:flutter/material.dart';

class financePage extends StatefulWidget {
  const financePage({super.key});

  @override
  State<financePage> createState() => _financePageState();
}

Widget targetPage = financePage();

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

class _financePageState extends State<financePage> {
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure $globalUsername want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel logout
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),));
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        automaticallyImplyLeading: false,
        title: Text(
          "Finance Section",
          style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: _logout, // Click profile image to logout
              child: Container(
                color: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    "assets/image/Profile/IMG-20241128-WA0003-removebg-preview.png",
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(

          child: Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        buildCard(
                          context,
                          title: "Student ID, Password",
                          imagePath: "assets/image/finance/id.png",
                          onTap: () {
                            targetPage = BcaStudentIDPassword();
                            Navigator.push(context, _createPageRoute(targetPage));
                          },
                        ),
                        buildCard(
                          context,
                          title: "Faculty ID, Password",
                          imagePath: "assets/image/finance/id.png",
                          onTap: () {
                            targetPage = AssignIdPass();
                            Navigator.push(context, _createPageRoute(targetPage));
                          },
                        ),
                        buildCard(
                          context,
                          title: "Fee Payment",
                          imagePath: "assets/image/fees.png",
                          onTap: () {
                            targetPage = FeePayment();
                            Navigator.push(context, _createPageRoute(targetPage));
                          },
                        ),
                        buildCard(
                          context,
                          title: "Certificate \n Request",
                          imagePath: "assets/image/worksheet.png",
                          onTap: () {
                            targetPage = Certificate();
                            Navigator.push(context, _createPageRoute(targetPage));
                          },
                        ),
                        buildCard(
                          context,
                          title: "Transportation",
                          imagePath: "assets/image/vehicles.png",
                          onTap: () {
                            targetPage = Transportation();
                            Navigator.push(context, _createPageRoute(targetPage));
                          },
                        ),
                        buildCard(
                          context,
                          title: "Mentor Details",
                          imagePath: "assets/image/list.png",
                          onTap: () {
                            targetPage = MentorListPage();
                            Navigator.push(context, _createPageRoute(targetPage));
                          },
                        ),
                      ],
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

  Widget buildCard(BuildContext context, {required String title, required String imagePath, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

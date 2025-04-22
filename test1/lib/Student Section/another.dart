// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_demo/Student%20Section/Homepage.dart';
// import 'package:flutter_demo/Student%20Section/attendancesem1.dart';
// import 'package:flutter_demo/Student%20Section/studentFinalExam.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Attendance(),
//     );
//   }
// }
// class Attendance extends StatefulWidget {
//   const Attendance({super.key});
//
//   @override
//   State<Attendance> createState() => _AttendanceState();
// }
//
// class _AttendanceState extends State<Attendance> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: Text(
//           "Attendance",
//           style: TextStyle(
//             color: Colors.white,
//             fontFamily: 'Playfair',
//             fontWeight: FontWeight.bold,
//             fontSize: 30,
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//         ),
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(16.0),
//         children: [
//           Text(
//             "Select Semester",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.orangeAccent,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 20),
//           buildProgressCard("Sem 1", 0.7),
//           buildProgressCard("Sem 2", 0.5),
//           buildProgressCard("Sem 3", 0.6),
//           buildProgressCard("Sem 4", 0.8),
//           buildProgressCard("Sem 5", 0.9),
//         ],
//       ),
//     );
//   }
//
//   // Progress Card Widget
//   Widget buildProgressCard(String semName, double progressValue) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Card(
//         elevation: 8,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AttendancceSem1()),
//             );
//           },
//           child: Container(
//             padding: EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 CircularProgressIndicator(
//                   value: progressValue,
//                   strokeWidth: 6,
//                   color: Colors.orangeAccent,
//                   backgroundColor: Colors.grey[300],
//                 ),
//                 SizedBox(width: 20),
//                 Text(
//                   semName,
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.orangeAccent,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//

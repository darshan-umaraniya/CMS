import 'package:faculty2/faculty%20Section/Login.dart';
import 'package:faculty2/faculty%20Section/StudentDAta.dart';
import 'package:faculty2/faculty%20Section/adminhomepage.dart';
import 'package:faculty2/faculty%20Section/temp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  //  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Robot',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),      home: Login()
    );
  }
}


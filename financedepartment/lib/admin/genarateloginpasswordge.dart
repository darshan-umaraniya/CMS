import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GenerateLoginPasswordPage extends StatefulWidget {
  const GenerateLoginPasswordPage({super.key});

  @override
  State<GenerateLoginPasswordPage> createState() =>
      _GenerateLoginPasswordPageState();
}

class _GenerateLoginPasswordPageState extends State<GenerateLoginPasswordPage> {
  TextEditingController numberController = TextEditingController();
  List<String> generatedPasswords = [];
  int enrollmentStart = 22030401000; // Default starting enrollment number

  // Fetch the last enrollment number from Firestore
  Future<int> fetchLastEnrollmentNumber() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('enrollmentData')
          .orderBy('enrollmentNumber', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        int lastEnrollment = int.parse(snapshot.docs.first.id);
        return lastEnrollment + 1; // Start from the next number
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching last enrollment number: $e')),
      );
    }
    return enrollmentStart; // Default starting enrollment number if none exists
  }

  // Generate a single 6-digit random password
  String generateSixDigitPassword() {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();

    return List.generate(6, (index) {
      return chars[random.nextInt(chars.length)];
    }).join();
  }

  // Generate passwords with enrollment numbers
  Future<void> generatePasswordsWithEnrollment(int count) async {
    int startEnrollment = await fetchLastEnrollmentNumber();
    setState(() {
      generatedPasswords = List.generate(count, (index) {
        String enrollmentNumber = (startEnrollment + index).toString();
        String password = generateSixDigitPassword();
        return '$enrollmentNumber: $password';
      });
    });
  }

  // Save generated IDs and passwords to Firestore
  Future<void> saveGeneratedPasswordsToFirestore(List<String> passwords) async {
    try {
      for (var password in passwords) {
        // Split enrollment number and password
        List<String> parts = password.split(':');
        String enrollmentNumber = parts[0].trim();
        String generatedPassword = parts[1].trim();

        // Save data to Firestore with enrollmentNumber as document ID
        await FirebaseFirestore.instance
            .collection('enrollmentData')
            .doc(enrollmentNumber)
            .set({
          'enrollmentNumber': enrollmentNumber,
          'password': generatedPassword,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Generated passwords saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving passwords: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "Generate Login Password",
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Playfaair',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Enter number of students to Generate Password",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'Playfaair'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter number of passwords to generate',
                border: OutlineInputBorder(),hintStyle: TextStyle(fontFamily: 'Playfaair')
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                int count = int.tryParse(numberController.text) ?? 0;
                if (count > 0) {
                  await generatePasswordsWithEnrollment(count);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid number!')),
                  );
                }
              },
              child: Text("Generate Passwords",style: TextStyle(fontFamily: 'Playfaair',fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 16),
            Text(
              "Generated Passwords:",
              style: TextStyle(fontSize: 20,fontFamily: 'Playfaair', fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: generatedPasswords.length,
                itemBuilder: (context, index) {
                  return SelectableText(
                    generatedPasswords[index],
                    style: TextStyle(fontSize: 20,fontFamily: 'Playfaair'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (generatedPasswords.isNotEmpty) {
                  saveGeneratedPasswordsToFirestore(generatedPasswords);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No passwords generated yet!')),
                  );
                }
              },
              child: Text("Save Passwords",style: TextStyle(fontFamily: 'Playfaair',fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}

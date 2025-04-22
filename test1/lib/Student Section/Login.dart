import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Student%20Section/Global.dart';
import 'package:test1/Student%20Section/Homepage.dart';
import 'package:test1/Student%20Section/session_manager.dart'; // Import SessionManager
import 'Global.dart';
class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}
class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final CollectionReference facultyCollection =
  FirebaseFirestore.instance.collection('enrollmentData');
  bool _isLoading = false;
  bool _isVisible = false;
  Widget targetPage = Homepage();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 100), () {
      setState(() {
        _isVisible = true;
      });
    });
  }
  bool _verifyPassword(String inputPassword, String storedHashedPassword) {
    return inputPassword == storedHashedPassword;
  }
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  Future<void> _LoginUser() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Get user credentials from session manager
        final String username = sessionManager.username.trim();
        final String password = sessionManager.password.trim();

        if (username.isEmpty || password.isEmpty) {
          _showErrorDialog('Username and password cannot be empty');
          return;
        }

        QuerySnapshot querySnapshot = await facultyCollection
            .where('enrollmentNumber', isEqualTo: username)
            .get();

        if (querySnapshot.docs.isEmpty) {
          _showErrorDialog('Invalid username or password');
          return;
        }

        final userDoc = querySnapshot.docs.first;
        final String storedHashedPassword = userDoc['password'];

        if (!_verifyPassword(password, storedHashedPassword)) {
          _showErrorDialog('Invalid username or password');
          return;
        }
          globalPassword=password;
          globalUsername=username;
        // Authentication successful, navigate to the homepage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );

      } catch (e) {
        _showErrorDialog('An error occurred. Please try again later.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orangeAccent,
        title: Center(
          child: Text(
            "Log In",
            style: TextStyle(
              fontFamily: 'Robot',
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: Expanded(
          child: ListView(
            children: [
              AnimatedOpacity(
                duration: Duration(seconds: 5),
                opacity: _isVisible ? 1.0 : 0.0,
                child: Column(
                  children: [
                    SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/image/Profile/IMG-20241128-WA0003-removebg-preview.png",
                        height: 250,
                        width: 250,
                      ),
                    ),
                    SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Welcome to Darshan University",
                        style: TextStyle(fontSize: 25, fontFamily: 'Robot'),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: sessionManager.usernameController, // Use global controller
                              decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(width: 2, color: Colors.grey),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a username';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: sessionManager.passwordController, // Use global controller
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.grey, width: 2),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _isObscure,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 5, backgroundColor: Colors.white),
                              onPressed: _LoginUser,
                              child: Text(
                                'Login',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
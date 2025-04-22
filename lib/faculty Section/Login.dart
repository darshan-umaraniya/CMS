import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faculty2/faculty%20Section/adminhomepage.dart';
import 'package:faculty2/faculty%20Section/globals.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>  {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final CollectionReference facultyCollection =
  FirebaseFirestore.instance.collection('Faculty_id_password');
  bool _isLoading = false;
  bool _isVisible = false;
  // Define targetPage as a Widget variable that can be dynamically updated
  Widget targetPage = adminhome(); // Default to Homepage
  @override
  void initState() {
    super.initState();
    // Trigger animation on first load
    Future.delayed(Duration(microseconds: 100), () {
      setState(() {
        _isVisible = true;
      });
    });
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
      // Get user input
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      // Fetch user data from Firestore
      QuerySnapshot querySnapshot = await facultyCollection
          .where('username', isEqualTo: username)
          .limit(1) // Optimize query
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final storedPassword = userDoc['password']; // Fetch stored password

        // Validate password
        if (password == storedPassword) {  // Replace with `_verifyPassword()` if using hashed passwords
          print("Login successful!");
          globalUsername=username;
          // Navigate to admin home only if login is valid
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => adminhome()),
          );
          return;
        }
      }

      // If login fails, show error
      _showErrorDialog('Invalid username or password');
    } catch (e) {
      print('Error during Login: $e');
      _showErrorDialog('An error occurred. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  bool _verifyPassword(String inputPassword, String storedHashedPassword) {
    return inputPassword == storedHashedPassword; // Update this if using bcrypt
  }
  // Helper function to create the page route dynamically
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
            "Log In Faculty",
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
        child: Expanded(
          child: ListView(
            children: [
              AnimatedOpacity(
                duration: Duration(seconds: 5), // 1-second fade-in effect
                opacity: _isVisible ? 1.0 : 0.0, // Toggle visibility
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
                              controller: _usernameController,
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
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
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
                                      _isObscure = !_isObscure; // Toggle password visibility
                                    });
                                  },
                                ),
                              ),
                              obscureText: _isObscure, // Hide/show password
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
                                  elevation: 5,
                                  backgroundColor: Colors.white
                              ),
                              onPressed: _LoginUser, // Login button redirects to Homepage
                              child: Text('Login',style: TextStyle(fontWeight: FontWeight.bold),),
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

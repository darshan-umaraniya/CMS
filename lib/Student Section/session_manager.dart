import 'package:flutter/material.dart';

class SessionManager {
  // Private static instance
  static final SessionManager _instance = SessionManager._internal();

  // Private named constructor
  SessionManager._internal();

  // Factory constructor to return the singleton instance
  factory SessionManager() {
    return _instance;
  }

  // Controllers for username and password
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Getters to retrieve trimmed values
  String get username => usernameController.text.trim();
  String get password => passwordController.text.trim();

  // Clear method to reset fields
  void clear() {
    usernameController.clear();
    passwordController.clear();
  }
}

// Global variables
String globalPassword = '';
String globalUsername = '';
String globalname = '';
String globalFaculty = '';
String globalBranch = '';
String globalSemester = '';
String globalDivision = '';
String globalImage = '';

// Singleton instance (no need to re-initialize)
final SessionManager sessionManager = SessionManager();

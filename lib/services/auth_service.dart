import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Validate email format using regex
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }

    // Regex for proper email format
    // This checks for: username@domain.extension
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Validate password length (minimum 6 characters)
  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Register with email and password and validate using helper functions
  Future<UserCredential> register(String email, String password) {
    // Validate before attempting registration
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);

    if (emailError != null) {
      throw Exception(emailError);
    }
    if (passwordError != null) {
      throw Exception(passwordError);
    }

    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign in with email and password and validate using helper functions
  Future<UserCredential> signIn(String email, String password) {
    // Validate before attempting sign in
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);

    if (emailError != null) {
      throw Exception(emailError);
    }
    if (passwordError != null) {
      throw Exception(passwordError);
    }

    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() {
    return _auth.signOut();
  }

  // Change password for current user and validate using helper function
  Future<void> changePassword(String newPassword) async {
    // Validate new password
    final passwordError = validatePassword(newPassword);
    if (passwordError != null) {
      throw Exception(passwordError);
    }

    await _auth.currentUser!.updatePassword(newPassword);
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}
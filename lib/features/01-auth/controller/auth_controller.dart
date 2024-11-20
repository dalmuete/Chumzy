import 'package:chumzy/core/widgets/loading_screen.dart';
import 'package:chumzy/features/01-auth/views/login_screen.dart';
import 'package:chumzy/features/01-auth/views/verification_screen.dart';
import 'package:chumzy/features/02-home/views/screens_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _email = '';
  String _password = '';
  bool _isLoading = false;

//   // Getters
//   String get email => _email;
//   String get password => _password;
//   bool get isLoading => _isLoading;

  //Create user - sign up
  Future<User?> createUserAccount(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      notifyListeners();
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'An account already exists with this email address.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password sign-up is not enabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later.';
          break;
        case 'user-token-expired':
          errorMessage = 'Your session has expired. Please sign in again.';
          break;
        case 'network-request-failed':
          errorMessage =
              'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage = 'An unknown error occurred. Please try again.';
          break;
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      return null;
    }
  }

  //Submit sign - up form
  Future<void> submitSignUpForm(GlobalKey<FormState> formKey,
      BuildContext context, String email, String password, String name) async {
    if (formKey.currentState!.validate()) {
      loadingScreen(context);

      User? user = await createUserAccount(context, email, password);

      await storeUserPersonalInfo(user!, name);

      Navigator.of(context).pop();

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Account creation failed. Please try again.')),
        );
        return;
      }

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print("Verification email has been sent.");
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            email: email,
          ),
        ),
      );

      notifyListeners();
    }
  }

  //Sign-up form validate
  String? validateSignUpForm(String value, String inputType,
      {String? password}) {
    String input = value.trim();

    if (input.isEmpty) {
      return "$inputType is required.";
    } else if (inputType == 'Email' && !EmailValidator.validate(input)) {
      return "$inputType provided is not valid.";
    } else if (inputType == 'Password' && input.length < 7) {
      return "$inputType should have at least 7 characters.";
    } else if (inputType == 'Confirm Password' && input != password) {
      return "Password and Confirm Password do not match.";
    }

    return null;
  }

  //show loading screen
  void loadingScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return LoadingScreen();
      },
    );
  }

  //user logout
  Future<void> logout(BuildContext context) async {
    loadingScreen(context);
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
    notifyListeners();
  }

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    loadingScreen(context); // Show loading screen

    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pop(); // Dismiss loading screen

      final User? user = userCredential.user;
      if (user != null) {
        if (user.emailVerified) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ScreensHandler(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => VerificationScreen(
                email: user.email!,
              ),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();

      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
        case 'invalid-credential':
          errorMessage = 'The password/email is incorrect or not set.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later.';
          break;
        case 'network-request-failed':
          errorMessage =
              'Network error. Please check your internet connection.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password sign-in is not enabled.';
          break;
        default:
          errorMessage = 'An unknown error occurred.';
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close loading screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  //Sign-in with google
  Future<void> signInWithGoogle(BuildContext context) async {
    loadingScreen(context);
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Sign out before signing in to show the account selection dialog
    await googleSignIn.signOut();
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        Navigator.pop(context);
        return;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      await storeUserPersonalInfo(user!, user.displayName!);

      Navigator.of(context).pop();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ScreensHandler(),
        ),
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        Navigator.of(context).pop();

        String errorMessage;
        switch (e.code) {
          case 'account-exists-with-different-credential':
            errorMessage =
                'Account exists with a different credential. Please sign in using the existing provider.';
            break;
          case 'invalid-credential':
            errorMessage = 'The credential is malformed or has expired.';
            break;
          case 'user-not-found':
            errorMessage = 'No user found for the given email address.';
            break;
          case 'wrong-password':
            errorMessage = 'Invalid password for the given email address.';
            break;
          default:
            errorMessage = 'An unknown error occurred: ${e.message}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } else {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during Google sign-in: $e')),
        );
      }
      return;
    }
  }

  //Storing sign up information to firebase
  Future<void> storeUserPersonalInfo(User user, String name) async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      'email': user.email,
      'name': name,
      'createdAt': DateTime.now(),
    });
  }

  //Forgot password function
  Future<void> resetPassword(BuildContext context, String email) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("No user found for the given email address.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: ${e.message}")),
        );
        print("An error occurred: ${e.message}");
      }
    }
  }

  //Get current user
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  //Get current user information
  Future<String?> getUserName() async {
    try {
      final userId = getCurrentUser()!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final data = userDoc.data() as Map<String, dynamic>?; // Cast to Map
      return data?['name'] as String?; // Safely access the 'name' field
    } catch (e) {
      print("Error fetching name: $e");
      return null; // Handle errors gracefully
    }
  }

  Future<String?> getUserEmail() async {
    try {
      final userId = getCurrentUser()!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final data = userDoc.data() as Map<String, dynamic>?; // Cast to Map
      return data?['email'] as String?; // Safely access the 'email' field
    } catch (e) {
      print("Error fetching email: $e");
      return null; // Handle errors gracefully
    }
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }
}

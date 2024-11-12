import 'package:chumzy/core/widgets/loading_screen.dart';
import 'package:chumzy/features/home/views/home_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _email = '';
  String _password = '';
  bool _isLoading = false;

  // Getters
  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;

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
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password sign-up is not enabled.';
          break;
        case 'weak-password':
          errorMessage =
              'The password is too weak. Please choose a stronger password.';
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
      return null;
    }
  }

  //Submit sign - up form
  Future<void> submitSignUpForm(GlobalKey<FormState> formKey,
      BuildContext context, String email, String password) async {
    if (formKey.currentState!.validate()) {
      loadingScreen(context);

      User? user = await createUserAccount(context, email, password);

      Navigator.of(context).pop();

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Account creation failed. Please try again.')),
        );
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: user),
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
    Navigator.pushNamed(context, '/login');
    notifyListeners();
  }

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    loadingScreen(context);

    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pop();

      final User? user = userCredential.user;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: user!),
        ),
      );
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
        case 'INVALID_LOGIN_CREDENTIALS':
        case 'invalid-credential':
          errorMessage = 'The password/email is incorrect or not set.';
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
        case 'operation-not-allowed':
          errorMessage = 'Email/password sign-in is not enabled.';
          break;
        default:
          errorMessage = 'An unknown error occurred.';
          break;
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

    notifyListeners();
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
        return;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.of(context).pop();

      final User? user = userCredential.user;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: user!),
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
          case 'operation-not-allowed':
            errorMessage =
                'The account type corresponding to the credential is not enabled. Enable it in Firebase Console.';
            break;
          case 'user-disabled':
            errorMessage =
                'The user corresponding to the credential has been disabled.';
            break;
          case 'user-not-found':
            errorMessage = 'No user found for the given email address.';
            break;
          case 'wrong-password':
            errorMessage = 'Invalid password for the given email address.';
            break;
          case 'invalid-verification-code':
            errorMessage = 'The verification code is not valid.';
            break;
          case 'invalid-verification-id':
            errorMessage = 'The verification ID is invalid.';
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

  // Method to update email and password
  void updateEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }

  // Future<void> openGmailApp() async {
  //   final Uri gmailUri = Uri(
  //     scheme: 'intent',
  //     path: 'com.google.android.gm',
  //   );

  //   if (await canLaunchUrl(gmailUri)) {
  //     await launchUrl(gmailUri);
  //   } else {
  //     throw 'Could not open Gmail app';
  //   }
  // }

  Future<void> openMailApp() async {
    final Uri gmailUri = Uri(
      scheme: 'intent',
      path: '',
      queryParameters: {'package': 'com.google.android.gm'},
    );

    if (await canLaunchUrl(gmailUri)) {
      await launchUrl(gmailUri);
    } else {
      print('Could not open Gmail app');
    }
  }

  Future<void> testLaunch() async {
    launchUrl(Uri.https("gmail.com"));
  }
}

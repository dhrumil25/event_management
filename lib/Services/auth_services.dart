import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Login with Email and Password
  Future<AppUser?> loginUser(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot snapshot =
          await _db.collection("users").doc(cred.user!.uid).get();

      if (snapshot.exists) {
        return AppUser.fromMap(snapshot.data() as Map<String, dynamic>, cred.user!.uid);
      } else {
        throw Exception("User not found in Firestore");
      }
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }
  Future<void> registerUser(String email, String password, String role) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user info in Firestore
      await _db.collection("users").doc(cred.user!.uid).set({
        'email': email,
        'role': role,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Google
  Future<AppUser?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Get the authentication details from the Google Sign-In
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential using the Google Sign-In authentication details
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using the credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Check if the user already exists in Firestore
        DocumentSnapshot snapshot = await _db.collection("users").doc(user.uid).get();

        if (snapshot.exists) {
          // If user exists, return the user data
          return AppUser.fromMap(snapshot.data() as Map<String, dynamic>, user.uid);
        } else {
          // If it's the first time login, create the user in Firestore
          await _db.collection("users").doc(user.uid).set({
            'email': user.email,
            'role': 'user', // Default role
            'name': user.displayName,
          });

          // Return user data
          return AppUser.fromMap({
            'email': user.email,
            'role': 'user', // Default role
            'name': user.displayName,
          }, user.uid);
        }
      } else {
        throw Exception("Google sign-in failed");
      }
    } catch (e) {
      print("Google sign-in error: $e");
      return null;
    }
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    GoogleSignIn().signOut();
  }
}

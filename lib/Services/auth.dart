import 'package:event_booking_app/Services/database.dart';
import 'package:event_booking_app/pages/bottomnav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;

      Map<String, dynamic> userInfoMap = {
        "Name": user!.displayName,
        "Image": user.photoURL,
        "Email": user.email,
        "Id": user.uid,
      };
      await DatabaseMethods()
          .addUserDetail(userInfoMap, user.uid)
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            showCloseIcon: true,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            content: Text(
              'Registered Sucessfully!',
              style: TextStyle(fontSize: 15),
            ),
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const BottomNav(),
          ),
        );
      });
        }
  }
}

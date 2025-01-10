import 'package:event_booking_app/Services/auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Image.asset(
              'images/Signup.jpg',
              height: 500,
            ),
            const Text(
              'Unlock the Future of',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Event Booking App',
              style: TextStyle(
                fontSize: 30,
                color: Color(0xff6351ec),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Discover, book, and experience unforgettable moments, effortlessly!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                AuthMethods().signup(context);
              },
              child: Container(
                height: 60,
                margin: const EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                    color: Color(0xFF4133FF),
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/Google.png',
                      height: 45,
                      width: 45,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 30),
                    const Text(
                      'Sign in with Google',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

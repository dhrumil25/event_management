import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Admin/upload_event.dart';
import '../../Services/auth_services.dart';
import '../../models/user_model.dart';
import '../UserHome.dart';
import '../bottomnav.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  void handleLogin() async {
  if (_formKey.currentState!.validate()) {
    try {
      AppUser? user = await AuthService().loginUser(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user == null) {
        throw Exception("Login failed");
      }

      if (user.role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UploadEvent()),
        );
      } else if (user.role == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => BottomNav()),
        );
      } else {
        throw Exception("Unknown role");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          showCloseIcon: true,
        ),
      );
    }
  }
}


  void handleGoogleSignIn() async {
  try {
    AppUser? role = await AuthService().signInWithGoogle();

    if (role != null) {
      // Save to SharedPreferences
      final user = await AuthService().getCurrentUser();
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('uid', user?.uid ?? '');
      await prefs.setString('email', user?.email ?? '');
      await prefs.setString('role', role.role);

      // Navigate based on role
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UploadEvent()),
        );
      } else if (role == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UserHome()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Unknown or missing role"),
            backgroundColor: Colors.red,
            showCloseIcon: true,
          ),
        );
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Google sign-in failed: $e"),
        backgroundColor: Colors.red,
        showCloseIcon: true,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(Icons.lock_outline, size: 80, color: Colors.blueAccent),
                SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val != null && val.contains('@')
                      ? null
                      : 'Enter a valid email',
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !isPasswordVisible,
                  validator: (val) => val != null && val.length >= 6
                      ? null
                      : 'Password too short',
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Login", style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 16),
                Text("OR", style: TextStyle(color: Colors.grey[700])),
                SizedBox(height: 16),
                SignInButton(
                  Buttons.Google,
                  onPressed: handleGoogleSignIn,
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RegisterScreen()),
                        );
                      },
                      child: Text(
                        "Create one",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

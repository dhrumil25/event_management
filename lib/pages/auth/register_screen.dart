import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Admin/upload_event.dart';
import '../../Services/auth_services.dart';
import '../../models/user_model.dart';
import '../UserHome.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String role = 'user';

  /// 🚀 Handle Google Sign-In and persist with SharedPreferences
  void handleGoogleSignIn() async {
    try {
      AppUser? user = await AuthService().signInWithGoogle();

      if (user != null) {
        // Store data in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', user.uid);
        await prefs.setString('email', user.email);
        await prefs.setString('role', user.role);

        // Navigate based on role
        if (user.role == 'admin') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => UploadEvent()));
        } else if (user.role == 'user') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => UserHome()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Unknown or missing role"),
            backgroundColor: Colors.red,
            showCloseIcon: true,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Google sign-in failed or user canceled"),
          backgroundColor: Colors.red,
          showCloseIcon: true,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Google sign-in failed: $e"),
        backgroundColor: Colors.red,
        showCloseIcon: true,
      ));
    }
  }

  /// 📝 Regular email-password registration
  void handleRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AuthService().registerUser(
          emailController.text.trim(),
          passwordController.text.trim(),
          role,
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Registered successfully!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          showCloseIcon: true,
        ));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Registration failed: $e",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            showCloseIcon: true,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Register"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.person_add_alt_1,
                    size: 80, color: Colors.blueAccent),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val != null && val.contains('@')
                      ? null
                      : 'Enter a valid email',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (val) => val != null && val.length >= 6
                      ? null
                      : 'Password too short',
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: role,
                  decoration: const InputDecoration(
                    labelText: "Select Role",
                    border: OutlineInputBorder(),
                  ),
                  items: ['user', 'admin'].map((String val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val[0].toUpperCase() + val.substring(1)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      role = val!;
                    });
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Register", style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),
                Text("OR", style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 16),
                SignInButton(
                  Buttons.Google,
                  onPressed: handleGoogleSignIn,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      },
                      child: const Text("Login"),
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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'Homepage.dart';

class AuthScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _handleSignUp(BuildContext context) async {
    try {
      String username = usernameController.text;
      String phoneNumber = phoneNumberController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String confirmPassword = confirmPasswordController.text;

      // Validate password and confirm password
      if (password != confirmPassword) {
        throw "Passwords do not match";
      }

      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = authResult.user;

      // Save user data to Realtime Database
      await databaseReference.child('Users').child(user!.uid).set({
        'username': username,
        'phoneNumber': phoneNumber,
        'email': email,
        // Add other fields here
      });

      // Navigate to SaveTwice class
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SaveTwice(username: username),
        ),
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _handleSignUp(context),
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_noteapp/controller/google_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
            child: ElevatedButton(
          onPressed: () {
            signInWithGoogle(context);
          },
          child: const Text('Sign in with Google'),
        )),
      ),
    );
  }
}

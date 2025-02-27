import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_app/home_screen/home_page.dart';
import 'package:form_app/login_screen/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return snapshot.hasData ? HomePage() : LoginPage();
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

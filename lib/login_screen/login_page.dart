import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_app/services/auth_gate.dart';
import 'package:form_app/services/auth_services.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // Function to launch URLs
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 200, bottom: 5),
              child: Image.asset(
                'assets/nlc_logo.png',
                height: 250, // Reduced size for better UI
                width: 290,
              ),
            ),
            Column(
              children: [
                Padding(padding: EdgeInsets.all(18) ),
                RichText(
                  text: TextSpan(
                    text: 'Welcome to GVTC Feedback Portal!' ,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(11),
                    child: Text('Please sign in to share your feedback and help us improve. Your insights matter, and we appreciate your time in making GVTC better.' ,),
                  ),
                ),
              ],
            ),
            
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 70),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.grey.shade200,
                    side: BorderSide(
                      color: Colors.grey.shade500,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () async {
                    AuthServices authServices = AuthServices();
                    final user = await authServices.SignInWithGoogle();

                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthGate(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Sign-in failed, try again")),
                      );
                    }
                  },
                  icon: Image.asset(
                    'assets/google.png',
                    height: 15,
                    width: 15,
                  ),
                  label: Text(
                    "Sign in with Google",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Spacer(),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Explore Our Official Website ',
                style: TextStyle(fontSize: 14, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'NLC India Ltd',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchURL('https://www.nlcindia.in');
                      },
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Learn More About Us',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchURL(
                            'https://en.wikipedia.org/wiki/NLC_India_Limited');
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

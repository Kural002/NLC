import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_app/feedback_screen/feedback_page.dart';
import 'package:form_app/services/auth_gate.dart';
import 'package:form_app/services/auth_services.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("❌ Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full-screen background image
          Positioned.fill(
            child: Image.asset(
              'assets/NLC_night.png',
              fit: BoxFit.cover,
            ),
          ),

          // Overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          // UI Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/nlc_logo.png', height: 250, width: 290),
                const SizedBox(height: 20),

                const Text(
                  'Welcome to GVTC Feedback Portal!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 10),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Please sign in to share your feedback and help us improve.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Google Sign-In Button
                ElevatedButton.icon(
                  onPressed: () async {
                    final user = await AuthServices().SignInWithGoogle();
                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AuthGate()),
                      );
                    }
                  },
                  icon: Image.asset('assets/google.png', height: 20),
                  label: const Text("Sign in with Google"),
                ),
                const SizedBox(height: 20),

                // Admin Login Button
                ElevatedButton.icon(
                  onPressed: () async {
                    final user = await AuthServices().SignInWithGoogle();
                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => FeedbackPage()),
                      );
                    }
                  },
                  icon: Image.asset('assets/nlc.png', height: 20),
                  label: const Text("Login as Admin"),
                ),

                // External Links
                Padding(
                  padding: const EdgeInsets.only(top: 70, bottom: 40),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Explore Our Official Website ',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      children: [
                        TextSpan(
                          text: 'NLC India Ltd',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => _launchURL('https://www.nlcindia.in'),
                        ),
                        const TextSpan(
                          text: ' and ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'Learn More About Us',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _launchURL(
                                'https://en.wikipedia.org/wiki/NLC_India_Limited'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

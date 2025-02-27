import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_app/login_screen/login_page.dart';
import 'package:form_app/services/auth_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _feedbackController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.isEmpty) return;
    await _firestore.collection('feedbacks').add({
      'feedback': _feedbackController.text,
      'email': user?.email ?? 'Anonymous',
      'timestamp': FieldValue.serverTimestamp(),
    });

    _feedbackController.clear();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 150,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Thank you for your feedback!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    AuthServices().signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text('Logout'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Page'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              AuthServices().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(18, 100, 18, 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              user != null
                  ? Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: user!.photoURL != null
                              ? NetworkImage(user!.photoURL!)
                              : null,
                          child: user!.photoURL == null
                              ? Icon(Icons.person, size: 50)
                              : null,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Welcome, ${user!.displayName ?? 'User'}!',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text('Email: ${user!.email ?? 'No email'}'),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            Padding(padding: EdgeInsets.all(18)),
                            RichText(
                              text: TextSpan(
                                text: 'Welcome to the GVTC Feedback Page!',
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
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  'We value your feedback! Please take a moment to share your thoughts and help us improve. Your input plays a crucial role in enhancing our services and ensuring a better experience for everyone.',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Text('No user logged in'),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: _feedbackController,
                  decoration: InputDecoration(
                    labelText: 'Enter your feedback',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 15,
                  backgroundColor: Colors.grey.shade100,
                  side: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () async {
                  _submitFeedback();
                },
                icon: Image.asset(
                  'assets/nlc.png',
                  height: 25,
                  width: 25,
                ),
                label: Text(
                  "Submit feedback !",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

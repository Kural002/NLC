import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_app/login_screen/login_page.dart';
import 'package:form_app/services/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _feedbackController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  String? _selectedMine;
  String? _selectedClass;

  final List<String> _mines = [
    'MINE - 1',
    'MINE - 1A',
    'MINE - 2',
    'MINE - 1 CS',
    'L & DC'
  ];

  final List<String> _class = [
    'Electrical class',
    'Non Electrical class',
    'safety class',
    'Heath Class',
    'First AID Class'
  ];

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.isEmpty) return;

    await _firestore.collection('feedbacks').add({
      'feedback': _feedbackController.text,
      'mine': _selectedMine,
      'class': _selectedClass,
      'email': user?.email ?? 'Anonymous',
      'uid': user!.uid,
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
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

  Widget _buildProfileImage() {
    if (user?.photoURL != null) {
      return ClipOval(
        child: Image.network(
          user!.photoURL!,
          fit: BoxFit.cover,
          width: 80,
          height: 80,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return CircularProgressIndicator();
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.person, size: 50);
          },
        ),
      );
    } else {
      return Icon(Icons.person, size: 50);
    }
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
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(200, 80, 200, 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProfileImage(),
              SizedBox(height: 10),
              Text(
                'Welcome, ${user?.displayName ?? 'User'}!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text('Email: ${user?.email ?? 'No email'}'),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(18),
                child: RichText(
                  text: TextSpan(
                    text: 'Welcome to the GVTC Feedback Page!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    Text(
                      'We value your feedback! Please take a moment to share your thoughts and help us improve.',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: DropdownButtonFormField<String>(
                              value: _selectedMine ,
                              decoration: InputDecoration(
                                labelText: 'Select Branch',
                                border: OutlineInputBorder(),
                              ),
                              items: _mines.map((mine) {
                                return DropdownMenuItem<String>(
                                  value: mine,
                                  child: Text(mine),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMine = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: DropdownButtonFormField<String>(
                              value: _selectedClass,
                              decoration: InputDecoration(
                                labelText: 'Select Class',
                                border: OutlineInputBorder(),
                              ),
                              items: _class.map((classes) {
                                return DropdownMenuItem<String>(
                                  value: classes,
                                  child: Text(classes),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedClass = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: _submitFeedback,
                icon: Image.asset('assets/nlc.png', height: 25, width: 25),
                label: Text(
                  "Submit feedback!",
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

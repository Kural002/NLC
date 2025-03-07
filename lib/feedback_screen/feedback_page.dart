import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_app/login_screen/login_page.dart';
import 'package:form_app/services/auth_services.dart';

class FeedbackPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(child: Text("Please log in to view feedback")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("User Feedback"),
        leading: IconButton(
          onPressed: () {
            AuthServices().signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          icon: Icon(Icons.logout_outlined),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("feedbacks")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("🔥 Error loading feedbacks: ${snapshot.error}");
            return Center(child: Text("Error loading feedbacks"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No feedback found."));
          }

          print("✅ Loaded ${snapshot.data!.docs.length} feedbacks.");

          var feedbackDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: feedbackDocs.length,
            itemBuilder: (context, index) {
              var feedback = feedbackDocs[index].data() as Map<String, dynamic>;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 150, vertical: 5),
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ExpansionTile(
                    leading:
                        Image.asset('assets/nlc_logo.png', height: 40, width: 40),
                    title: Text("Submitted by: ${feedback["email"]}",
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      feedback["timestamp"] != null
                          ? feedback["timestamp"].toDate().toString()
                          : "No date",
                      style: TextStyle(color: Colors.grey),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 80),
                                child: Text(
                                  feedback["feedback"] ?? "No message",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Branch: ${feedback["mine"]}",
                                    style: TextStyle(color: Colors.grey .shade600)),
                                Text("Class: ${feedback["class"]}",
                                    style: TextStyle(color: Colors.grey.shade600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

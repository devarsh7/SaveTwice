import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Modes extends StatefulWidget {
  final String userId;

  Modes({required this.userId});

  @override
  _ModesState createState() => _ModesState();
}

class _ModesState extends State<Modes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('Business'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                elevation: 4,
                padding: EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 70,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Personal'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                elevation: 4,
                padding: EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 70,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                createGroup(widget.userId);
              },
              child: Text('Friends'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                elevation: 4,
                padding: EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void createGroup(String userId) {
  // Get the reference to the Firestore collection
  CollectionReference groupsCollection =
      FirebaseFirestore.instance.collection('groups');

  // Adding a new document to the collection for the friends mode
  groupsCollection
      .add({
        'userId': userId,
        'members': [userId], // Just the user is there in the group currently
        'updateExpense': 0.0,
        'totalExpense': 0.0,
        'time': DateTime.now(),
      })
      .then((value) {})
      .catchError((error) {
        print('Error creating group: $error');
      });
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final TextEditingController _expensesController = TextEditingController();

  void _addExpenses(String userId, String expenses) {
    // Get the reference to the Firestore collection
    CollectionReference expensesCollection =
        FirebaseFirestore.instance.collection('total_expenses');

    // Add a new document to the collection
    expensesCollection.add({
      'userId': userId,
      'expenses': expenses,
      'timestamp': DateTime.now(),
    }).then((value) {
      // Clear the text field after adding expenses
      _expensesController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Expenses added successfully')),
      );
    }).catchError((error) {
      print('Error adding expenses: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add expenses')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Expenses:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _expensesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter expenses',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String userId = FirebaseAuth.instance.currentUser!.uid;
                String expenses = _expensesController.text;
                _addExpenses(userId, expenses);
              },
              child: Text('Add Expenses'),
            ),
            SizedBox(height: 20),
            Text(
              'Expenses History:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('total_expenses')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return Text('No expenses found.');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index].data() as Map;
                      return ListTile(
                        title: Text('Expenses: ${data['expenses']}'),
                        subtitle: Text(
                            'Date: ${data['timestamp'].toDate().toString()}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

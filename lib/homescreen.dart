import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Stream<List<String>> _usernamesStream;

  @override
  void initState() {
    super.initState();
    _usernamesStream = _getUsernamesStream('');
  }

  Stream<List<String>> _getUsernamesStream(String query) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc['username'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _usernamesStream = _getUsernamesStream(value);
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: _usernamesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final List<String> usernames = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: usernames.length,
                    itemBuilder: (context, index) {
                      final String username = usernames[index];
                      return ListTile(
                        title: Text(username),
                        onTap: () {
                          // Show small card with "Add Friend" button
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(username),
                                content: Text('Add Friend'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Add friend functionality
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Add Friend'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

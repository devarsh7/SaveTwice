import 'package:flutter/material.dart';

class SaveTwice extends StatefulWidget {
  final String username;

  const SaveTwice({Key? key, required this.username}) : super(key: key);

  @override
  _SaveTwiceState createState() => _SaveTwiceState();
}

class _SaveTwiceState extends State<SaveTwice> {
  late TextEditingController limit;
  TextEditingController updateExpense = TextEditingController();
  late int limitLeft;

  @override
  void initState() {
    super.initState();
    limit = TextEditingController();
  }

  @override
  void dispose() {
    limit.dispose(); // Dispose the controller when not in use
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' SaveTwice'),
        backgroundColor: Colors.white,
        foregroundColor: Color.fromARGB(255, 16, 212, 26),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Set your Goal",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Set your Limit ",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: limit,
              decoration: InputDecoration(
                labelText: "Limit",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                hintText: "Enter your limit",
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Welcome, ${widget.username}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

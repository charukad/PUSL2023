import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:mobilenew/resources/firestore_methods.dart';
import 'package:mobilenew/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:mobilenew/providers/user_provider.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _eventDate = DateTime.now();
  bool _isLoading = false;

  // Method to show the date picker and select a date
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDate, // Referencing event date
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _eventDate) {
      setState(() {
        _eventDate = picked;
      });
    }
  }

  void postEvent() async {
    setState(() {
      _isLoading = true;
    });

    final user = Provider.of<UserProvider>(context, listen: false).getUser;
    String res = await FireStoreMethods().postEvent(
      _titleController.text,
      _eventDate, // Use the selected event date
      _descriptionController.text,
      user.uid,
    );

    if (res == "success") {
      Navigator.pop(context); // Navigate back after posting
    } else {
      // Error handling
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text(res),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("Add New Event"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Event Title',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Event Description',
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Event Date: ${DateFormat.yMd().format(_eventDate)}',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Choose Date'),
                ),
              ],
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: postEvent,
                    child: Text("Submit Event"),
                  ),
          ],
        ),
      ),
    );
  }
}

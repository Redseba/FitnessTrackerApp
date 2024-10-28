import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import the database helper to access the database functions

class LogScreen extends StatefulWidget {
  const LogScreen({Key? key}) : super(key: key); // Constructor for the LogScreen widget

  @override
  _LogScreenState createState() => _LogScreenState(); // Create the state for LogScreen
}

class _LogScreenState extends State<LogScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance; // Instance of DatabaseHelper to interact with the database
  List<Map<String, dynamic>> _loggedEntries = []; // List to store logged entries

  @override
  void initState() {
    super.initState(); // Call the superclass's initState
    _fetchLoggedEntries(); // Fetch logged entries when the screen initializes
  }

  // Function to fetch logged entries from the database
  Future<void> _fetchLoggedEntries() async {
    
    final entries = await _dbHelper.getLoggedEntries(); // Call the function to get logged entries
    setState(() {
      _loggedEntries = entries; // Update the state with the fetched entries
    });
  }


  @override
  Widget build(BuildContext context) {
    // Build the UI for LogScreen
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800], 
        title: const Text(

          'Log Entries', // Title of the screen
          style: TextStyle(color: Colors.white), 
        ),
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      body: _loggedEntries.isEmpty
          ? const Center(
              child: Text(

                'No log entries found.', // Message displayed when there are no entries
                style: TextStyle(fontSize: 18, color: Colors.white), 
              ),

            )
          : ListView.builder(

              itemCount: _loggedEntries.length, // Number of logged entries to display
              itemBuilder: (context, index) {
                final entry = _loggedEntries[index]; 
                return Card(
                  color: Colors.blue[600], 
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), 
                  child: ListTile(
                    title: Text(
                      entry['entryTitle'], // Display the entry title
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), 
                    ),
                    subtitle: Text(
                      'Sets: ${entry['sets']}, Reps: ${entry['reps']}, Calories: ${entry['caloriesBurnt']}', // Display sets, reps, and calories
                      style: const TextStyle(color: Colors.white70), 
                    ),

                  ),


                );
              },
            ),
      backgroundColor: Colors.blue[900],
    );
  }
}
import 'package:flutter/material.dart';
import 'database_helper.dart';

class EntryClickedScreen extends StatefulWidget {
  // Constructor to receive the entry title, ID, and total calories from the previous screen.
  final String entryTitle;
  final int entryId;
  final int totalCalories;

  const EntryClickedScreen({
    Key? key,
    required this.entryTitle,
    required this.entryId,
    required this.totalCalories,
  }) : super(key: key);

  @override
  _EntryClickedScreenState createState() => _EntryClickedScreenState();
}

class _EntryClickedScreenState extends State<EntryClickedScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper
      .instance; // Instance of the database helper to interact with the database.
  int sets = 0; // Variable to store the number of sets.
  int reps = 0; // Variable to store the number of reps.
  int caloriesBurnt = 0; // Variable to store calories burnt.

  // Function to log calories when the button is pressed.
  Future<void> _logCalories() async {
    if (sets > 0 && reps > 0 && caloriesBurnt > 0) {
      // Insert the logged entry into the database.
      await _dbHelper.insertLoggedEntry({
        'entryTitle': widget.entryTitle,
        'sets': sets,
        'reps': reps,
        'caloriesBurnt': caloriesBurnt,
      });

      // Retrieve the current total calories from the database.
      
      int totalCalories = await _dbHelper.getTotalCalories();
      totalCalories += caloriesBurnt;
      await _dbHelper.updateTotalCalories(totalCalories);

      // Show a success message using a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Calories logged successfully!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue, // Set background color for the Snackbar.
      ));
      Navigator.of(context)
          .pop(); // Navigate back to the previous screen after logging.
    }
     else {

      // Show an error message if the input values are invalid.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter valid sets, reps, and calories.',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red, // Red for error messages.
      ));

    }
  }

  @override
  Widget build(BuildContext context) {
    // Build the UI of the EntryClickedScreen.
    return Scaffold(

      appBar: AppBar(
        backgroundColor:
            Colors.blue[800], // Match with the theme of EntryScreen.
        title: Text(widget.entryTitle),
      ),

      body: Container(
        color: Colors.blue[900], // Background color for the main body.
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            const Text(

              'Log Entry',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),

            const SizedBox(height: 20),

            Text(
              'Total Calories Burnt: ${widget.totalCalories}', // Display the total calories passed from the previous screen.
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),

            const SizedBox(height: 20),
            // TextField for entering the number of sets.
            
            TextField(
              onChanged: (value) {
                sets = int.tryParse(value) ?? 0;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Sets',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            )
            
            ,
            const SizedBox(height: 16),
            // TextField for entering the number of reps.
            TextField(
              onChanged: (value) {
                reps = int.tryParse(value) ?? 0;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Reps',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            // TextField for entering calories burnt.
            TextField(

              onChanged: (value) {
                caloriesBurnt = int.tryParse(value) ?? 0;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Calories Burnt',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            // Button to log the entry.
            ElevatedButton(
              onPressed: _logCalories, // Call the log function on button press.
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
              ),
              child: const Text('Log Entry',
                  style: TextStyle(color: Colors.white)),
            
            ),
          ],

        ),
      ),
    );
  }
}

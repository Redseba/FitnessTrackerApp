import 'package:flutter/material.dart';
import 'database_helper.dart';

class EntryClickedScreen extends StatefulWidget {
  final String entryTitle;
  final int entryId;
  final int totalCalories; // Add totalCalories parameter

  const EntryClickedScreen({
    super.key,
    required this.entryTitle,
    required this.entryId,
    required this.totalCalories, // Accept totalCalories
  });

  @override
  _EntryClickedScreenState createState() => _EntryClickedScreenState();
}

class _EntryClickedScreenState extends State<EntryClickedScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  int sets = 0;
  int reps = 0;
  int caloriesBurnt = 0;

  Future<void> _logCalories() async {
    if (sets > 0 && reps > 0 && caloriesBurnt > 0) {
      // Example: Updating total calories with a simple formula
      int totalCalories = await _dbHelper.getTotalCalories();
      totalCalories += caloriesBurnt;
      await _dbHelper.updateTotalCalories(totalCalories);

      // Optionally show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Calories logged successfully!'),
      ));
      Navigator.of(context).pop(); // Go back after logging
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter valid sets, reps, and calories.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entryTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Log Entry',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Calories Burnt: ${widget.totalCalories}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Increased font size
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                sets = int.tryParse(value) ?? 0;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Sets'),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                reps = int.tryParse(value) ?? 0;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Reps'),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                caloriesBurnt = int.tryParse(value) ?? 0;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Calories Burnt'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logCalories,
              child: const Text('Log Entry'),
            ),
          ],
        ),
      ),
    );
  }
}

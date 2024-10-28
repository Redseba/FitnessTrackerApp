import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'entry_clicked_screen.dart';

class EntryScreen extends StatefulWidget {
  final String title; // Title of the screen
  final int containerId; // ID of the container for the entries
  final Function onCaloriesUpdated; // Callback function to update calories

  const EntryScreen({
    super.key,
    required this.title,
    required this.containerId,
    required this.onCaloriesUpdated,
  });

  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final _dbHelper = DatabaseHelper.instance; // Instance of the database helper class
  List<Map<String, dynamic>> _entries = []; // List to store entry data from the database
  int totalCalories = 0; // Total calories burnt

  @override
  void initState() {
    super.initState();
    _fetchEntries(); // Fetch entries from the database on initialization
    _calculateTotalCalories(); // Calculate the total calories on initialization
  }

  // Function to fetch entries from the database based on the container ID
  Future<void> _fetchEntries() async {
    final entries = await _dbHelper.getEntriesByContainerId(widget.containerId);
    setState(() {
      _entries = entries; // Update the state with fetched entries
    });
  }

  // Function to calculate the total calories from the database
  Future<void> _calculateTotalCalories() async {
    totalCalories = await _dbHelper.getTotalCalories(); // Get total calories
    setState(() {}); // Update the state to reflect the total calories
  }

  // Function to show a dialog for adding a new entry
  Future<void> _showAddEntryDialog() async {
    final titleController = TextEditingController(); 
    final descriptionController = TextEditingController(); 

    // Show dialog to add a new entry
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue[900], 
          title: const Text('Add Entry', style: TextStyle(color: Colors.white)), 
          content: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'), 
              ),
              const SizedBox(height: 16), 
              TextField(
                controller: descriptionController, 
                decoration: const InputDecoration(labelText: 'Description (Optional)'),
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            // Cancel button
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)), 
            ),
            // Save Entry button
            
            TextButton(
              onPressed: () async {
                // Check if the title field is not empty
                if (titleController.text.isNotEmpty) {
                  // Create a new entry map
                  final entry = {
                    'title': titleController.text, // Title from the text field
                    'description': descriptionController.text.isNotEmpty
                        ? descriptionController.text // Description from the text field
                        : '',
                    'containerId': widget.containerId, 
                  };

                  await _dbHelper.insertEntry(entry); // Insert the new entry into the database
                  widget.onCaloriesUpdated(); // Call the function to update calories

                  // Clear the text fields after saving
                  titleController.clear();
                  descriptionController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Entry saved!'), 
                    backgroundColor: Colors.blue,
                  ));
                  await _fetchEntries(); // Fetch updated entries
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  // Show error message if the title is empty
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please enter a title'), 
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: const Text('Save Entry', style: TextStyle(color: Colors.white)), 
            ),
            
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build the UI for the EntryScreen
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800], 
        title: Text(widget.title), 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), 
          onPressed: () => Navigator.of(context).pop(), 
        ),
      ),
      body: Padding(

        padding: const EdgeInsets.all(16.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Calories Burnt: $totalCalories', // Display total calories burnt
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), 
            ),
            const SizedBox(height: 16), 
            const Text('Entries:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), // Header for entries
            const SizedBox(height: 16), 
            Expanded(
              // List of entries displayed in a scrollable view
              
              
              child: ListView.builder(
                itemCount: _entries.length, 
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to EntryClickedScreen when an entry is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntryClickedScreen(
                            entryTitle: _entries[index]['title'], 
                            entryId: _entries[index]['id'],
                            totalCalories: totalCalories, // Total calories for the current session
                          ),
                        ),
                      );

                    },
                    child: Card(

                      color: Colors.blue[600], 
                      margin: const EdgeInsets.symmetric(vertical: 8), 
                      child: ListTile(
                        title: Text(
                          _entries[index]['title'], 
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), 
                        ),
                        subtitle: Text(
                          _entries[index]['description'] ?? '', 
                          style: const TextStyle(color: Colors.white70), 
                        ),
                      ),
                    ),

                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: 16.0), 
        child: SizedBox(
          width: 150, 
          child: ElevatedButton(
            onPressed: _showAddEntryDialog, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700], 
              padding: const EdgeInsets.symmetric(vertical: 16), 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), 
            ),
            child: const Text('Add Entry', style: TextStyle(fontSize: 16, color: Colors.white)), 
          ),

        ),
      ),
      backgroundColor: Colors.blue[900], 


    );
  }
}
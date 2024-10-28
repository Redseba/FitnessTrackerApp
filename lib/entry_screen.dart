import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'entry_clicked_screen.dart';

class EntryScreen extends StatefulWidget {
  final String title;
  final int containerId;
  final Function onCaloriesUpdated;

  const EntryScreen({super.key, required this.title, required this.containerId, required this.onCaloriesUpdated});

  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _entries = [];
  int totalCalories = 0;

  @override
  void initState() {
    super.initState();
    _fetchEntries();
    _calculateTotalCalories();
  }

  Future<void> _fetchEntries() async {
    final entries = await _dbHelper.getEntriesByContainerId(widget.containerId);
    setState(() {
      _entries = entries;
    });
  }

  Future<void> _calculateTotalCalories() async {
    totalCalories = await _dbHelper.getTotalCalories();
    setState(() {});
  }

  Future<void> _showAddEntryDialog() async {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Entry'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description (Optional)'),
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty) {
                  final entry = {
                    'title': _titleController.text,
                    'description': _descriptionController.text.isNotEmpty 
                        ? _descriptionController.text 
                        : '',
                    'containerId': widget.containerId,
                  };

                  await _dbHelper.insertEntry(entry);
                  widget.onCaloriesUpdated();

                  _titleController.clear();
                  _descriptionController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Entry saved!'),
                  ));
                  await _fetchEntries();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please enter a title'),
                  ));
                }
              },
              child: const Text('Save Entry'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Calories Burnt: $totalCalories',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Entries:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntryClickedScreen(
                            entryTitle: _entries[index]['title'],
                            entryId: _entries[index]['id'],
                            totalCalories: totalCalories, // Pass totalCalories
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(_entries[index]['title']),
                        subtitle: Text(_entries[index]['description'] ?? ''),
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
          width: 150, // Set a specific width for the button
          child: ElevatedButton(
            onPressed: _showAddEntryDialog,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16), // Vertical padding for the button
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Add Entry', style: TextStyle(fontSize: 16)), // Text inside the button
          ),
        ),
      ),
    );
  }
}

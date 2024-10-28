import 'package:flutter/material.dart';
import 'entry_screen.dart';
import 'database_helper.dart';
import 'log_screen.dart'; // Import the new LogScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> containerTitles = [
    "Chest",
    "Shoulders",
    "Arms",
    "Back",
    "Legs",
    "Abs"
  ];

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  int totalCalories = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotalCalories();
  }

  void _calculateTotalCalories() async {
    totalCalories = await _dbHelper.getTotalCalories();
    setState(() {});
  }

  void _navigateToEntryScreen(BuildContext context, String title, int containerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntryScreen(
          title: title,
          containerId: containerId,
          onCaloriesUpdated: _calculateTotalCalories,
        ),
      ),
    ).then((_) {
      _calculateTotalCalories(); // Recalculate when returning from entry screen
    });
  }

  void _navigateToLogScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LogScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Navigation',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Log Entries'),
              onTap: _navigateToLogScreen,
            ),
            // Add more navigation items here if needed
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Calories Burnt: $totalCalories',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              shrinkWrap: true,
              children: <Widget>[
                ...List.generate(containerTitles.length, (index) {
                  return GestureDetector(
                    onTap: () => _navigateToEntryScreen(context, containerTitles[index], index),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[(index + 1) * 100],
                      child: Center(child: Text(containerTitles[index])),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

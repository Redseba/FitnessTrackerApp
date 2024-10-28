import 'package:flutter/material.dart';
import 'entry_screen.dart';
import 'log_screen.dart'; // Import for log screen
import 'database_helper.dart';

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
        // Main color scheme updated to blue
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Fitness Tracker'),
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

  final List<String> imageUrls = [
    'https://cdn2.iconfinder.com/data/icons/fitness-filled-outline-1/512/chest_strong_muscle_exercise_body_parts_medical_sports_man_fitness_anatomy-512.png',
    'https://cdn3.iconfinder.com/data/icons/fitness-filled-outline-1/340/18_-512.png',
    'https://cdn-icons-png.flaticon.com/512/5601/5601299.png',
    'https://cdn2.iconfinder.com/data/icons/fitness-filled-outline-1/512/Back_strong_muscle_exercise_body_parts_medical_sports_man_fitness_anatomy-512.png',
    'https://cdn-icons-png.flaticon.com/512/10530/10530936.png',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwWzZKnpCzYbhLryQjYRMbbe3J22W8FJ4pUA&s',
  ];

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  int totalCalories = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotalCalories();
  }

  // Fetches the total calories from the database
  void _calculateTotalCalories() async {
    totalCalories = await _dbHelper.getTotalCalories();
    setState(() {});
  }

  // Navigates to the Entry screen for a selected muscle group
  void _navigateToEntryScreen(
      BuildContext context, String title, int containerId) {
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
      _calculateTotalCalories();
    });
  }

  // Navigates to the Log screen
  void _navigateToLogScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LogScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Calories Burnt: $totalCalories',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Updated text color to white
              ),
            ),
            const SizedBox(height: 20),
            // Muscle group grid
            GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              shrinkWrap: true,
              children: List.generate(containerTitles.length, (index) {
                return GestureDetector(
                  onTap: () => _navigateToEntryScreen(
                      context, containerTitles[index], index),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[700], // Changed color to blue
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          imageUrls[index],
                          height: 50,
                          width: 50,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image_not_supported, size: 50),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          containerTitles[index],
                          style: const TextStyle(
                            color: Colors.white, // Updated text color to white
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      // Drawer with navigation options
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue, // Updated header color to blue
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Log Screen'),
              onTap: () => _navigateToLogScreen(context),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue[800], // Updated background color
    );
  }
}
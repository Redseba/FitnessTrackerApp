import 'package:flutter/material.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Entries'),
      ),
      body: Center(
        child: const Text('Log entries will be displayed here.'),
      ),
    );
  }
}

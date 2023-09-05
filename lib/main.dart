import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 15, 3, 3),
        appBar: AppBar(
          title: const Text(
            'I-Shop App Hompage',
          ),
          backgroundColor: Colors.blueGrey[900],
        ),
        body: const HomePage(),
      ),
    );
  }
}

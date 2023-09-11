import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/cameraWidget.dart';
import '../globals.dart' as globals;

class SupermarketLocationFunction extends StatefulWidget {
  const SupermarketLocationFunction({super.key});

  @override
  _SupermarketLocationFunctionState createState() =>
      _SupermarketLocationFunctionState();
}

class _SupermarketLocationFunctionState
    extends State<SupermarketLocationFunction> {

  @override
  void initState() {
    super.initState();

    // Inform the user about the volume button action
    globals.speak("You are now in the Super Market Location Functionality. You can return to Home Page anytime by Swiping right.");

  }

  void returnToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Implement your supermarket location function UI here
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Supertmarket Location Function',
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swipe right to return to the homepage
            returnToHomePage();
          }
        },
        child: CameraApp(),
      ),
    );;
  }
}

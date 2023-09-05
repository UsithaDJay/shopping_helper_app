import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/cameraWidget.dart';
import '../globals.dart' as globals;

class FoodDetectionFunction extends StatefulWidget {
  const FoodDetectionFunction({super.key});

  @override
  _FoodDetectionFunctionState createState() =>
      _FoodDetectionFunctionState();
}

class _FoodDetectionFunctionState
    extends State<FoodDetectionFunction> {

  @override
  void initState() {
    super.initState();

    // Inform the user about the volume button action
    globals.speak("You are now in the Food Detection Functionality. You can return to Home Page anytime by Swiping right.");

  }

  void returnToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Implement your food detection function UI here
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Food Detection Function',
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
    );
  }
}

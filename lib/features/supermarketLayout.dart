import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/cameraWidget.dart';
import '../globals.dart' as globals;

class SupermarketLayoutFunction extends StatefulWidget {
  const SupermarketLayoutFunction({super.key});

  @override
  _SupermarketLayoutFunctionState createState() =>
      _SupermarketLayoutFunctionState();
}

class _SupermarketLayoutFunctionState
    extends State<SupermarketLayoutFunction> {

  @override
  void initState() {
    super.initState();

    // Inform the user about the volume button action
    globals.speak("You are now in the Super Market Layout Functionality. You can return to Home Page anytime by Swiping right.");

  }

  void returnToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Implement your supermarket Layout function UI here
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Supermarket Layout Function',
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

import 'package:flutter/material.dart';
import 'package:shopping_helper_app/features/foodDetection.dart';

import '../main.dart';
import '../widgets/cameraWidget.dart';
import '../globals.dart' as globals;

class ReadingFunction extends StatefulWidget {
  const ReadingFunction({super.key});

  @override
  _ReadingFunctionState createState() =>
      _ReadingFunctionState();
}
  GlobalKey<CameraAppState> cameraWidgetKey = GlobalKey();

class _ReadingFunctionState
    extends State<ReadingFunction> {

  @override
  void initState() {
    super.initState();

    // Inform the user about the volume button action
    globals.speak("You are now in the reading Functionality. You can return to Home Page anytime by Swiping right.");

  }

  void returnToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Implement your Reading function UI here
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reading Function',
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
        child: CameraApp(cameraWidgetKey: cameraWidgetKey,),
      ),
    );
  }
}

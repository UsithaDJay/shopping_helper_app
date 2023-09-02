import 'package:flutter/material.dart';

import '../main.dart';
import '../features/supermarketLocation.dart';
import '../features/supermarketLayout.dart';
import '../features/foodDetection.dart';
import '../features/reading.dart';
import '../globals.dart' as globals;

class ConfirmWidget extends StatefulWidget {
  const ConfirmWidget({super.key});

  @override
  _ConfirmWidgetState createState() => _ConfirmWidgetState();
}

class _ConfirmWidgetState extends State<ConfirmWidget> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await globals.speak("Swipe right to confirm, or swipe left to cancel.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Confirmation"),
      // ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            print("confirmed");
            print('globals.selectedOption = ' + globals.selectedOption);
            // Swipe right (confirm)
            if (globals.selectedOption == 'supermarketLayout') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SupermarketLayoutFunction()),
              );
            } else if (globals.selectedOption == 'supermarketLocation') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SupermarketLocationFunction()),
              );
            } else if (globals.selectedOption == 'foodDetection') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FoodDetectionFunction()),
              );
            } else if (globals.selectedOption == 'reading') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReadingFunction()),
              );
            }
          } else if (details.primaryVelocity! < 0) {
            // Swipe left (cancel)
            // Navigator.pop(context); // Return to the home screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          }
        },
        child: Container(
          color: Colors.white, // Blank screen
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../features/supermarketLocation.dart';
import '../features/supermarketLayout.dart';
import '../features/foodDetection.dart';
import '../features/reading.dart';
import 'voiceAssistant.dart';
import 'glowingQuestionMarkWidget.dart';
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
      await globals.speak("Swipe left to confirm, or swipe right to go back.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 227, 227),
      body: Stack(
        children: [
          GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              // Swipe right (confirm)
              if (globals.selectedOption == 'supermarketLayout') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SupermarketLayoutFunction()),
                );
              } else if (globals.selectedOption == 'supermarketLocation') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SupermarketLocationFunction()),
                );
              } else if (globals.selectedOption == 'foodDetection') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FoodDetectionFunction()),
                );
              } else if (globals.selectedOption == 'reading') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ReadingFunction()),
                );
              }
            } else if (details.primaryVelocity! > 0) {
              // Swipe left (cancel)
              // return to voice assistant
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const VoiceAssistant()),
              );
            }
          },
        ),
        // Display the GlowingHeadsetIcon as an overlay
        GlowingQuestionMarkIcon(),
        ],
      ),
    );
  }
}

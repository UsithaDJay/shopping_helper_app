import 'package:flutter/material.dart';
import 'package:shopping_helper_app/features/supermarketLayout.dart';

import '../main.dart';
import 'widgets/voiceAssistant.dart';
import 'widgets/glowingHeadsetWidget.dart';
import 'globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isConfirming = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await globals.speak(
          '''Welcome! You are in the Home Page of I-Shop App.
          Swipe Left to say what you want.
          If you need assistance for supermarket location, say SUPERMARKET LOCATION.
          If you need assistance for supermarket layout, say SUPERMARKET LAYOUT.
          If you need assistance for food detection, say FOOD DETECTION.
          If you need assistance for reading, say READING.
          Swipe Left to say what you want.
          Swipe Right to hear the menu again''');
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
            if (details.primaryVelocity! < 0 && !isConfirming) {
              // Swipe right (confirming)
              isConfirming = true;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const VoiceAssistant()),
                // MaterialPageRoute(builder: (context) => const SupermarketLayoutFunction()),
              );
              
            } else if (details.primaryVelocity! > 0 && !isConfirming){
              // Swipe Right Repeat
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            }
          },
        ),
        // Display the GlowingHeadsetIcon as an overlay
        GlowingHeadsetIcon(),
        ],
      ),
    );
  }
}

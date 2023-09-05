import 'package:flutter/material.dart';

class GlowingQuestionMarkIcon extends StatefulWidget {
  @override
  _GlowingQuestionMarkIconState createState() => _GlowingQuestionMarkIconState();
}

class _GlowingQuestionMarkIconState extends State<GlowingQuestionMarkIcon> {
  bool isGlowing = false;
  bool isDisposed = false; // Added a flag to track disposal

  @override
  void initState() {
    super.initState();
    // Start the glowing animation when the widget is first built
    toggleGlowing();
  }

  @override
  void dispose() {
    isDisposed = true; // Set the flag when disposing
    super.dispose();
  }

  // Function to toggle the glowing animation
  void toggleGlowing() async {
    while (!isDisposed) {
      await Future.delayed(const Duration(seconds: 1));
      // Check if the widget is still mounted before calling setState
      if (!isDisposed) {
        setState(() {
          isGlowing = true;
        });
      }
      await Future.delayed(const Duration(seconds: 1));
      // Check if the widget is still mounted before calling setState
      if (!isDisposed) {
        setState(() {
          isGlowing = false;
        });
      }
    }
  }

  void startGlowingAnimation() {
    toggleGlowing(); // Start the animation loop
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: 150, // Adjust the size as needed
        height: 150, // Adjust the size as needed
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.3), // Adjust opacity and color
          boxShadow: isGlowing
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 40.0,
                    spreadRadius: 20.0,
                  ),
                ]
              : [],
        ),
        child: const Icon(
          Icons.question_mark_sharp,
          size: 100, // Adjust the size of the headset icon
          color: Colors.black,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

import '../main.dart';
import '../globals.dart' as globals;

class FoodDetectionFunction extends StatefulWidget {
  const FoodDetectionFunction({super.key});

  @override
  _FoodDetectionFunctionState createState() =>
      _FoodDetectionFunctionState();
}

class _FoodDetectionFunctionState
    extends State<FoodDetectionFunction> {
  double initialVolume = 0;

  @override
  void initState() {
    super.initState();

    // Get the current volume value
    VolumeController().getVolume().then((volume) {
      initialVolume = volume;
    });

    // Inform the user about the volume button action
    globals.speak("You are now in the Food Detection Functionality. You can return to Home Page anytime by Pressing the volume up button twice.");

    // Initialize the volume controller
    _initVolumeController();

  }

  @override
  void dispose() {
    // Dispose of the volume controller
    VolumeController().removeListener();
    super.dispose();
  }

  // Initialize the volume controller and listen for volume button events
  void _initVolumeController() {
    VolumeController().listener((volume) {
      if (volume > initialVolume) {
        // Set the volume back to the initial value
        VolumeController().setVolume(initialVolume);
        // Volume increased, return to the home page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      }
      initialVolume = volume;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Implement your food detection function UI here
    return const Scaffold(
      body: Center(
        child: Text('Food Detection Function Content'),
      ),
    );
  }
}

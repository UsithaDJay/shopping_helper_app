import 'package:flutter/material.dart';

import 'widgets/confirmWidget.dart';
import 'globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int lastTimeStamp = 0;
  int numberOfTaps = 0;
  bool isHold = false;
  Color buttonColor = Colors.blue;
  bool isConfirming = false;

  @override
  void initState() {
    super.initState();
    globals.selectedOption = '';
    Future.delayed(Duration.zero, () async {
      await globals.speak(
          "Welcome! You are in the Home Page of Shopping Helper App. Tap twice for supermarket location. Hold for supermarket layout. Tap three times for food detection. Tap four times for reading.");
    });
  }

  void reset() {
    lastTimeStamp = 0;
    numberOfTaps = 0;
    isHold = false;
    setState(() {
      buttonColor = Colors.blue;
    });
  }

  Future<void> detectGesture(int currentTimestamp) async {
    int diff = currentTimestamp - lastTimeStamp;
    if (diff > 2000) {
      reset();
    }

    print('Number of taps: $numberOfTaps');
    print('globals.selectedOption' + globals.selectedOption);

    if (isHold && !isConfirming) {
      await globals.speak("You have selected supermarket layout. Confirm?");
      globals.selectedOption = 'supermarketLayout';
      isConfirming = true;
      // Delay the navigation to ConfirmWidget to allow speaking to complete
      await Future.delayed(
          const Duration(seconds: 4)); // Adjust the duration as needed
      reset();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmWidget()),
      );
    } else if (numberOfTaps == 2 && !isConfirming) {
      await globals.speak("You have selected supermarket location. Confirm?");
      globals.selectedOption = 'supermarketLocation';
      isConfirming = true;
      // Delay the navigation to ConfirmWidget to allow speaking to complete
      await Future.delayed(
          const Duration(seconds: 4)); // Adjust the duration as needed
      reset();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmWidget()),
      );
    } else if (numberOfTaps == 3 && !isConfirming) {
      await globals.speak("You have selected food detection. Confirm?");
      globals.selectedOption = 'foodDetection';
      isConfirming = true;
      // Delay the navigation to ConfirmWidget to allow speaking to complete
      await Future.delayed(
          const Duration(seconds: 3)); // Adjust the duration as needed
      reset();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmWidget()),
      );
    } else if (numberOfTaps == 4 && !isConfirming) {
      await globals.speak("You have selected reading. Confirm?");
      globals.selectedOption = 'reading';
      isConfirming = true;
      // Delay the navigation to ConfirmWidget to allow speaking to complete
      await Future.delayed(
          const Duration(seconds: 3)); // Adjust the duration as needed
      reset();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmWidget()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          numberOfTaps++;
          int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
          setState(() {
            buttonColor = Colors.green;
          });
          // Delay to account for possible multiple taps
          Future.delayed(const Duration(milliseconds: 1500), () async {
            await detectGesture(currentTimestamp);
          });
          lastTimeStamp = currentTimestamp;
        },
        onLongPress: () {
          isHold = true;
          int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
          setState(() {
            buttonColor = Colors.red;
          });
          Future.delayed(const Duration(milliseconds: 1500), () async {
            await detectGesture(currentTimestamp);
          });
          lastTimeStamp = currentTimestamp;
        },
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: buttonColor,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'Tap Me',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

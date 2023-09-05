import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../main.dart';
import '../globals.dart' as globals;
import 'glowingMicrophoneWidget.dart';
import 'confirmWidget.dart';

class VoiceAssistant extends StatefulWidget {
  const VoiceAssistant({super.key});

  @override
  _VoiceAssistantState createState() => _VoiceAssistantState();
}

class _VoiceAssistantState extends State<VoiceAssistant> {
  final SpeechToText speechToTextInstance = SpeechToText();
  String recordedText = '';
  bool speechEnabled = false;

  void initializeSpeechToText() async {
    speechEnabled = await speechToTextInstance.initialize();

    setState(() {});
  }

  void startListeningNow() async {
    await speechToTextInstance.initialize();
    await speechToTextInstance.listen(onResult: onSpeechToTextResult);
    setState(() {});
  }

  void stopListeningNow() async {
    await speechToTextInstance.stop();
    setState(() {});
  }

  void onSpeechToTextResult(SpeechRecognitionResult recognitionResult) async{

    // Check if the result is final
    if (recognitionResult.finalResult) {
      recordedText = recognitionResult.recognizedWords.toLowerCase();

      // Check if the recorded text matches one of the specified phrases
      if (recordedText == 'supermarket location' ||
          recordedText == 'supermarket layout' ||
          recordedText == 'food detection' ||
          recordedText == 'reading') {

        // Execute the corresponding action based on the recognized phrase
        if (recordedText == 'supermarket location') {
          // Handle Supermarket Location action
          await globals.speak("You have selected supermarket location. Confirm?");
          globals.selectedOption = 'supermarketLocation';
          // Delay the navigation to ConfirmWidget to allow speaking to complete
          await Future.delayed(
              const Duration(seconds: 4));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ConfirmWidget()),
          );

        } else if (recordedText == 'supermarket layout') {
          // Handle Supermarket Layout action
          await globals.speak("You have selected supermarket layout. Confirm?");
          globals.selectedOption = 'supermarketLayout';
          // Delay the navigation to ConfirmWidget to allow speaking to complete
          await Future.delayed(
              const Duration(seconds: 4));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ConfirmWidget()),
          );
        } else if (recordedText == 'food detection') {
          // Handle Food Detection action
          await globals.speak("You have selected food detection. Confirm?");
          globals.selectedOption = 'foodDetection';
          // Delay the navigation to ConfirmWidget to allow speaking to complete
          await Future.delayed(
              const Duration(seconds: 3));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ConfirmWidget()),
          );
        } else if (recordedText == 'reading') {
          // Handle Reading action
          await globals.speak("You have selected reading. Confirm?");
          globals.selectedOption = 'reading';
          // Delay the navigation to ConfirmWidget to allow speaking to complete
          await Future.delayed(
              const Duration(seconds: 2));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ConfirmWidget()),
          );
        }
      } else {
        // If the recorded text doesn't match, instruct the user to try again
        globals.speak("I'm Sorry! I couldn't understand. Please double-tap and speak again.");
      }
    }
  }


  @override
  void initState() {
    super.initState();

    globals.selectedOption = '';
    // Inform the user
    globals.speak('''Double-tap, and after the beep sound, say what you want. 
    To return to the home page again, swipe right.''');
  }

  @override
  Widget build(BuildContext context) {
    // Implement your Reading function UI here
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 227, 227),
      body: Stack(
        children: [
          GestureDetector(
            onDoubleTap: () {
              if (speechToTextInstance.isNotListening) {
                startListeningNow();
              }
            },
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                // Swipe Right Repeat
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              }
            },
          ),
          // Display the GlowingMicrophoneIcon as an overlay
          GlowingMicrophoneIcon(),
        ],
      ),
    );
  }
}

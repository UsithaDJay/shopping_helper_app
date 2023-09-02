library globals;

import 'package:flutter_tts/flutter_tts.dart';

String selectedOption = '';

FlutterTts flutterTts = FlutterTts();

Future<void> speak(String text) async {
    await flutterTts.stop();
    await flutterTts.speak(text);
  }

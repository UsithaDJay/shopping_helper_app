import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../widgets/cameraWidget.dart';
import '../globals.dart' as globals;
import 'package:logger/logger.dart';


class FoodDetectionFunction extends StatefulWidget {
  const FoodDetectionFunction({Key? key}) : super(key: key);

  @override
  _FoodDetectionFunctionState createState() => _FoodDetectionFunctionState();
}
  GlobalKey<CameraAppState> cameraWidgetKey = GlobalKey();
  String? _capturedImagePath;
  var logger = Logger();

class _FoodDetectionFunctionState extends State<FoodDetectionFunction> {
  @override
  void initState() {
    super.initState();

    // Inform the user about returning
    globals.speak("You are now in the Food Detection Functionality. You can return to Home Page anytime by Swiping right.");
  }

  Future<void> captureAndSendImage(String path) async {
    File image = File(path);
    var url = "http://73e8-35-247-9-74.ngrok-free.app/detect_food";

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();
    if (response.statusCode == 200) {
        var result = jsonDecode(await response.stream.bytesToString());
        String _class = result['highest_confidence_class'];
        String _confidence = result['confidence'].toString();
        logger.i("Highest confidence class: ${result['highest_confidence_class']}");
        logger.i("Confidence: ${result['confidence']}");
        if (_class == "Ripe"){_class = "Fresh Pinapple";}
        else if(_class == "Semi_Ripe"){_class = "Half Fresh Pinapple";}
        else if(_class == "Un_Ripe") {_class = "Unfresh Pinapple";}
        globals.speak(_class);
    }
    setState(() {
    _capturedImagePath = null;
  });
}
  void onImageCapture(String path) {
    logger.i("Image captured at path: $path");
    setState(() {
      _capturedImagePath = path;
    });
    captureAndSendImage(_capturedImagePath!).then((_) {
      setState(() {
    _capturedImagePath = null;
    logger.i("Image path set to null");
    });
      // cameraWidgetKey.currentState?.restartCamera();
    });
  }


  void returnToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Detection Function'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            returnToHomePage();
          }
        },
        // child: CameraApp(
        //   onImageCapture: (path) async {
        //     await captureAndSendImage(path);
        //   }, cameraWidgetKey: cameraWidgetKey,
        // ),
        child: CameraApp(cameraWidgetKey: cameraWidgetKey, onImageCapture: onImageCapture),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../widgets/cameraWidget.dart';
import '../globals.dart' as globals;

class FoodDetectionFunction extends StatefulWidget {
  const FoodDetectionFunction({Key? key}) : super(key: key);

  @override
  _FoodDetectionFunctionState createState() => _FoodDetectionFunctionState();
}
  GlobalKey<CameraAppState> cameraWidgetKey = GlobalKey();


class _FoodDetectionFunctionState extends State<FoodDetectionFunction> {
  @override
  void initState() {
    super.initState();

    // Inform the user about returning
    globals.speak("You are now in the Food Detection Functionality. You can return to Home Page anytime by Swiping right.");
  }

  Future<void> captureAndSendImage(String path) async {
    File image = File(path);
    var url = "http://192.168.92.79:80/detect";

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();
    if (response.statusCode == 200) {
        var result = jsonDecode(await response.stream.bytesToString());
        String _class = result['highest_confidence_class'];
        String _confidence = result['confidence'].toString();
        print("Highest confidence class: ${result['highest_confidence_class']}");
        print("Confidence: ${result['confidence']}");
        globals.speak(_class);
    }
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
        child: CameraApp(
          onImageCapture: (path) async {
            await captureAndSendImage(path);
          }, cameraWidgetKey: cameraWidgetKey,
        ),
      ),
    );
  }
}

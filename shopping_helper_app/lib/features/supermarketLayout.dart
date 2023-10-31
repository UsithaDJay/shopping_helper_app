import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'package:shopping_helper_app/widgets/cameraWidget.dart';
import 'package:shopping_helper_app/widgets/scan_controller.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';

import '../globals.dart' as globals;

class SupermarketLayoutFunction extends StatefulWidget {
  const SupermarketLayoutFunction({Key? key}) : super(key: key);

  @override
  _SupermarketLayoutFunctionState createState() => _SupermarketLayoutFunctionState();
}

class _SupermarketLayoutFunctionState extends State<SupermarketLayoutFunction> {
  String? _capturedImagePath;
  var logger = Logger();
  GlobalKey<CameraAppState> cameraWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    globals.speak("You are now in the Supermarket layout Functionality. You can return to Home Page anytime by Swiping right.");
  }

  //  Future<void> captureAndSendImage1(String path) async {
  //   File image = File(path);
  //   var url = "http://192.168.92.79:80/layout";

  //   var request = http.MultipartRequest('POST', Uri.parse(url));
  //   request.files.add(await http.MultipartFile.fromPath('image', image.path));

  //   var response = await request.send();
  //   if (response.statusCode == 200) {
  //       var result = jsonDecode(await response.stream.bytesToString());
  //       String _class = result['highest_confidence_class'];
  //       String _confidence = result['confidence'].toString();
  //       print("Highest confidence class: ${result['highest_confidence_class']}");
  //       print("Confidence: ${result['confidence']}");
  //       globals.speak(_class);
  //   }
  //   setState(() {
  //     _capturedImagePath = null;
  //   });
  // }
  Future<void> captureAndSendImage2(String path) async {
  File image = File(path);
  var colabUrl = "http://73e8-35-247-9-74.ngrok-free.app/detect_layout"; // Replace with the actual URL of your Colab service's /predict endpoint.

  // Read the image file as bytes
  List<int> imageBytes = await image.readAsBytes();

  // Convert the image bytes to base64
  String imageBase64 = base64Encode(imageBytes);

  // Prepare the request body with just the image data
  Map<String, String> requestBody = {
    "img_base64": imageBase64,
  };
  logger.i(requestBody);

  try {
    var response = await http.post(
      Uri.parse(colabUrl),
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
      },
      body: jsonEncode(requestBody), // Encode the request body as JSON
    );

    if (response.statusCode == 200) {
      logger.i("Response body: ${response.body}");
      List<dynamic> result = jsonDecode(response.body);

      if (result.isNotEmpty) {
        String _class = result[0];
        double _confidence = result[1];

        logger.i("Highest confidence class: $_class");
        logger.i("Confidence: $_confidence");
        globals.speak(_class);
      } else {
        logger.i("Invalid response format from Colab service");
      }
    } else {
      logger.e("Error: ${response.statusCode}");
    }
  } catch (error) {
    logger.e("Error: $error");
  }

  setState(() {
    _capturedImagePath = null;
  });
}

  // Future<void> captureAndSendImage(String path) async {
  //   logger.i('captureAndSendImage called with path: $path');
  //   final scanController = Get.put(ScanController());

  //   List<dynamic>? results = await scanController.objectDetector1(path);
  
  //  if (results != null && results.isNotEmpty) {
  //   var highestConfidenceResult = results.reduce((current, next) => current['confidenceInClass'] > next['confidenceInClass'] ? current : next);
  //   String detectedClass = highestConfidenceResult['detectedClass'];
  //   double confidence = highestConfidenceResult['confidenceInClass'];

  //   logger.i("Highest confidence class: $detectedClass");
  //   logger.i("Confidence: $confidence");
  //   globals.speak(detectedClass);
  // } else {
  //   logger.i("No objects detected");
  //   globals.speak("No objects detected");
  // }
  // }
  void onImageCapture(String path) {
    logger.i("Image captured at path: $path");
    setState(() {
      _capturedImagePath = path;
    });
    captureAndSendImage2(_capturedImagePath!).then((_) {
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
        title: const Text('Supermarket Layout Function'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            returnToHomePage();
          }
        },
        child: CameraApp(cameraWidgetKey: cameraWidgetKey, onImageCapture: onImageCapture),
      ),
    );
  }
}

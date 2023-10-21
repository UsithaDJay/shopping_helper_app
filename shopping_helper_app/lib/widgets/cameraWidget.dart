import 'dart:math';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'package:tflite/tflite.dart';
import 'package:logger/logger.dart';

class CameraApp extends StatefulWidget {
  final Function(String path)? onCapture;

  CameraApp({Key? key, this.onCapture}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;
  late CameraImage cameraImage;

  var cameraCount = 0;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      // Initialize your camera description here.
      const CameraDescription(
        name: "0",
        lensDirection: CameraLensDirection.back,
        sensorOrientation: 1,
      ),
      // Define the resolution to use.
      ResolutionPreset.max,
    ); // To display the current output from the Camera,
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = controller.initialize().then((value) => null);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  // New Method to capture image
  Future<void> captureImage() async {
    await _initializeControllerFuture;

    final XFile image = await controller.takePicture();

    if (widget.onCapture != null) {
      widget.onCapture!(image.path);
    }
  }
  // Object detector
  // objectDetector(CameraImage image) async {
  //   var detector = await Tflite.runModelOnFrame(
  //     bytesList: image.planes.map((e){
  //     return e.bytes;
  //   }).toList(),
  //   asynch: true,
  //   imageHeight : image.height,
  //   imageWidth : image.width,
  //   imageMean: 127.5,
  //   imageStd: 127.5,
  //   numResults: 1,
  //   rotation: 90,
  //   threshold:0.4,
  //   );
  //   if (detector != null) {
  //     logger.i("Result is $detector");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: captureImage,
        child: Icon(Icons.camera),
      ),
    );
  }
}

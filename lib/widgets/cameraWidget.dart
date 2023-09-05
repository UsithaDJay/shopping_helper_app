import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraApp extends StatefulWidget {

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    // // Obtain a list of the available cameras on the device.
    // availableCameras().then((cameras) {
    //   // Get a specific camera from the list of available cameras.
    //   final firstCamera = cameras.first;
      controller = CameraController(
        CameraDescription(
          name: "0",
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 1,
        ),
        // Define the resolution to use.
        ResolutionPreset.medium,
      );

    _initializeControllerFuture = controller.initialize();  
    super.initState();
    //   // Next, initialize the controller. This returns a Future.
    //   _initializeControllerFuture = controller.initialize();
    // });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

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
    );
  }
}
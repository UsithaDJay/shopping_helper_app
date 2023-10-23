import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shopping_helper_app/widgets/scan_controller.dart';
// import logger
import 'package:permission_handler/permission_handler.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: GetBuilder<ScanController>(
        init: ScanController(), 
        builder: (controller) {
            return controller.isCameraInitialized.value
                ? CameraPreview(controller.cameraController)
                : const Center(child: CircularProgressIndicator());
          }
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: captureImage,
      //   child: Icon(Icons.camera),
      // ),
    );
  }
}
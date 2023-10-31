import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';
import '../globals.dart' as globals;

class CameraApp extends StatefulWidget {
  final Function(String path)? onImageCapture;
  final GlobalKey<CameraAppState> cameraWidgetKey;

  CameraApp({required this.cameraWidgetKey, this.onImageCapture}) : super(key: cameraWidgetKey);

  @override
  State<CameraApp> createState() => CameraAppState();
}

class CameraAppState extends State<CameraApp> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;
  var logger = Logger();
  String? _capturedImagePath;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }
  Future<void> initializeCamera() async {
    controller = CameraController(
      const CameraDescription(
        name: "0",
        lensDirection: CameraLensDirection.back,
        sensorOrientation: 1,
      ),
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _initializeControllerFuture = controller.initialize();
    logger.i("Camera initialized");
    setState(() {});
  }

  Future<void> captureImage() async {
    if (_isDetecting) {
      logger.i("Still detecting");
      globals.speak("Still detecting");
      return;
    }
    try {
      _isDetecting = true;
      await _initializeControllerFuture;
      final XFile image = await controller.takePicture();
      setState(() {
        _capturedImagePath = image.path;
      });
      globals.speak("Starting detection");
      await widget.onImageCapture?.call(_capturedImagePath!);
    } catch(e) {
      logger.e('Error Capturing Image: $e');
    } finally {
      _isDetecting = false;
      _capturedImagePath = null;
    }
  }

  Future<void> restartCamera() async {
    await controller.dispose();
    logger.i("Camera disposed");
    await Future.delayed(Duration(milliseconds: 1000)); 
    await initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    logger.i("Camera build called,_capturedImagePath: $_capturedImagePath");
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onDoubleTap: captureImage,
            child: _capturedImagePath == null
                ? CameraPreview(controller)
                : Image.file(File(_capturedImagePath!)),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
// import 'package:image/image.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_v2/tflite_v2.dart' as tfl;
import 'package:logger/logger.dart';
import 'dart:typed_data';
// import 'package:image_to_byte/image_to_byte.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // initCamera();
    initTFLite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var isCameraInitialized = false.obs;
  var logger = Logger();
  var cameraCount = 0;
  var isProcessing = false;

  // initCamera() async {
  //   if (await Permission.camera.request().isGranted) {
  //     cameras = await availableCameras();
  //     cameraController = CameraController(
  //       const CameraDescription(
  //         name: "0",
  //         lensDirection: CameraLensDirection.back,
  //         sensorOrientation: 1,
  //       ),
  //       ResolutionPreset.max,
  //       enableAudio: false,
  //       // imageFormatGroup: ImageFormatGroup.jpeg,
  //     );
  //     logger.i("Camera initialized");
  //     await cameraController.initialize().then((value) {
  //       // Start the camera stream
  //       cameraController.startImageStream((image) {
  //         cameraCount++;
  //         if (cameraCount % 10 == 0) {
  //           cameraCount = 0;
  //           objectDetector(image);
  //         }
  //         update();
  //       });
  //     });
  //     isCameraInitialized.value = true;
  //     update();
  //   } else {
  //     logger.i("Permission denied");
  //   }
  // }


  // ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // Here if I used my model it won't work. 
  // My model's output sizes of my object detection model and the output sizes of the image doesn't work. I also cannot use the model provided by the tflite_v2 package too.
  // Model mobilenet is used to image classifications. Their output sizes also doesn't match properly. I couldn't find a way to change the output size of the model.
  // I also couldn't find a method to change the output sizes of runmodeloBinary... etc functions.
  // But I strongly suspect that this can be done through the tflite_flutter package. But I couldn't find a way to do it.
  // For now just follow the medium article in E:\WebDev\UIUX\FLutter\Developments\Blind-people app\Object_detection_app
  // ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  initTFLite() async {
    await tfl.Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/ssd_mobilenet.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
    if(tfl.Tflite == null){
        logger.e("TFLite not initialized");
    }
  }

  // Object detector for detecting images real time. Not used in the app
  // objectDetector(CameraImage image) async {
  //   // if (isProcessing) {
  //   //   logger.i("Skipping frame, previous inference is still running");
  //   //   return;
  //   // }

  //   // isProcessing = true;
  //   // logger.i('image size : ${image.width} x ${image.height}');

  //   try {
  //     // Resize the image and convert it to Float32List
  //     img.Image resizedImage = img.copyResize(
  //       img.Image.fromBytes(
  //         bytes: Uint8List.fromList(image.planes.map((plane) => plane.bytes).expand((bytes) => bytes).toList()).buffer,
  //         height: image.height, 
  //         width: image.width,
  //         //  format: img.Format.uint8, 
  //       ),
  //       width: 800,
  //       height: 800,
  //     );
  //     logger.i('resized image size : ${resizedImage.width}*${resizedImage.height}');


  //     Float32List imageAsFloat32List = imageToFloat32List(resizedImage);
  //     logger.i('Float32List buffer size: ${imageAsFloat32List.length}');
      
  //     var results = await tfl.Tflite.runModelOnFrame(
  //       bytesList: [imageAsFloat32List.buffer.asUint8List()],
  //       imageHeight: 800,
  //       imageWidth: 800,
  //       imageMean: 127.5,
  //       imageStd: 127.5,
  //       rotation: 90,
  //       numResults: 2,
  //       threshold: 0.1,
  //       asynch: true,
  //     );

  //     if (results != null) {
  //       logger.i("Result is $results");
  //     }
  //   } catch (e) {
  //     logger.e("Error running model: $e");
  //     // logger.i(e);
  //   } finally {
  //     isProcessing = false;
  //   }
  // }

  Future<File> resizeImage(File originalImage , int width, int height) async {
  // Decode the image to an img.Image object
  final img.Image image = img.decodeImage(originalImage.readAsBytesSync())!;

  // Resize the image to 800x800
  final img.Image resizedImage = img.copyResize(image, width: width, height: height);

  // Get the temporary directory of the device
  final Directory tempDir = await getTemporaryDirectory();
  final String tempPath = tempDir.path;

  // Save the resized image as a PNG file
  final File resizedFile = File('$tempPath/resized_image.png')
    ..writeAsBytesSync(img.encodePng(resizedImage));

  return resizedFile;
}

  objectDetector1(String capturedImagePath)  async {
    try {
      final File resizedImageFile = await resizeImage(File(capturedImagePath), 800, 800);
      final img.Image resizedImage = img.decodeImage(resizedImageFile.readAsBytesSync())!;
      // final String resizedImagePath = resizedImage.path;
      Uint8List imageBuffer = imageToFloat32List(resizedImage);
      logger.i('Image is Resized. Image buffer size: ${imageBuffer.length}');
      // Uint8List resizedImageBytes = await imageToByte(resizedImagePath);

      // var results = await tfl.Tflite.runModelOnBinary(
      //   binary: imageBuffer,  // default 127.5
      //   threshold: 0.05,
      //   numResults: 2,
      //   asynch: true,
      // );
      var results = await tfl.Tflite.detectObjectOnImage(
        path: resizedImageFile.path,
        model: "SSDMobileNet",
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.4,
        numResultsPerClass: 1,
        asynch: true,
      );


      if (results != null) {
        logger.i("Result is $results");
        return results;
      }
      else{
        logger.i("Result is null");
      }
    } catch (e) {
      logger.e("Error running model: $e");
      // logger.i(e);
    } finally {
      isProcessing = false;
    }
  }

  Uint8List imageToFloat32List(img.Image image) {
    logger.d('image width x height: ${image.width} * ${image.height}');
    var convertedBytes = Float32List(1 * 3 * image.width * image.height);
    var buffer = Float32List.view(convertedBytes.buffer);
    // var buffer = Float32List(3*image.width*image.height);
    int pixelIndex = 0;
    for (int i = 0; i < image.height; i++) {
      for (int j = 0; j < image.width; j++) {
        var pixel = image.getPixel(j, i);
        // buffer[pixelIndex++] = 5;
        // buffer[pixelIndex++] = 5;
        // buffer[pixelIndex++] = 5;
        buffer[pixelIndex++] = ((pixel.r - 127.5) / 127.5);
        buffer[pixelIndex++] = ((pixel.g - 127.5) / 127.5);
        buffer[pixelIndex++] = ((pixel.b - 127.5) / 127.5);
      }
    }
    return convertedBytes.buffer.asUint8List();
  }
}

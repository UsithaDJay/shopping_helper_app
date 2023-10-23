// // import 'dart:typed_data';

// // import 'package:camera/camera.dart';
// // import 'package:image/image.dart' as img;
// // import 'package:tflite_flutter/tflite_flutter.dart';

// // class TFLiteHelper {
// //   late Interpreter interpreter;

// //   Future<void> initTFLite() async {
// //     interpreter = await Interpreter.fromAsset('model.tflite');
// //   }

// //   Future<void> objectDetector(CameraImage image) async {
// //     // Convert the CameraImage to a format that can be used with TensorFlow Lite
// //     // This assumes the image is in YUV420 format
// //     img.Image convertedImage = img.Image.fromBytes(
// //       height: image.height, 
// //       width: image.width,
// //       // bytes: convertObjecttoBytes(image),
// //       bytes: Uint8List.fromList(image.planes.map((e) => e.bytes).expand((bytes) =>bytes).toList()).buffer ,  
// //     );

// //     // Convert the image to a float32 list
// //     Float32List input = imageToByteListFloat32(
// //       convertedImage,
// //       127.5, // imageMean
// //       127.5, // imageStd
// //     );

// //     // Prepare the output tensor
// //     final output = List.generate(1, (index) => Float32List(4));

// //     // Run the model
// //     interpreter.run(input, output);

// //     // Print the results
// //     print(output);
// //   }

// //   Float32List imageToByteListFloat32(img.Image image, double imageMean, double imageStd) {
// //     var convertedBytes = Float32List(1 * image.width * image.height * 3);
// //     var buffer = Float32List.view(convertedBytes.buffer);
// //     int pixelIndex = 0;
  
// //     for (int i = 0; i < image.height; i++) {
// //       for (int j = 0; j < image.width; j++) {
// //         var pixel = image.getPixel(j, i);
// //         buffer[pixelIndex++] = ((img.getRed(pixel)) - imageMean) / imageStd;
// //         buffer[pixelIndex++] = ((img.getGreen(pixel)) - imageMean) / imageStd;
// //         buffer[pixelIndex++] = ((img.getBlue(pixel)) - imageMean) / imageStd;
// //       }
// //     }
// //     return convertedBytes.buffer.asFloat32List();
// //   }
// // }
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:image/image.dart' as img;
// import 'package:logger/logger.dart';

//  var logger = Logger();

// Future<img.Image?> processCameraImage(CameraImage image) async {
//   try {
//     // Convert the YUV420 image to RGB
//     final img.Image? convertedImage = convertYUV420ToImage(image);
//     if (convertedImage == null) {
//       print('Could not convert image.');
//       return null;
//     }

//     // Resize the image
//     img.Image resizedImage = img.copyResize(
//       convertedImage,
//       width: 800,
//       height: 800,
//     );

//     return resizedImage;
//   } catch (e) {
//     logger.i('Error processing camera image: $e');
//     return null;
//   }
// }

// img.Image? convertYUV420ToImage(CameraImage image) {
//   try {
//     final int width = image.width;
//     final int height = image.height;
//     final int uvRowStride = image.planes[1].bytesPerRow;
//     final int? uvPixelStride = image.planes[1].bytesPerPixel;

//     // img.Image library does not support YUV format yet, so we convert it to RGB
//     var imgLib = img.Image(height: height,width: width); // Create Image buffer

//     for (int x = 0; x < width; x++) {
//       for (int y = 0; y < height; y++) {
//         final int uvIndex = uvPixelStride! * (x / 2).floor() + uvRowStride * (y / 2).floor();
//         final int index = y * width + x;

//         final yp = image.planes[0].bytes[index];
//         final up = image.planes[1].bytes[uvIndex];
//         final vp = image.planes[2].bytes[uvIndex];

//         // Calculate pixel color
//         imgLib.data[index] = img.getColorFromYuv(yp, up, vp);
//       }
//     }
//     return imgLib;
//   } catch (e) {
//     print('Error converting YUV420 image: $e');
//     return null;
//   }
// }



import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';



class ScanController extends GetxController {
    void onInit() {
      super.onInit();
      initCamera();
    }
    @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController.dispose();
  }

    late CameraController cameraController;
    late List<CameraDescription> cameras;
    var isCameraInitialized = false.obs;

    initCamera() async {
      if(await Permission.camera.request(). isGranted) {
        cameras = await availableCameras();
        cameraController = CameraController(
          const CameraDescription(
          name: "0",
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 1,
        ),
        ResolutionPreset.max);
        await cameraController.initialize();
        isCameraInitialized.value = true;
        update();
      } else{
        print("permission denied");
      }
    }
 }
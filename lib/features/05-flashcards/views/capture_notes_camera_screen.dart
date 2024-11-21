import 'package:camera/camera.dart';
import 'package:chumzy/data/models/flashcard_model.dart';
import 'package:chumzy/data/models/subject_model.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CaptureNotesCameraScreen extends StatefulWidget {
  CaptureNotesCameraScreen({super.key, required this.subject, required this.topic});

  Topic topic;
  Subject subject;

  @override
  State<CaptureNotesCameraScreen> createState() =>
      _CaptureNotesCameraScreenState();
}

class _CaptureNotesCameraScreenState extends State<CaptureNotesCameraScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Get the list of available cameras
      cameras = await availableCameras();

      if (cameras != null && cameras!.isNotEmpty) {
        // Initialize the camera controller for the first available camera
        _cameraController = CameraController(
          cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );

        // Initialize the camera and update the UI
        await _cameraController?.initialize();
        setState(() {
          isCameraInitialized = true;
        });
      }
    } catch (e) {
      _logError('Camera Initialization', e.toString());
    }
  }

  void _logError(String code, String? message) {
    print('Error: $code${message == null ? '' : '\nError Message: $message'}');
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    try {
      // Capture the image and save it to a file
      final image = await _cameraController!.takePicture();

      // Handle the captured image (e.g., display, save, or upload it)
      print('Image captured: ${image.path}');
    } catch (e) {
      _logError('Capture Image', e.toString());
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(right: 30.w, left: 30.w, bottom: 0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Capture your notes",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              Gap(20.h),
              Expanded(
                child: isCameraInitialized
                    ? CameraPreview(_cameraController!)
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              Gap(20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _captureImage,
                    child: Icon(Icons.camera_alt_rounded, size: 24.r),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(15.r),
                    ),
                  ),
                ],
              ),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:chumzy/core/widgets/buttons/custom_btn.dart';
import 'package:chumzy/data/models/subject_model.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:chumzy/data/providers/flashcard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class CaptureNotesCameraScreen extends StatefulWidget {
  CaptureNotesCameraScreen({
    super.key,
    required this.subject,
    required this.topic,
  });

  final Subject subject; // Replace with Subject model if needed
  final Topic topic; // Replace with Topic model if needed

  @override
  State<CaptureNotesCameraScreen> createState() =>
      _CaptureNotesCameraScreenState();
}

class _CaptureNotesCameraScreenState extends State<CaptureNotesCameraScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  XFile? capturedImage; // Holds the captured image
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();

      if (cameras != null && cameras!.isNotEmpty) {
        _cameraController = CameraController(
          cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );

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
      final image = await _cameraController!.takePicture();
      final Uint8List imageBytesTemp = await image.readAsBytes();

      setState(() {
        capturedImage = image; // Save the captured image
        isCameraInitialized = false; // Stop the camera preview
        imageBytes = imageBytesTemp;
      });
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
    //Card Provider
    var cardProvider = Provider.of<CardProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Show the captured image or an empty placeholder
            if (capturedImage != null)
              Container(
                height: 550.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: FileImage(File(capturedImage!.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              // Show the camera preview when no image is captured
              Expanded(
                flex: 3,
                child: isCameraInitialized
                    ? CameraPreview(_cameraController!)
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            const SizedBox(height: 20),
            // Button Section
            Column(
              children: [
                ElevatedButton(
                  onPressed: _captureImage,
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 24.r,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(15.r),
                  ),
                ),
                if (capturedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: "Retake",
                        onPressed: () {
                          setState(() {
                            capturedImage = null; // Reset to camera preview
                            isCameraInitialized = true;
                            _initializeCamera(); // Reinitialize the camera
                          });
                        },
                      ),
                    ),
                  ),
                const Gap(10),
                if (capturedImage != null)
                  CustomButton(
                    text: "Generate Card",
                    onPressed: () {
                      if (imageBytes == null) {
                        return;
                      }
                      cardProvider.generateFlashcardsByCaptureImage(
                        context,
                        widget.subject,
                        widget.topic,
                        imageBytes,
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

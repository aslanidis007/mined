import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';

import 'camera_view.dart';
import 'util/data.dart';
import 'util/face_detector_painter.dart';

class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({super.key});

  @override
  State<FaceDetectorPage> createState() => _FaceDetectorPageState();
}

class _FaceDetectorPageState extends State<FaceDetectorPage> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableTracking: true,
      enableLandmarks: true,
      enableClassification: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  int counter = 0;
  bool? check;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Face Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: (inputImage) {
        processImage(inputImage);
      },
      initialDirection: CameraLensDirection.front,
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      counter++;
      Provider.of<RecordData>(context, listen: false).setData(counter, check);
    });
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy) return;

    _isBusy = true;
    setState(() {
      _text = "";
    });

    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
      );
      _customPaint = CustomPaint(painter: painter);
      check = faces.any((face) =>
          face.headEulerAngleY != null &&
          face.headEulerAngleZ != null &&
          face.headEulerAngleX != null &&
          face.leftEyeOpenProbability != null &&
          face.rightEyeOpenProbability != null &&
          (face.headEulerAngleY! > -13 && face.headEulerAngleY! < 13) &&
          (face.headEulerAngleZ! > -11 && face.headEulerAngleZ! < 11) &&
          (face.headEulerAngleX! > -11 && face.headEulerAngleX! < 11) &&
          (face.boundingBox.top > 310 && face.boundingBox.bottom < 1050) &&
          (face.boundingBox.left > 45 && face.boundingBox.right < 740) &&
          face.leftEyeOpenProbability! > 0.5 &&
          face.rightEyeOpenProbability! > 0.5);
    } else {
      check = false;
      _customPaint = null;
    }

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}

import 'dart:async';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:mined/constants/color.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../main.dart';
import '../routes/routes.dart';
import 'start_record/end_record.dart';

class CameraView extends StatefulWidget {
  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final Function(InputImage inputImage) onImage;
  final CameraLensDirection initialDirection;

  const CameraView({
    super.key,
    required this.title,
    required this.onImage,
    required this.initialDirection,
    this.customPaint,
    this.text,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _cameraController;
  int _cameraIndex = 0;
  // AudioPlayer player = AudioPlayer();
  int count = 0;
  int type = 0;
  bool startPlay = false;
  Timer? _timer;
  Timer? _timerRecord;
  int _start = 10;
  int _startRecord = 30;
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
    startCount(context);
  }

  @override
  void dispose() {
    _stopCameraStream();
    _timer?.cancel();
    _timerRecord?.cancel();
    _cameraController?.dispose();
    // player.dispose();
    super.dispose();
  }

  void startTimer(BuildContext context) {
     _startRecording();
    WakelockPlus.enable();
    const oneSec = Duration(seconds: 1);
    _timerRecord = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_startRecord == 0) {
          setState(() {
            timer.cancel();
          });
          _exportFrames(context);
        } else {
          setState(() {
            _startRecord--;
          });
        }
      },
    );
  }
  void startCount(BuildContext context) {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
          startTimer(context);
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Future<void> _initializeCamera() async {
    _cameraIndex = cameras.indexWhere((camera) =>
      camera.lensDirection == widget.initialDirection &&
      camera.sensorOrientation == 99,
    );

    if (_cameraIndex == -1) {
      _cameraIndex = cameras.indexWhere((camera) =>
          camera.lensDirection == widget.initialDirection);
    }
    _startLive();
  }

  Future<void> _startLive() async {
    final camera = cameras[_cameraIndex];
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;

      _cameraController!.startImageStream(_processCameraImage);
      setState(() {});
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _stopCameraStream() async {
    try {
      await _cameraController?.stopImageStream();
    } catch (e) {
      debugPrint('Error stopping camera stream: $e');
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final camera = cameras[_cameraIndex];
    final imageRotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation) ?? InputImageRotation.rotation0deg;
    final inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;

    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageData,
    );

    widget.onImage(inputImage);
  }

  Future<void> _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (_cameraController!.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return ;
    }
    await _stopCameraStream();
    try {
      _cameraController!.startVideoRecording();

      setState(() {startPlay = true;});
    } catch (e) {
      log('Error starting video recording: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkMov,
        title: Text(widget.title),
        actions: [
         Column(
          mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Padding(
               padding: const EdgeInsets.only(right: 20.0),
               child: Text(
                  '$_startRecord sec',
                  style: const TextStyle(
                    color: AppColors.lightGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0
                  ),
                  textAlign: TextAlign.center,
                ),
             ),
           ],
         ),
        ],
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
              _cameraPreview(),
              Positioned(
                top: 0,
                left: 50,
                right: 50,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  decoration: const BoxDecoration(
                    color: AppColors.darkMov,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50)
                    )
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Stay in the circle for 10 seconds',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            if(_start != 0)
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    '$_start',
                    style: const TextStyle(
                      color: AppColors.darkMov,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            // Positioned(
            //   bottom: 50,
            //   left: 120,
            //   right: 120,
            //   child: InkWell(
            //     onTap: (){
            //       _startRecording();
            //       startTimer(context);
            //         setState(() {
            //           startPlay = true;
            //         });
            //     },
            //     child: Container(
            //       padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15.0),
            //       decoration: const BoxDecoration(
            //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //         color: AppColors.darkMov
            //       ),
            //       child: const Column(
            //         children: [
            //           Text(
            //             'Start',
            //             style: TextStyle(
            //               color: AppColors.white,
            //               fontSize: 18.0,
            //               fontWeight: FontWeight.bold
            //             ),
            //             textAlign: TextAlign.center,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _cameraPreview() {
    if (_cameraController?.value.isInitialized == false) {
      return Container();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_cameraController!),
        if (widget.customPaint != null)...[
          if(startPlay == false)
          widget.customPaint!
        ]
      ],
    );
  }

  Future<void> _exportFrames(BuildContext context) async {
    if (_cameraController == null || !_cameraController!.value.isRecordingVideo) {
      return;
    }
    showDialog(
      barrierColor: Colors.black.withOpacity(0.7),
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return  AlertDialog(
          backgroundColor: AppColors.mov,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
          ),
          scrollable: true,
          contentPadding: const EdgeInsets.only(top: 50.0, bottom: 50.0, left: 20.0, right: 20.0),
          content: const Column(
            children: [
              Text(
                "This may take a few moments. Please wait while we are processing your data....",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white
                ),
              ),
              SizedBox(height: 12.0,),
              LinearProgressIndicator(color: AppColors.white, backgroundColor: AppColors.darkMov,),
            ],
          ),
        );
      },
    );
    try {
      XFile videoFile = await _cameraController!.stopVideoRecording();

      log(videoFile.path.toString());

      Navigator.pop(context); // Close the dialog

      PageNavigator(ctx: context).nextPageOnly(
        page: EndRecord(
          btnName: 'Complete',
          title: 'End Record',
          description: 'Test description',
          videoPath: videoFile.path,
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close the dialog in case of error
      log("Error during conversion: $e");
      // Optionally, show an error dialog here
    }
  }
}

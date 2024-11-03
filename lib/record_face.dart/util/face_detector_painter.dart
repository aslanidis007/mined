import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorPainter extends CustomPainter {
  final List<Face> faces;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  FaceDetectorPainter(this.faces, this.absoluteImageSize, this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    for (final Face face in faces) {
      Offset center = Offset(size.width / 2, size.height / 2);
      double ovalWidth = 280;
      double ovalHeight = 400;
      Rect ovalRect = Rect.fromCenter(center: center, width: ovalWidth, height: ovalHeight);
      if (face.headEulerAngleY != null && face.headEulerAngleZ != null && face.headEulerAngleX != null && face.leftEyeOpenProbability != null && face.rightEyeOpenProbability != null) {
        if ((face.headEulerAngleY! > - 13 && face.headEulerAngleY! < 13) &&
            (face.headEulerAngleZ! > - 11 && face.headEulerAngleZ! < 11) &&
            (face.headEulerAngleX! > - 11 && face.headEulerAngleX! < 11) &&
            (face.boundingBox.top > 330 &&
              face.boundingBox.bottom < 1000) && 
            (face.boundingBox.left > 50 && 
              face.boundingBox.right < 730)
          ) {
          circlePaint.color = Colors.green;
        } else {
          circlePaint.color = Colors.red;
        }        
        canvas.drawOval(
          ovalRect,
          circlePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.faces != faces || oldDelegate.absoluteImageSize != absoluteImageSize;
  }
}

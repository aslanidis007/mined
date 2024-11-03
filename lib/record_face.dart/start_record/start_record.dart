import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../constants/assets.dart';
import '../../../constants/color.dart';
import '../../translations/locale_keys.g.dart';
import '../face_detector_page.dart';
import 'package:mined/routes/routes.dart';

class StartRecord extends StatefulWidget {
  final String title;
  final String body;
  final Widget page;
  const StartRecord({super.key, required this.title, required this.body, required this.page});

  @override
  State<StartRecord> createState() => _StartRecordState();
}

class _StartRecordState extends State<StartRecord> {


  void _startFaceDetection(BuildContext context) async {
    final statuses = await [
      Permission.camera,
    ].request();
    if (statuses.values.every((status) => status.isGranted)) {
      PageNavigator(ctx: context).nextPage(page: const FaceDetectorPage());
    } else {
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissions denied'),
        content: const Text('You dont granted permissions'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white.withOpacity(0.95),
      body: Stack(
        children: [
          _buildHeader(),
          _buildBody(w, h),
          _buildFooter(w),
          _buildTopIcon(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 55.0, bottom: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.close,
              size: 38,
              color: AppColors.lightMov,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(double w, double h) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: w,
        height: h * 0.88,
        padding: EdgeInsets.only(top: h * 0.18, left: 20, right: 20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Face detection test',
              style: TextStyle(
                color: AppColors.mov,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              widget.title,
              style: const TextStyle(
                color: AppColors.darkMov,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15.0),
            Text(
              widget.body,
              style: const TextStyle(
                color: AppColors.lightMov,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(double w) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: (() => _startFaceDetection(context)),
        child: Container(
          margin: const EdgeInsets.only(bottom: 40),
          padding: const EdgeInsets.symmetric(vertical: 20),
          width: w * 0.8,
          decoration: BoxDecoration(
            color: AppColors.lightGreen,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: AppColors.lightGreen.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            LocaleKeys.startrecording.tr(context: context),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTopIcon() {
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: SvgPicture.asset(
        AppAssets.tap,
        width: 110,
        height: 145,
      ),
    );
  }
}

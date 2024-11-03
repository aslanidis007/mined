import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mined/screens/widgets/header.dart';
import 'package:mined/translations/locale_keys.g.dart';
import '../../constants/color.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Widgets.header(context, w, h, LocaleKeys.privacyPolicyTitle.tr(context: context)),
            const SizedBox(height: 25,),
            SizedBox(
              width: w,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Text(
                      LocaleKeys.privacyPolicyTitle.tr(context: context),
                      style: const TextStyle(
                        color: AppColors.darkMov,
                        fontSize: 24,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    const SizedBox(height: 40,),
                    Text(
                      LocaleKeys.lastUpdatePrivacy.tr(context: context),
                      style: const TextStyle(
                        color: AppColors.darkMov,
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Text(
                     LocaleKeys.privacyFirstInformation.tr(context: context),
                      style: const TextStyle(
                        color: AppColors.lightMov,
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 15,),
                    Text(
                     LocaleKeys.summaryOfKeysPrivacy.tr(context: context),
                      style: const TextStyle(
                        color: AppColors.lightMov,
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 15,),
                    Text(
                     LocaleKeys.tableContentsPrivacy.tr(context: context),
                      style: const TextStyle(
                        color: AppColors.lightMov,
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 15,),
                    Text(
                     "${LocaleKeys.firstContentPrivacy.tr(context: context)} ${LocaleKeys.secondContentPrivacy.tr(context: context)} ${LocaleKeys.thirdContentPrivacy.tr(context: context)} ",
                      style: const TextStyle(
                        color: AppColors.lightMov,
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
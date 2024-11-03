import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mined/screens/widgets/header.dart';
import 'package:mined/translations/locale_keys.g.dart';
import '../../constants/color.dart';


class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Widgets.header(context, w, h, LocaleKeys.termsAndConditions.tr(context: context)),
            const SizedBox(height: 25,),
            SizedBox(
              width: w,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Text(
                      LocaleKeys.termsAndConditions.tr(context: context),
                      style: const TextStyle(
                        color: AppColors.darkMov,
                        fontSize: 24,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    const SizedBox(height: 40,),
                    Text(
                      LocaleKeys.lastUpdateTerms.tr(context: context),
                      style: const TextStyle(
                        color: AppColors.darkMov,
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Text(
                     LocaleKeys.termsFirstInformation.tr(context: context),
                      style: const TextStyle(
                        color: AppColors.lightMov,
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 15,),
                    Text(
                     LocaleKeys.summaryOfKeysTerms.tr(context: context),
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
                     "${LocaleKeys.firstContentTerms.tr(context: context)} ${LocaleKeys.secondContentTerms.tr(context: context)} ${LocaleKeys.thirdContentTerms.tr(context: context)} ",
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
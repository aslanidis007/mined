import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/services/club.dart';
import 'package:mined/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import '../../constants/assets.dart';
import '../../constants/color.dart';

class MyClubs extends StatefulWidget {
  const MyClubs({super.key});

  @override
  State<MyClubs> createState() => _MyClubsState();
}

class _MyClubsState extends State<MyClubs> {
  bool shadowSelect = false;
  TextEditingController clubCodeController = TextEditingController();
  bool error = false;
  double marginSlideUp = 1.5;
  final FocusNode _focusNode = FocusNode();
  bool isKeyboardVisible = false;

  loadClub(context) async{
    await Provider.of<ClubProvider>(context, listen: false).clubList(context: context);
    setState(() {
      error = false;
    });
    Navigator.pop(context);
  }

  loadClubAfterDelete(context, String clubId) async{
  final result = await Provider.of<ClubProvider>(context, listen: false).deleteClub(clubId: clubId);
    if(result == true){
      loadClub(context);
    }
  }

  successMessageAfterAddClub(double w, double h, context, String clubId, setState) async{
      clubCodeController.clear();
      await Provider.of<ClubProvider>(context, listen: false).clubList(context: context);
      Navigator.pop(context);
      await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: false,
        barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (context, setState) => successMessage(
              context: context,
              w: w,
              h: h,
              titleColor: AppColors.darkMov,
              image: AppAssets.success,
              btnName: 'Add another',
              title: 'Club has been added \nsuccessfully',
            )
          );
        }
      );
    }

  addClubPopUp(double w, double h) async{
    clubCodeController.clear();
    setState(() {
      error = false;
    });
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (context, setState) => FractionallySizedBox( heightFactor: isKeyboardVisible ? 2.2 : 1.5, child: buildSheetName(w, h, setState))
        );
      }
    );
  }

  checkWhenKeyboardOpen(){
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // Keyboard is open
        setState(() {
          isKeyboardVisible = true;
        });
      } else {
        setState(() {
          isKeyboardVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    checkWhenKeyboardOpen();
    Provider.of<ClubProvider>(context, listen: false).clubList(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Container(
            width: w,
            height: h * 0.18,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(85),
                bottomLeft: Radius.circular(20)
              ),
              color: AppColors.mov,
              image: DecorationImage(
                repeat: ImageRepeat.repeat,
                opacity: .25,
                image: AssetImage(AppAssets.loginBackgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 65.0, left: 30.0, right: 30.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: const Icon(FontAwesomeIcons.angleLeft,color: AppColors.white, size: 30,)),
                      Expanded(
                        child: Text(
                          LocaleKeys.myClubTitle.tr(context: context),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
           Expanded(
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 30.0),
               child: Consumer<ClubProvider>(
                 builder: (context, data, child) {
                   if(data.clubs.isEmpty){
                    return Padding(
                      padding: EdgeInsets.only(top: h * 0.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppAssets.noclubs,
                          ),
                          Text(
                            LocaleKeys.noClubsTitle.tr(context: context),
                            style: const TextStyle(
                              color: AppColors.darkMov,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10,),
                          Text(
                            LocaleKeys.noClubsDescription.tr(context: context),
                            style: const TextStyle(
                              color: AppColors.lightMov,
                              fontSize: 14,
                              fontWeight: FontWeight.w400
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    );
                   }
                   return ListView.builder(
                    itemCount: data.clubs.length,
                    itemBuilder: (context, index) {
                      return membershipLists(
                        '${data.clubs[index]['club']['name']}',
                        '${data.clubs[index]['created_at']}',
                        w,
                        h,
                        '${data.clubs[index]['id']}'
                      );
                     }
                   );
                 }
               )
             ),
           ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: SizedBox(
          width: 45,
          height: 45,
          child: FloatingActionButton(
            backgroundColor: AppColors.lightGreen,
            onPressed: () async{
              await addClubPopUp(w,h);
            },
            tooltip: 'add',
            child: const Icon(Icons.add, size: 35,),
          ),
        ),
      )
    );
  }

  Widget membershipLists(String title, String date, double w, double h, String clubId) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title:  Text(
        title,
        style: const TextStyle(
          color: AppColors.darkMov,
          fontSize: 18,
          fontWeight: FontWeight.w700
        ),
      ),
      subtitle: Text(
        'Added ${DateTime.parse(date).day} ${DateFormat('MMM').format(DateTime.parse(date))} ${DateTime.parse(date).year}',
        style: const TextStyle(
            color: AppColors.darkGrey,
            fontSize: 12,
            fontWeight: FontWeight.w500
          ),
      ),
      trailing: InkWell(
        onTap: () async{
          await showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: false,
            barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
            context: context,
            builder: (context) => deleteMessage(w,h,clubId),
          );
        },
        child: SvgPicture.asset(AppAssets.trash)
      ),
    );
  }

  Widget deleteMessage(double w, double h, String clubId) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          Container(
            width: w,
            height: h * 0.42,
            padding: const EdgeInsets.only(top: 50),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                color: Colors.transparent,
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 40),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                  color: AppColors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                            LocaleKeys.deleteClubTitle.tr(context: context),
                            style: const TextStyle(
                              color: AppColors.darkMov,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Flexible(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: (){
                              loadClubAfterDelete(context, clubId);
                            },
                            child: Container(
                              width: w * 0.8,
                              height: 50.0,
                              margin: const EdgeInsets.only(top: 30),
                              decoration: BoxDecoration(
                                color:AppColors.lightGreen,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.lightGreen.withOpacity(0.6),
                                    spreadRadius: 3,
                                    blurRadius: 20,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              ),
                              child: Center(
                                child: Text(
                                  LocaleKeys.yes.tr(context: context),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            LocaleKeys.no.tr(context: context),
                            style: const TextStyle(
                              color: AppColors.lightMov,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
             Positioned(
              top: 25,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // Shadow color
                      blurRadius: 25, // Spread of the shadow
                      offset: const Offset(0, 4), // Offset of the shadow
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: AppColors.darkMov,
                  ),
                ),
            ),
          ),
        ],
      ),
    );


  Widget buildSheetName(double w, var h, setState) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          Container(
            width: w,
            height: h,
            padding: const EdgeInsets.only(top: 50),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                color: Colors.transparent,
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 70),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                  color: AppColors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        LocaleKeys.enterActivateCodeTitle.tr(context: context),
                        style: const TextStyle(
                          color: AppColors.darkMov,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        LocaleKeys.enterActivateCodeDescription.tr(context: context),
                        style: const TextStyle(
                          color: AppColors.darkMov,
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        width: w * 0.8,
                        margin: EdgeInsets.only(top: h * 0.035, bottom: h * 0.015),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.transparent),
                            boxShadow: shadowSelect == false
                            ? null
                            :[
                              BoxShadow(
                                color: AppColors.darkMov.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 20,
                                offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          focusNode: _focusNode,
                          onChanged: (value){
                            if(value.isEmpty){
                              setState(() {
                                error = false;
                              });
                            }
                          },
                          onTap: (){
                            setState(() {
                              marginSlideUp = 2.2;
                              shadowSelect = !shadowSelect;
                            });
                          },
                          controller: clubCodeController,
                          style: const TextStyle(
                            color: AppColors.darkMov
                          ),
                          cursorColor: AppColors.darkMov,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.white,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.lightMov
                              ),
                              borderRadius: BorderRadius.circular(40)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.darkMov
                              ),
                              borderRadius: BorderRadius.circular(40)
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            hintText: LocaleKeys.clubActivationCodeTitle.tr(context: context),
                            hintStyle: const TextStyle(
                              color: AppColors.lightMov
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: error,
                        child:  Flexible(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(
                                LocaleKeys.invalidCodeDescription.tr(context: context),
                                style: const TextStyle(
                                  color: AppColors.orange,
                                  fontSize: 12
                                ),
                              ),
                            )
                          )
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          final result = await Provider.of<ClubProvider>(context, listen: false).addClub(clubId: clubCodeController.text);
                            if(result == true){
                              setState(() {
                                error = false;
                              });
                              // ignore: use_build_context_synchronously
                              successMessageAfterAddClub(w, h, context, clubCodeController.text, setState);
                            }else{
                              setState(() {
                                error = true;
                              });
                            }
                        },
                        child: Container(
                          width: w * 0.8,
                          height: 50.0,
                          margin: EdgeInsets.only(top: h * 0.165),
                          decoration: BoxDecoration(
                            color:AppColors.lightGreen,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.lightGreen.withOpacity(0.6),
                                spreadRadius: 3,
                                blurRadius: 20,
                                offset: const Offset(0, 3),
                              )
                            ]
                          ),
                          child: Center(
                            child: Text(
                              LocaleKeys.submitCode.tr(context: context),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            LocaleKeys.cancelSettings.tr(context: context),
                            style: const TextStyle(
                              color: AppColors.lightMov,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
             Positioned(
              top: 25,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // Shadow color
                      blurRadius: 25, // Spread of the shadow
                      offset: const Offset(0, 4), // Offset of the shadow
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: AppColors.darkMov,
                  ),
                ),
            ),
          ),
        ],
      ),
    );

Widget successMessage(
  {
    required BuildContext context,
    required double w,
    required double h,
    required Color titleColor,
    required String image,
    required String btnName,
    required String title,
  }) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: Stack(
      children: [
        Container(
          width: w,
          height: h * 0.5,
          padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
              color: Colors.transparent,
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 70),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                color: AppColors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  SvgPicture.asset(image),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Center(
                      child: Text(
                          title,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            addClubPopUp(w,h);
                          },
                          child: Container(
                            width: w * 0.8,
                            height: 65.0,
                            margin: const EdgeInsets.only(top: 30),
                            decoration: BoxDecoration(
                              color:AppColors.lightGreen,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.lightGreen.withOpacity(0.6),
                                  spreadRadius: 3,
                                  blurRadius: 20,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            ),
                            child: Center(
                              child: Text(
                                btnName,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // Shadow color
                    blurRadius: 25, // Spread of the shadow
                    offset: const Offset(0, 4), // Offset of the shadow
                  ),
                ],
              ),
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  color: AppColors.darkMov,
                ),
              ),
          ),
        ),
      ],
    ),
  );
}
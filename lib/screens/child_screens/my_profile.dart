import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/constants/assets.dart';
import 'package:mined/services/reset_change_password.dart';
import 'package:provider/provider.dart';
import '../../constants/color.dart';
import '../../helpers/dropdown.dart';
import '../../services/delete_logout_acc.dart';
import '../../services/dropdown_selection.dart';
import '../../services/user_info.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/header.dart';


class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  // TextEditingController storyController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController? firstNameController;
  TextEditingController? lastnameController;
  TextEditingController? phoneController;
  // TextEditingController dateController = TextEditingController();
  String emailValue = '',passwordValue = '',firstNameValue = '', lastNameValue = '',storyValue = '';
  String phoneValue = '',dateTimeValue = '', genderValue = '';
  String confirmPasswordValue = '', currentPasswordValue = '', newPasswordValue = '';
  bool checkedValue = false, visible = false,showShadow = false,isCurrentPasswordVisible = true,isNewPasswordVisible = true, isConfirmPasswordVisible = true;
  DateTime selectedDate = DateTime.now();
  List selected = [false,false,false];
  List shadowSelect = [false,false,false,];
  String errorMatchPass = '', errorCurrentPass = '';

  @override
  void dispose(){
    // storyController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    currentPasswordController.dispose();
    firstNameController!.dispose();
    lastnameController!.dispose();
    phoneController!.dispose();
    // dateController.dispose();
    super.dispose();
  }

  clearField(context){
    confirmPasswordController.clear();
    newPasswordController.clear();
    currentPasswordController.clear();
    Navigator.pop(context);
  }
  setController(context) async{
    await Provider.of<UserInfo>(context, listen: false).userData(context: context);
    firstNameController = TextEditingController(text: Provider.of<UserInfo>(context, listen: false).userInfo['first_name']);
    lastnameController = TextEditingController(text: Provider.of<UserInfo>(context, listen: false).userInfo['last_name']);
    phoneController = TextEditingController(text: Provider.of<UserInfo>(context, listen: false).userInfo['phone_number']);
  }
  showPasswordMessage(context, double w, double h) async{
    Navigator.pop(context);
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
      context: context,
      builder:(context) => successMessagePassword(h,w)
    );
  }
  showInfoMessage(context, double w, double h) async{
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
      context: context,
      builder:(context) => successMessageInfo(h,w)
    );
  }

  @override
  void initState() {
    setController(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
         FocusScope.of(context).unfocus();
         setState(() {
          shadowSelect = [false,false,false];
         });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Consumer<UserInfo>(
          builder: (context, data, child) {
            genderValue = data.userInfo['gender'] ?? '';
            if(genderValue == 'Male'){
              selected[0] = true;
            }else if(genderValue == 'Female'){
              selected[1] = true;
            }else if (genderValue == 'Other'){
              selected[2] = true;
            }else{
              selected = [false,false,false];
            }
            return SizedBox(
              width: w,
              height: h,
              child: SingleChildScrollView(
                child: Column(
                  children:[
                    Container(
                        decoration: const BoxDecoration(
                          color: AppColors.white
                        ),
                        child: Column(
                          children: [
                            Widgets.header(context,w,h,LocaleKeys.myProfileTitle.tr(context: context)),
                          ],
                        ),
                      ),
                    Container(
                      width: w,
                      height: h * 0.25,
                      decoration: const BoxDecoration(
                        color: AppColors.white
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.only(top: h * 0.04),
                              width: 90,
                              height: 90,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 15, 
                                    color: AppColors.lightMov.withOpacity(0.5), 
                                    spreadRadius: 2,
                                    offset: const Offset(0,15)
                                  )
                                ],
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.darkMov,
                                  shape: BoxShape.circle,
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:[
                                    Text(
                                      'TU',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                          Positioned(
                            bottom: h * 0.085,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white
                              ),
                              child: SvgPicture.asset(
                                AppAssets.photo,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: h * 0.05,
                            left: h * 0.2,
                            right: 0,
                            child: Text(
                              LocaleKeys.uploadImage.tr(context: context),
                              style: const TextStyle(
                                color: AppColors.lightMov,
                                fontSize: 12
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: w,
                      decoration: const BoxDecoration(
                        color: AppColors.white
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: w * 0.8,
                            margin: EdgeInsets.only(bottom: h * 0.025,),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: Colors.transparent),
                              boxShadow: shadowSelect[0] == false 
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
                              onTap: (){
                                for(int i = 0; i < shadowSelect.length; i++){
                                  if(i == 0){
                                    setState(() {
                                      visible = false;
                                      shadowSelect[i] = true;
                                    });
                                  }else{
                                    shadowSelect[i] = false;
                                  }
                                }
                              },                           
                              onChanged: (value){
                                setState(() {
                                  firstNameValue = value;
                                });
                              },
                              controller: firstNameController,
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
                                hintText: LocaleKeys.profileHintName.tr(context: context),
                                hintStyle: const TextStyle(
                                  color: AppColors.lightMov
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: w * 0.8,
                            margin: EdgeInsets.only(bottom: h * 0.025),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: Colors.transparent),
                              boxShadow: shadowSelect[0] == false 
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
                              onTap: (){
                                for(int i = 0; i < shadowSelect.length; i++){
                                  if(i == 0){
                                    setState(() {
                                      visible = false;
                                      shadowSelect[i] = true;
                                    });
                                  }else{
                                    shadowSelect[i] = false;
                                  }
                                }
                              },                           
                              onChanged: (value){
                                setState(() {
                                  lastNameValue = value;
                                });
                              },
                              controller: lastnameController,
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
                                hintText: LocaleKeys.profileHintSurName.tr(context: context),
                                hintStyle: const TextStyle(
                                  color: AppColors.lightMov
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: w * 0.8,
                            margin: EdgeInsets.only(bottom: h * 0.025),
                            decoration: BoxDecoration(                 
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.transparent),
                                boxShadow: shadowSelect[1] == false 
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
                              onTap: (){
                                for(int i = 0; i < shadowSelect.length; i++){
                                  if(i == 1){
                                    setState(() {
                                      visible = false;
                                      shadowSelect[i] = true;
                                    });
                                  }else{
                                    shadowSelect[i] = false;
                                  }
                                }
                              },
                              onChanged: (value){
                                if(value.isEmpty){
                                  setState(() {
                                    phoneValue = '';
                                  });
                                }else{
                                  setState(() {
                                    phoneValue = value;
                                  });
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly // Restrict input to digits only
                              ],
                              controller: phoneController,
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
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: AppColors.darkMov
                                  ),
                                  borderRadius: BorderRadius.circular(40)
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                hintText: LocaleKeys.profileHintNumber.tr(context: context),
                                hintStyle: const TextStyle(
                                  color: AppColors.lightMov
                                ),
                              ),
                            ),
                          ),
                          dropdownButton(
                            context: context,
                            h: h,
                            w: w,
                            data: [
                              {
                                'name':LocaleKeys.selectionMale.tr(context: context)
                              },
                              {
                                'name':LocaleKeys.selectionFemale.tr(context: context)
                              },
                              {
                                'name':LocaleKeys.selectionOther.tr(context: context)
                              },
                            ],
                            selected: selected,
                            typeDropdown: 'gender',
                            genderValue: genderValue
                          ),
                          InkWell(
                            onTap: () async{
                              setState(() {
                                errorCurrentPass = '';
                                errorMatchPass = '';
                              });
                              await showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: false,
                                barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
                                context: context,
                                builder: (context) => StatefulBuilder(
                                  builder: (BuildContext context, setState) => changePassword(w,h,setState)
                                ),
                              );
                            },
                            child: Text(
                                LocaleKeys.profileChangePasswordTitle.tr(context: context),
                                style: const TextStyle(
                                  color: AppColors.darkMov,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.0,
                                ),
                              ),
                          ),
                            const SizedBox(height: 30,),
                            InkWell(
                              onTap: () async{
                                  await showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: false,
                                    barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
                                    context: context,
                                    builder: (context) => deleteMessage(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height,context,),
                                  );                               
                                },
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                LocaleKeys.profileDeleteAccountTitle.tr(context: context),
                                  style: const TextStyle(
                                    color: AppColors.lightMov,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async{
                                if(phoneValue.isNotEmpty 
                                    || firstNameValue.isNotEmpty 
                                    || lastNameValue.isNotEmpty 
                                    || Provider.of<DropDownSelection>(context, listen: false).selectedItemValue.isNotEmpty
                                    ) {
                                    final result = await Provider.of<UserInfo>(context, listen: false).userUpdateData(
                                      lastName: lastNameValue.isEmpty ? lastnameController!.text : lastNameValue,
                                      firstName: firstNameValue.isEmpty ? firstNameController!.text : firstNameValue,
                                      gender: Provider.of<DropDownSelection>(context, listen: false).selectedItemValue, 
                                      mobileNumber: phoneController!.text,
                                      context: context
                                  );
                                  if(result['success'] == true){
                                    // ignore: use_build_context_synchronously
                                    await showInfoMessage(context,w,h);
                                  }
                                }
                              },
                              child: Container(
                                width: w * 0.8,
                                height: 50.0,
                                margin: const EdgeInsets.only(top: 40, bottom: 30),
                                decoration: BoxDecoration(
                                  color: phoneValue.isEmpty 
                                        && firstNameValue.isEmpty 
                                        && lastNameValue.isEmpty
                                        && Provider.of<DropDownSelection>(context, listen: false).selectedItemValue.isEmpty
                                  ? AppColors.lightGreen.withOpacity(0.5) 
                                  : AppColors.lightGreen,
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
                                    LocaleKeys.saveChangesTitle.tr(context: context),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
  Widget deleteMessage(double w, double h, BuildContext context,) => Padding(
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
                          context.tr(LocaleKeys.messageDeleteAccount),
                          style: const TextStyle(
                            color: AppColors.darkMov,
                            fontSize: 20,
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
                          onTap: () async{
                            await Provider.of<DeleteLogoutAccount>(context, listen: false).deleteAccountService(context);
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
                            child: const Center(
                              child: Text(
                                'Yes',
                                textAlign: TextAlign.left,
                                style: TextStyle(
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
                      child: const Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          'No',
                          style: TextStyle(
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
  
  Widget changePassword(double w, double h, setState)=> Padding(
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
                    Center(
                      child: Text(
                        LocaleKeys.profileChangePasswordTitle.tr(context: context),
                          style: const TextStyle(
                            color: AppColors.darkMov,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Flexible(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                            Container(
                              width: w * 0.8,
                              margin: EdgeInsets.only(bottom: h * 0.02),
                              child: TextFormField(
                                onChanged: (value){
                                  if(value.length > 7){
                                    setState(() {
                                      currentPasswordValue = value;
                                    });
                                  }else{
                                    setState(() {
                                      currentPasswordValue = '';
                                    });
                                  }
                                },
                                controller: currentPasswordController,
                                style: const TextStyle(
                                  color: AppColors.darkMov
                                ),
                                obscuringCharacter: '✱',
                                obscureText: isCurrentPasswordVisible,
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
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                  hintText: LocaleKeys.profileCurrentPasswordTitle.tr(context: context),
                                  errorText: errorCurrentPass != '' ? errorCurrentPass : null,
                                  hintStyle: const TextStyle(
                                    color: AppColors.lightMov
                                  ),
                                  suffixIcon: IconButton(
                                    icon: isCurrentPasswordVisible
                                    ?  const Icon(FontAwesomeIcons.eye, color: AppColors.lightMov,size: 22,)
                                    : const Icon(FontAwesomeIcons.eyeSlash, color: AppColors.darkMov,size: 22,),
                                    onPressed: ()=> setState(() {
                                      isCurrentPasswordVisible = !isCurrentPasswordVisible;
                                    }),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: w * 0.8,
                              margin: EdgeInsets.only(bottom: h * 0.02),
                              child: TextFormField(
                                onChanged: (value){
                                  if(value.length > 7){
                                    setState(() {
                                      newPasswordValue = value;
                                    });
                                  }else{
                                    setState(() {
                                      newPasswordValue = '';
                                    });
                                  }
                                },
                                controller: newPasswordController,
                                style: const TextStyle(
                                  color: AppColors.darkMov
                                ),
                                obscuringCharacter: '✱',
                                obscureText: isNewPasswordVisible,
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
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                  hintText: LocaleKeys.profileNewPasswordTitle.tr(context: context),
                                  hintStyle: const TextStyle(
                                    color: AppColors.lightMov
                                  ),
                                  suffixIcon: IconButton(
                                    icon: isNewPasswordVisible
                                    ?  const Icon(FontAwesomeIcons.eye, color: AppColors.lightMov,size: 22,)
                                    : const Icon(FontAwesomeIcons.eyeSlash, color: AppColors.darkMov,size: 22,),
                                    onPressed: ()=> setState(() {
                                      isNewPasswordVisible = !isNewPasswordVisible;
                                    }),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: w * 0.8,
                              margin: EdgeInsets.only(bottom: h * 0.02),
                              child: TextFormField(
                                onChanged: (value){
                                  if(value.length > 7){
                                    setState(() {
                                      confirmPasswordValue = value;
                                    });
                                  }else{
                                    setState(() {
                                      confirmPasswordValue = '';
                                    });
                                  }
                                },
                                controller: confirmPasswordController,
                                style: const TextStyle(
                                  color: AppColors.darkMov
                                ),
                                obscuringCharacter: '✱',
                                obscureText: isConfirmPasswordVisible,
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
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                  hintText: LocaleKeys.profileConfirmPasswordTitle.tr(context: context),
                                  errorText: errorMatchPass != '' ? errorMatchPass : null,
                                  hintStyle: const TextStyle(
                                    color: AppColors.lightMov
                                  ),
                                  suffixIcon: IconButton(
                                    icon: isConfirmPasswordVisible
                                    ?  const Icon(FontAwesomeIcons.eye, color: AppColors.lightMov,size: 22,)
                                    : const Icon(FontAwesomeIcons.eyeSlash, color: AppColors.darkMov,size: 22,),
                                    onPressed: ()=> setState(() {
                                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                                    }),
                                  ),
                                ),
                              ),
                            ),
                              InkWell(
                                onTap: () async{
                                  if(confirmPasswordValue.isNotEmpty || newPasswordValue.isNotEmpty || currentPasswordValue.isNotEmpty){
                                    if(confirmPasswordValue == newPasswordValue){
                                      final result = await Provider.of<ResetChangePassword>(context, listen: false).changeUserPassword(
                                        oldPassowrd: currentPasswordValue, 
                                        newPassword: newPasswordValue,
                                        context: context
                                      );
                                      if(result['success'] == false){
                                        setState((){
                                          errorMatchPass = '';
                                          errorCurrentPass = 'The current password is wrong!';
                                        });
                                      }else{
                                        // ignore: use_build_context_synchronously
                                        showPasswordMessage(context,w,h);
                                      }
                                    }else{
                                      setState((){
                                        errorCurrentPass = '';
                                        errorMatchPass = 'Passwords do not match!';
                                      });
                                    }
                                  }

                                },
                                child: Container(
                                  width: w * 0.8,
                                  height: 50.0,
                                  margin: const EdgeInsets.only(top: 20,),
                                  decoration: BoxDecoration(
                                    color: confirmPasswordValue.isEmpty || newPasswordValue.isEmpty || currentPasswordValue.isEmpty
                                    ? AppColors.lightGreen.withOpacity(0.5)
                                    : AppColors.lightGreen,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                    color: confirmPasswordValue.isEmpty || newPasswordValue.isEmpty || currentPasswordValue.isEmpty
                                        ? AppColors.lightGreen.withOpacity(0.1)
                                        : AppColors.lightGreen,
                                        spreadRadius: 3,
                                        blurRadius: 20,
                                        offset: const Offset(0, 3),
                                      )
                                    ]
                                  ),
                                  child: Center(
                                    child: Text(
                                      LocaleKeys.saveChangesTitle.tr(context: context),
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
                              const SizedBox(height: 10,),
                              Center(
                                child: InkWell(
                                  onTap: (){
                                    clearField(context);
                                  },
                                  child: Text(
                                      LocaleKeys.cancelSettings.tr(context: context),
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        color: AppColors.lightMov,
                                      ),
                                    ),
                                ),
                              )
                            ],
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
                  onTap: () {
                    clearField(context);
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

    Widget successMessageInfo(double w, double h)=> Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          Container(
            width: w,
            height: h,
            padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                color: Colors.transparent,
              ),
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                  color: AppColors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SvgPicture.asset(AppAssets.star, height: 150,),
                      const SizedBox(height: 50,),
                      Text(
                        LocaleKeys.profileInformationTitle.tr(context: context),
                        style: const TextStyle(
                          color: AppColors.darkMov,
                          fontSize: 24,
                          fontWeight: FontWeight.w700
                        ),
                      )
                    ],
                  )
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
                  onTap: () {
                    // clearField(context);
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

  Widget successMessagePassword(double w, double h)=> Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          Container(
            width: w,
            height: h,
            padding: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                color: Colors.transparent,
              ),
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                  color: AppColors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SvgPicture.asset(AppAssets.password),
                      const SizedBox(height: 50,),
                      Text(
                        LocaleKeys.profilePasswordChangedTitle.tr(context: context),
                        style: const TextStyle(
                          color: AppColors.darkMov,
                          fontSize: 24,
                          fontWeight: FontWeight.w700
                        ),
                      )
                    ],
                  )
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
                  onTap: () {
                    clearField(context);
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
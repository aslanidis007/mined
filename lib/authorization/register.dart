import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/authorization/login.dart';
import 'package:mined/constants/assets.dart';
import 'package:mined/translations/locale_keys.g.dart';
import '../constants/color.dart';
import '../functions/social_login.dart';
import '../routes/routes.dart';
import '../services/auth_system.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String emailValue = '',passwordValue = '',firstNameValue = '',lastNameValue = '',phoneValue = '',dateTimeValue = '', genderValue = '';
  bool checkedValue = false, visible = false,showShadow = false,isPasswordVisible = true;
  DateTime selectedDate = DateTime.now();
  List selected = [false,false,false];
  List shadowSelect = [false,false,false,false,false,false];
  static AuthSystem auth = AuthSystem();
  final FocusNode _focusNode = FocusNode();
  String emailError = '';
  RegExp emailChecker = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
  RegExp specialCharacters = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
  RegExp letters = RegExp(r"[a-zA-Z]");
  RegExp numbers = RegExp(r'^[1-9]$');
  double line = 0.0;

  @override
  void dispose(){
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    dateController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
         FocusScope.of(context).unfocus();
         setState(() {
          shadowSelect = [false,false,false,false,false,false];
         });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: w,
          height: h,
          decoration: const BoxDecoration(
            color: AppColors.mov,
            image: DecorationImage(
              repeat: ImageRepeat.repeat,
              opacity: .25,
              image: AssetImage(AppAssets.loginBackgroundImage),
              fit: BoxFit.contain,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: h * 0.075,
                left: 0,
                right: 0,
                child: SvgPicture.asset(AppAssets.logo)
              ),
              Container(
                margin: EdgeInsets.only(top: h*0.15),
                 decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children:  [
                         const Text(
                          'Create an account',
                          style: TextStyle(
                            color: AppColors.darkMov,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox( 
                          height: 5.0 
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Already have an account? ',
                            style: const TextStyle(
                              color: AppColors.darkMov,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400
                            ),
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()..onTap = (){
                                  PageNavigator(ctx: context).nextPageOnly(page: const LoginPage());
                                },                               
                                text: 'Log in',
                                style: const TextStyle(
                                  color: AppColors.lightGreen,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: w * 0.8,
                          margin: EdgeInsets.only(top: h * 0.035, bottom: h * 0.025),
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
                                emailValue = value;
                              });
                            },
                            keyboardType: TextInputType.emailAddress,
                            focusNode: _focusNode,
                            controller: emailController,
                            style: const TextStyle(
                              color: AppColors.darkMov
                            ),
                            cursorColor: AppColors.darkMov,
                            decoration: InputDecoration(
                              errorText: emailError != '' ? emailError : null,
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
                              hintText: 'Email address *',
                              hintStyle: const TextStyle(
                                color: AppColors.lightMov
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: w * 0.8,
                          margin: EdgeInsets.only(top: h * 0.0, bottom: h * 0.025),
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
                              hintText: 'First Name *',
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
                            boxShadow: shadowSelect[2] == false 
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
                                if(i == 2){
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
                            controller: lastNameController,
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
                              hintText: 'Last name *',
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
                              boxShadow: shadowSelect[3] == false 
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
                                if(i == 3){
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
                                phoneValue = value;
                              });
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
                              hintText: 'Phone',
                              hintStyle: const TextStyle(
                                color: AppColors.lightMov
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              visible = !visible;
                              shadowSelect = [false,false,false,false,false,false];
                            });
                          },
                          child: Container(
                            width: w * 0.8,
                            height: 50,
                            margin: EdgeInsets.only(bottom: visible == true ? h * 0.010 : h * 0.025),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: AppColors.lightMov),
                              boxShadow: visible == false 
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        genderValue != '' ? genderValue : 'Gender',
                                        style: TextStyle(
                                          color: genderValue != '' ?AppColors.darkMov :AppColors.lightMov,
                                          fontSize: 16
                                        ),
                                      ),
                                      Icon(
                                        visible == true ? FontAwesomeIcons.chevronUp :FontAwesomeIcons.chevronDown,
                                        size: 15,
                                        color: AppColors.lightMov,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: visible,
                          child: Container(
                            width: w * 0.8,
                            height: 120,
                            margin: EdgeInsets.only(bottom: h * 0.025),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.lightMov),
                              boxShadow: visible == false 
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                genderSelectLabel(context.tr(LocaleKeys.selectionMale), selected, 0),
                                genderSelectLabel(context.tr(LocaleKeys.selectionFemale), selected, 1),
                                genderSelectLabel(context.tr(LocaleKeys.selectionOther), selected, 2)
                              ],
                            ),
                          ),
                        ),
                             
                        Container(
                          width: w * 0.8,
                          margin: EdgeInsets.only(bottom: h * 0.025),                         
                          child: TextFormField(
                            onTap: () async{
                              final DateTime? dateTime = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(1950),
                                lastDate: DateTime(3000)
                              );
                              if(dateTime != null){
                                setState(() {
                                  selectedDate = dateTime;
                                  dateTimeValue = 'time';
                                });
                              }
                            },
                            readOnly: true,
                            onChanged: (value){
                              setState(() {
                                dateTimeValue = value;
                              });
                            },
                            controller: dateController,
                            style: const TextStyle(
                              color: AppColors.darkMov
                            ),
                            cursorColor: AppColors.darkMov,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.white,
                              suffixIcon: const Icon(
                                Icons.calendar_month, 
                                color: AppColors.darkMov,
                              ),
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
                              hintText: dateTimeValue != '' 
                              ?'${selectedDate.day}/${selectedDate.month}/${selectedDate.year}' 
                              :'Date of birth',
                              hintStyle: TextStyle(
                                color: dateTimeValue != '' 
                                ?AppColors.darkMov 
                                :AppColors.lightMov
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: w * 0.8,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.transparent),
                            boxShadow: shadowSelect[4] == false 
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
                                if(i == 4){
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
                              if(value.isNotEmpty){
                                if (value.length < 6) {
                                  line = 1/5;
                                } else if (value.length < 8) {
                                  line = 2/5;
                                } else if(value.length < 9){
                                  line = 3/5;
                                }else {
                                  final containsRecommendedChars = value.contains(RegExp(r'[A-Z]'))
                                      && value.contains(RegExp(r'[a-z]'))
                                      && value.contains(RegExp(r'[0-9]'))
                                      && value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
                            
                                  if (!containsRecommendedChars) {
                                    line = 4/5;
                                  } else {
                                    line = 5/5;
                                  }
                                }
                                setState(() {
                                  line;
                                  passwordValue = value;
                                });
                              }else{
                                setState(() {
                                  line = 0.0;
                                  passwordValue = '';
                                });
                              }
                            },
                            controller: passwordController,
                            style: const TextStyle(
                              color: AppColors.darkMov
                            ),
                            obscuringCharacter: '✱',
                            obscureText: isPasswordVisible,
                            cursorColor: AppColors.darkMov,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: isPasswordVisible
                                ?  const Icon(FontAwesomeIcons.eye, color: AppColors.lightMov,size: 22,)
                                : const Icon(FontAwesomeIcons.eyeSlash, color: AppColors.darkMov,size: 22,),
                                onPressed: ()=> setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                }),
                              ),
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
                              hintText: 'Password *',
                              hintStyle: const TextStyle(
                                color: AppColors.lightMov
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: w * 0.8,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 60,
                                    height: 2,
                                    child: LinearProgressIndicator(
                                      value: line >= 1/5 ? 1 : 0,
                                      backgroundColor: Colors.grey[300],
                                      color: line >= 1/5
                                      ? Colors.red
                                      : AppColors.lightMov
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    height: 2,
                                    child: LinearProgressIndicator(
                                      value: line >= 2/5 ? 1 : 0,
                                      backgroundColor: Colors.grey[300],
                                      color: line >= 2 / 5
                                      ? Colors.red
                                      : AppColors.lightMov
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    height: 2,
                                    child: LinearProgressIndicator(
                                      value: line >= 3/5 ? 1 : 0,
                                      backgroundColor: Colors.grey[300],
                                      color: line >= 3 / 5
                                      ? Colors.yellow
                                      : AppColors.lightMov
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    height: 2,
                                    child: LinearProgressIndicator(
                                      value: line >= 4/5 ? 1 : 0,
                                      backgroundColor: Colors.grey[300],
                                      color: line >= 4 / 5
                                      ? AppColors.green
                                      : AppColors.grey

                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    height: 2,
                                    child: LinearProgressIndicator(
                                      value: line >= 5/5 ? 1 : 0,
                                      backgroundColor: Colors.grey[300],
                                      color: line >= 5 / 5
                                      ? AppColors.green
                                      : AppColors.grey

                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5,),
                              const Text(
                                'Week',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.lightMov
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: w * 0.8,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            checkColor: AppColors.lightMov,
                            activeColor: Colors.transparent,
                            checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              side: const BorderSide(color: Colors.white),
                            ),
                            side: MaterialStateBorderSide.resolveWith(
                              (states) => BorderSide(
                                width: 1.4, 
                                color: !checkedValue 
                                ? AppColors.lightMov 
                                : AppColors.darkMov
                              ),
                            ),
                            title:Transform.translate(
                              offset: const Offset(-15,0),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: const TextSpan(
                                    text: 'By registering, you accept our ',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.lightMov,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.darkMov,
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColors.darkMov,
                                          decorationThickness: 1.8,
                                      )
                                    ),
                                  ]
                                ),
                              ),
                            ),
                            value: checkedValue,
                            onChanged: (newValue) {
                              setState(() {
                                checkedValue = newValue!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                          if(emailChecker.hasMatch(emailValue)){
                            setState(() {
                              emailError = '';
                            });
                            final token = await auth.registerService(
                              context: context, 
                              email: emailController.text, 
                              password: passwordController.text, 
                              phoneNumber: phoneController.text, 
                              gender: genderValue, 
                              dob: dateController.text, 
                              firstName: firstNameController.text,
                              lastName: lastNameController.text
                            );
                            if(token != null || token != ''){
                              emailController.clear();
                              passwordController.clear();
                              phoneController.clear();
                              dateController.clear();
                              firstNameController.clear();
                              lastNameController.clear();
                              setState(() {
                                checkedValue = false;
                                line = 0.0;
                                genderValue = '';
                                dateTimeValue = '';
                              });
                            }
                          }else{
                            setState(() {
                              emailError = 'Invalid email address.';
                            });
                          }
                          },
                          child: Container(
                            width: w * 0.8,
                            height: 60.0,
                            margin: const EdgeInsets.only(top: 40.0),
                            decoration: BoxDecoration(
                              color: emailValue == '' || passwordValue == '' || line < 0.5 || lastNameValue == '' || firstNameValue == '' || checkedValue == false
                              ?AppColors.opacityGreen 
                              :AppColors.lightGreen,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              boxShadow: emailValue == '' || passwordValue == ''|| line < 0.5 || lastNameValue == '' || firstNameValue == '' || checkedValue == false
                              ? null 
                              :[
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
                                'Sign up',
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: w * 0.27,
                              child: Divider(
                                endIndent: 10,
                                thickness: .5,
                                height: h * 0.07,
                                color: AppColors.lightMov,
                              ),
                            ),
                            const Text(
                              'or sign up with',
                              style:
                                  TextStyle(color: AppColors.darkMov, fontSize: 15),
                            ),
                            SizedBox(
                              width: w * 0.27,
                              child: Divider(
                                indent: 10,
                                thickness: .5,
                                height: h * 0.07,
                                color: AppColors.lightMov,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: ()async{
                                  await SocialLogin.googleSignIn(context);
                                },
                                child: Container(
                                  width: 85,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: AppColors.white,
                                    border: Border.all(color: AppColors.darkMov)
                                  ),
                                  child: const Icon(FontAwesomeIcons.google, color: AppColors.mov,),
                                ),
                              ),
                              const SizedBox(width: 20,),
                              if(Platform.isIOS)...[
                                InkWell(
                                  onTap: () async{
                                    await SocialLogin.appleSignIn(context);
                                  },
                                  child: Container(
                                    width: 85,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: AppColors.white,
                                      border: Border.all(color: AppColors.darkMov)
                                    ),
                                    child: const Icon(FontAwesomeIcons.apple, color: AppColors.mov,),
                                  ),
                                )
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget genderSelectLabel(String name, List selected, int index ){
    return GestureDetector(
      onTap: (){     
        for (int i = 0; i < selected.length; i++){
          if(i == index){
            setState(() {
              selected[i] = !selected[i];
              if(selected[i] == false){
                genderValue = '';
              }else{
                genderValue = name;
              }
            });
          }else{
            selected[i] = false;
          }
        }
        setState(() {
          visible = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                color: selected[index]== false 
                ? AppColors.lightMov
                : AppColors.darkMov,
                fontSize: 16
              ),
            ),
            Icon(
              selected[index]== false  
              ? null
              : FontAwesomeIcons.check,
              size: 15,
              color: AppColors.lightMov,
            ),
          ],
        ),
      ),
    );
  }
}
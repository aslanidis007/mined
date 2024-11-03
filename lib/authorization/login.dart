import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/constants/alert.dart';
import 'package:mined/constants/assets.dart';
import '../constants/color.dart';
import '../services/auth_system.dart';
import '../services/reset_change_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController resetEmailController = TextEditingController();
  String emailValue = '',passwordValue = '',resetemailValue = '';
  bool isPasswordVisible = true, shadowSelect = false;
  List<bool> labelShadow = [false,false];
  RegExp emailChecker = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
  static AuthSystem auth = AuthSystem();
  static ResetChangePassword reset = ResetChangePassword();
  String errorLogin = '';
  final FocusNode _focusNode = FocusNode();



  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    resetEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },   
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                width: w,
                margin: EdgeInsets.only(top: h*0.15),
                 decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children:  [
                       const Text(
                        'Log in to your account',
                        style: TextStyle(
                          color: AppColors.darkMov,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox( 
                        height: 5.0 
                      ),
                      // Text.rich(
                      //   TextSpan(
                      //     text: 'Don\'t have an account? ',
                      //     style: const TextStyle(
                      //       color: AppColors.darkMov,
                      //       fontSize: 14.0,
                      //       fontWeight: FontWeight.w400
                      //     ),
                      //     children: [
                      //       TextSpan(
                      //         recognizer: TapGestureRecognizer()..onTap = (){
                      //           PageNavigator(ctx: context).nextPageOnly(page: const RegisterPage());
                      //         },
                      //         text: 'Sign up',
                      //         style: const TextStyle(
                      //           color: AppColors.lightGreen,
                      //           fontSize: 14.0,
                      //           fontWeight: FontWeight.w600
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Container(
                        width: w * 0.8,
                        margin: EdgeInsets.only(top: h * 0.035, bottom: h * 0.025),
                        decoration: BoxDecoration(
                          boxShadow: labelShadow[0] == false
                          ? null
                          : [
                            const BoxShadow()
                          ]
                        ),
                        child: TextFormField(
                          focusNode: _focusNode,
                          onChanged: (value){
                            if(emailChecker.hasMatch(value)){
                              setState(() {
                                emailValue = value;
                                errorLogin = '';
                              });
                            }else{
                              setState(() {
                                emailValue = '';
                                errorLogin = '';
                              });
                            }
                          },
                          controller: emailController,
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
                            hintText: 'Email address',
                            hintStyle: const TextStyle(
                              color: AppColors.lightMov
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
                                passwordValue = value;
                                errorLogin = '';
                              });
                            }else{
                              setState(() {
                                passwordValue = '';
                                errorLogin = '';
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
                            errorText: errorLogin != '' ? errorLogin : null,
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
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              color: AppColors.lightMov
                            ),
                            suffixIcon: IconButton(
                              icon: isPasswordVisible
                              ?  const Icon(FontAwesomeIcons.eye, color: AppColors.lightMov,size: 22,)
                              : const Icon(FontAwesomeIcons.eyeSlash, color: AppColors.darkMov,size: 22,),
                              onPressed: ()=> setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              }),
                            ),
                          ),
                        ),
                      ),
                     Text.rich(
                        TextSpan(
                          text: 'Forgot password? ',
                          style: const TextStyle(
                            color: AppColors.darkMov,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400
                          ),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()..onTap = (){
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: false,
                                  barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
                                  context: context,
                                  builder: (context) => buildSheetName(w,h),
                                );                                
                              },                               
                              text: 'Reset',
                              style: const TextStyle(
                                color: AppColors.darkMov,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          if(emailValue.isNotEmpty && passwordValue.isNotEmpty){
                            final token = await auth.signInUser(
                                signInType: 'email',
                                context: context,
                                email: emailController.text,
                                password: passwordController.text
                            );
                            if(token == ''){
                              setState(() {
                                errorLogin = 'The email or password is wrong!';
                              });
                            }
                          }
                        },
                        child: Container(
                          width: w * 0.8,
                          height: 60.0,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(top: 40.0),
                          decoration: BoxDecoration(
                            color: emailValue == '' || passwordValue == '' 
                            ?AppColors.opacityGreen 
                            :AppColors.lightGreen,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            boxShadow: emailValue == '' || passwordValue == '' 
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
                              'Log in',
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
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     SizedBox(
                      //       width: w * 0.27,
                      //       child: Divider(
                      //         endIndent: 10,
                      //         thickness: .5,
                      //         height: h * 0.1,
                      //         color: AppColors.lightMov,
                      //       ),
                      //     ),
                      //     const Text(
                      //       'or log in with',
                      //       style:
                      //           TextStyle(color: AppColors.darkMov, fontSize: 15),
                      //     ),
                      //     SizedBox(
                      //       width: w * 0.27,
                      //       child: Divider(
                      //         indent: 10,
                      //         thickness: .5,
                      //         height: h * 0.1,
                      //         color: AppColors.lightMov,
                      //       ),
                      //     )
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () async {
                      //         await SocialLogin.googleSignIn(context);
                      //       },
                      //       child: Container(
                      //         width: 85,
                      //         height: 50,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(25),
                      //           color: AppColors.white,
                      //           border: Border.all(color: AppColors.darkMov)
                      //         ),
                      //         child: const Icon(FontAwesomeIcons.google, color: AppColors.darkMov,),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 20,),
                      //     if(Platform.isIOS)...[
                      //       GestureDetector(
                      //         onTap: () async{
                      //           await SocialLogin.appleSignIn(context);
                      //         },
                      //         child: Container(
                      //           width: 85,
                      //           height: 50,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(25),
                      //             color: AppColors.white,
                      //             border: Border.all(color: AppColors.darkMov)
                      //           ),
                      //           child: const Icon(FontAwesomeIcons.apple, color: AppColors.darkMov,),
                      //         ),
                      //       )
                      //     ]
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

    Widget buildSheetName(double w, var h) => Padding(
      padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          Container(
            width: w,
            height: h * 0.45,
            padding: const EdgeInsets.only(top: 50),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                color: Colors.transparent,
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 50),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                  color: AppColors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Forgot password',
                        style: TextStyle(
                          color: AppColors.darkMov,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      const Text(
                        'You should receive an email with instructions \non how to reset your password.',
                        style: TextStyle(
                          color: AppColors.darkMov,
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        width: w * 0.8,
                        margin: EdgeInsets.only(top: h * 0.035, bottom: h * 0.025),
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
                          onTap: (){
                            setState(() {
                              shadowSelect = !shadowSelect;
                            });
                          },
                          onChanged: (value){
                            setState(() {
                              resetemailValue = value;
                            });
                          },
                          controller: resetEmailController,
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
                            hintText: 'Email address *',
                            hintStyle: const TextStyle(
                              color: AppColors.lightMov
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async{
                          String status = await reset.resetService(email: resetemailValue, context: context);
                            if(status == '200'){
                             Navigator.pop(context);
                              await showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: false,
                                barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
                                context: context,
                                builder: (context) => successSendEmail(w,h),
                              ); 
                            }else{
                              showMessage(context: context, message: 'Something went wrong!');
                            }
                        },
                        child: Container(
                          width: w * 0.8,
                          height: 50.0,
                          margin: const EdgeInsets.only(top: 10.0),
                          decoration: BoxDecoration(
                            color: resetemailValue == '' 
                            ?AppColors.opacityGreen 
                            :AppColors.lightGreen,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            boxShadow: resetemailValue == ''
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
                              'Reset',
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
    Widget successSendEmail(double w, var h) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          Container(
            width: w,
            height: h * 0.45,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Image.asset(AppAssets.sendEmailImage),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                            'Great!',
                            style: TextStyle(
                              color: AppColors.darkMov,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'An email has been sent to\n',
                            style: const TextStyle(
                              color: AppColors.lightMov,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400
                            ),
                            children: [
                              TextSpan(                             
                                text: resetEmailController.text,
                                style: const TextStyle(
                                  color: AppColors.darkMov,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                              const TextSpan(                             
                                text: '\nPlease check your email instructions.',
                                style: TextStyle(
                                  color: AppColors.lightMov,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10,),
                  
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
}
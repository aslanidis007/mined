import 'package:flutter/cupertino.dart';
import 'package:mined/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/alert.dart';
import '../constants/api/login_register_api.dart';
import '../constants/api/user.dart';
import '../constants/save_local_storage.dart';
import '../routes/auth_route.dart';

class AuthSystem extends ChangeNotifier{
  String? _authToken;
  String? get authToken => _authToken;

  String? _userId;
  String? get userId => _userId;

  String? _role;
  String? get role => _role;


 clearToken() async{
  SharedPreferences value = await SaveLocalStorage.pref;
  await value.remove('token');
 }
 
 Future<String> signInUser({
    required final context,
    required String? email,
    required String signInType,
    String? socialId,
    String? accessToken,
    String? firstName,
    String? lastName,
    String? password,
  }) async{
    await clearToken();
    String tokenExists = await getToken();
    if(tokenExists == ''){
      if(signInType == 'social'){
        await socialAuthService(
          context: context,
          email: email,
          accessToken: accessToken,
          socialId: socialId,
          firstName: firstName,
          lastName: lastName,
        );
      }else{
       await emailAuthService(
          context: context,
          email: email!,
          password: password!
        );
      }
    }else{
      await AuthRoute(ctx: context).navigateController();
    }
    return _authToken ?? '';
  }


  registerService({
    required context,
    required String email,
    required String password,
    required String phoneNumber,
    required String gender,
    required String dob,
    required String firstName,
    required String lastName,
  }) async{
    await clearToken();
    final loginData = await LoginRegisterApi.emailRegister(
        email: email,
        password: password,
        context: context,
        phoneNumber: phoneNumber,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        dob: dob
    );

    loginData['success'] == false ? _authToken = '' : _authToken = loginData['data']['token'];

    if(loginData['error'] != null){
      showMessage(context: context, message: 'The email exists! Try another email');
    }else if(_authToken == null || _authToken == ''){
      showMessage(context: context, message: 'Something went wrong! Token is empty');
    } else{
      saveToken(_authToken ?? '');

      final userInfo = await UserApi.userData(token: _authToken ?? '',context: context);
      saveUserId(userInfo['id']);

      final page = await AuthRoute(ctx: context).navigateController();
      PageNavigator(ctx: context).nextPageOnly(page: page);

    }
    return _authToken;
  }

  socialAuthService({
    final context,
    String? email,
    String? accessToken,
    String? socialId,
    String? firstName,
    String? lastName,
  }) async{
    await clearToken();
    final loginData = await LoginRegisterApi.socialLogin(
      email: email,
      accessToken: accessToken,
      context: context,
      socialId: socialId,
      firstName: firstName,
      lastName: lastName,
    );
    loginData['success'] == false ? _authToken = '' : _authToken = loginData['data']['token'];

    if(_authToken == null || _authToken == ''){
      showMessage(context: context, message: 'Something went wrong or Token is empty');
    }else{
      await saveToken(_authToken!);

      final userInfo = await UserApi.userData(token: _authToken!, context: context);
      await saveUserId(userInfo['id']);

      final page = await AuthRoute(ctx: context).navigateController();
      PageNavigator(ctx: context).nextPageOnly(page: page);
    }
  }

  emailAuthService({
    final context,
    required String email,
    required String password,
  }) async{
    final loginData = await LoginRegisterApi.emailLoginAuth(email: email, password: password, context: context);
    loginData['success'] == false ? _authToken = '' : _authToken = loginData['data']['token'];
    if(_authToken == null || _authToken == ''){
      showMessage(context: context, message: 'Something went wrong or Token is empty');
    }else{
      await saveToken(_authToken!);

      final userInfo = await UserApi.userData(token: _authToken!, context: context);
      await saveUserId(userInfo['id']);
      await saveRole(loginData['data']['roles'][0]);

     final page = await AuthRoute(ctx: context).navigateController();
      PageNavigator(ctx: context).nextPageOnly(page: page);
    }
    return _authToken;
  }


  saveToken(String token) async {
    SharedPreferences value = await SaveLocalStorage.pref;
    value.setString('token', token);
  }

  Future<String> getToken() async {
    SharedPreferences value = await SaveLocalStorage.pref;
    if (value.containsKey('token')) {
      String data = value.getString('token')!;
      _authToken = data;
      notifyListeners();
      return data;
    } else {
      _authToken = '';
      notifyListeners();
      return '';
    }
  }

  saveUserId(String userId) async {
    SharedPreferences value = await SaveLocalStorage.pref;
    value.setString('userId', userId);
  }

  Future<String> getId() async {
    SharedPreferences value = await SaveLocalStorage.pref;
    if (value.containsKey('userId')) {
      String data = value.getString('userId')!;
      _userId = data;
      notifyListeners();
      return data;
    } else {
      _userId = '';
      notifyListeners();
      return '';
    }
  }
  saveRole(String role) async {
    SharedPreferences value = await SaveLocalStorage.pref;
    value.setString('role', role);
  }

  Future<String> getRole() async {
    SharedPreferences value = await SaveLocalStorage.pref;
    if (value.containsKey('role')) {
      String data = value.getString('role')!;
      _role = data;
      notifyListeners();
      return data;
    } else {
      _role = '';
      notifyListeners();
      return '';
    }
  }
}
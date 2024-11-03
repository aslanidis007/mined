import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mined/authorization/service/load_page.dart';
import 'package:mined/constants/api/api_env.dart';
import 'package:mined/record_face.dart/util/data.dart';
import 'package:mined/routes/router.dart';
import 'package:mined/routes/routes.dart';
import 'package:mined/screens/feedback/feedback_provider.dart';
import 'package:mined/screens/games/service/round_counter.dart';
import 'package:mined/services/auth_system.dart';
import 'package:mined/services/club.dart';
import 'package:mined/services/delete_logout_acc.dart';
import 'package:mined/services/dropdown_selection.dart';
import 'package:mined/services/hide_nav_bar.dart';
import 'package:mined/services/notification.dart';
import 'package:mined/services/selection_list.dart';
import 'package:mined/services/reset_change_password.dart';
import 'package:mined/services/save_variables.dart';
import 'package:mined/services/selection_mechanism.dart';
import 'package:mined/services/talk_to_someone.dart';
import 'package:mined/services/team_mate.dart';
import 'package:mined/services/user_info.dart';
import 'package:mined/services/user_tasks.dart';
import 'package:mined/translations/codegen_loader.g.dart';
import 'package:provider/provider.dart';

List<CameraDescription> cameras = [];
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  ApiEnv.envAction == 'api-dev' 
    ? await dotenv.load(fileName: 'dev.env') 
    : await dotenv.load(fileName: 'prod.env');
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('el'),
      ], 
        fallbackLocale: const Locale('en'),
        assetLoader: const CodegenLoader(),
        path: 'lib/translations',
        child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DeleteLogoutAccount()),
          ChangeNotifierProvider(create: (_) => ResetChangePassword()),
          ChangeNotifierProvider(create: (_) => HideNavBar()),
          ChangeNotifierProvider(create: (_) => TalkToSomeone()),
          ChangeNotifierProvider(create: (_) => TeamMateProvider()),
          ChangeNotifierProvider(create: (_) => ClubProvider()),
          ChangeNotifierProvider(create: (_) => Tasks()),
          ChangeNotifierProvider(create: (_) => AnswerSelection()),
          ChangeNotifierProvider(create: (_) => ResponseModel()),
          ChangeNotifierProvider(create: (_) => UserInfo()),
          ChangeNotifierProvider(create: (_) => DropDownSelection()),
          ChangeNotifierProvider(create: (_) => SaveVariables()),
          ChangeNotifierProvider(create: (_) => PushNotification()),
          ChangeNotifierProvider(create: (_) => FeedbackProvider()),
          ChangeNotifierProvider(create: (_) => AuthSystem()),
          ChangeNotifierProvider(create: (_) => RoundCounter()), 
          ChangeNotifierProvider(create: (_) => LoadPage()),
          ChangeNotifierProvider(create: (_) => RecordData()),
        ],
        child: const MyApp(),
      ),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mined',
      theme: ThemeData(useMaterial3: false),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateRoute: onGenerate,
      initialRoute: AppRoutes.splashScreen,
    );
  }
}


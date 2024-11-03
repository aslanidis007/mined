import 'package:google_sign_in/google_sign_in.dart';
import 'package:mined/constants/api/api_env.dart';

class ApiPaths{
  static String user = '${ApiEnv.apiEnv}api/user';
  static String updateUser = '${ApiEnv.apiEnv}api/user';
  static String checkIn = '${ApiEnv.apiEnv}api/check_in';
  static String emailLogin = '${ApiEnv.apiEnv}api/login';
  static String emailRegister = '${ApiEnv.apiEnv}api/signup';
  static String changePassword = '${ApiEnv.apiEnv}api/changePassword';
  static String resetPassword = '${ApiEnv.apiEnv}api/password/reset';
  static String logout = '${ApiEnv.apiEnv}api/logout';
  static String deleteAccount = '${ApiEnv.apiEnv}api/user/delete';
  static String socialLogin = '${ApiEnv.apiEnv}api/social';
  static String indexes = '${ApiEnv.apiEnv}api/user/indexes';
  static String seeFeedback = '${ApiEnv.apiEnv}api/feedback';
  static String leaveFeedback = '${ApiEnv.apiEnv}api/feedback';
  static String leaveFeedbackRecipient = '${ApiEnv.apiEnv}api/feedback_recipient';
  static String medicalContact = '${ApiEnv.apiEnv}api/user/medical_contact';
  static String medicalContactByUser(String user) => '${ApiEnv.apiEnv}api/user/teammates/$user/medical_contact';
  static String referral = '${ApiEnv.apiEnv}api/referral';
  static String teammate = '${ApiEnv.apiEnv}api/user/teammates';
  static String lifeEventHistory = '${ApiEnv.apiEnv}api/user/life_event';
  static String addLifeEvent = '${ApiEnv.apiEnv}api/user/life_event';
  static String lifeEventById(String id) => '${ApiEnv.apiEnv}api/user/life_event/$id';
  static String feedbackArea(int areaId, String date) => '${ApiEnv.apiEnv}api/user/feedbackArea/$areaId?date=$date';
  static String lifeEventType = '${ApiEnv.apiEnv}api/life_event_type';
  static String club = '${ApiEnv.apiEnv}api/user/membership';
  static String tasks = '${ApiEnv.apiEnv}api/assigned_tasks';
  static String selfTaskInfo = '${ApiEnv.apiEnv}api/self/task/information';
  static String notification = '${ApiEnv.apiEnv}api/push_notifications';
  static String sendFirebasetoken = '${ApiEnv.apiEnv}api/user';
  static String getUserIndividuals = '${ApiEnv.apiEnv}api/personnel/individuals';
  static String deleteNotification(String notificationId) => '${ApiEnv.apiEnv}api/push_notifications/$notificationId';
  static String startTaskItem(String assignedTaskId) => '${ApiEnv.apiEnv}api/assigned_task/$assignedTaskId/start';
  static String tasksItem(String assignedTaskId) => '${ApiEnv.apiEnv}api/assigned_task/$assignedTaskId/task_item';
  static String completeTasksItem(String assignedTaskItemId) => '${ApiEnv.apiEnv}api/assigned_task_item/$assignedTaskItemId/complete';
  static String completeTasks(String assignedTaskId) => '${ApiEnv.apiEnv}api/assigned_task/$assignedTaskId/complete';
  static String clubDelete(String membershipId) => '${ApiEnv.apiEnv}api/membership/$membershipId';
  static String videoUrl(String assignedTaskItemId)=> '${ApiEnv.apiEnv}api/assigned_task_item/$assignedTaskItemId/video/url';
  static String completeVideo(String assignedTaskItemId)=> '${ApiEnv.apiEnv}api/assigned_task_item/$assignedTaskItemId/video/success';
  static String terraApi = 'https://api.tryterra.co/v2/generateWidgetSession';
  static String fetchProviders = '${ApiEnv.apiEnv}api/user/terra/providers';
  static String deleteProvider = '${ApiEnv.apiEnv}api/user/terra/delete/provider';
  static String generatetoken = 'https://api.tryterra.co/v2/generateAuthToken';
  static String selfTasks = '${ApiEnv.apiEnv}api/self/tasks';
  static String postSelfTasks = '${ApiEnv.apiEnv}api/self/task';
  static String summary(assignedTaskId) => '${ApiEnv.apiEnv}api/assigned_task/$assignedTaskId/summary';

  static final googleSignInAndroid = GoogleSignIn();
  static GoogleSignIn googleSignInIos = GoogleSignIn(
    clientId:'314832938568-hj3ap9otp8t1f7659m68dvibho61thg0.apps.googleusercontent.com',
  );
  static Future<GoogleSignInAccount?> loginAndroid() => googleSignInAndroid.signIn();
  static Future<GoogleSignInAccount?> logoutAndroid() => googleSignInAndroid.signOut();

  static Future<GoogleSignInAccount?> loginApple() => googleSignInIos.signIn();
  static Future<GoogleSignInAccount?> logoutApple() => googleSignInIos.signOut();

}

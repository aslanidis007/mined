import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mined/firebase/notification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/save_local_storage.dart';
import '../services/notification.dart';

class FirebaseMessage {
  NotificationService notificationService = NotificationService();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

   Future<void> initNotifications(context) async {
    SharedPreferences localStorageData = await SaveLocalStorage.pref;

    await notificationService.initNotification();
    await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true
    );
    //Send user firebase token.
    String? token = await messaging.getToken();
    await Provider.of<PushNotification>(context, listen:false).sendToken(token,context);
    
    await localStorageData.setString('firebaseToken', token ?? '');


        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        if (message.notification != null) {
          // Show the notification to the user
          await notificationService.showNotification(
              id: 0, // Notification ID
              title: '${message.notification!.title}', // Notification title
              body: '${message.notification!.body}', // Notification body
              payLoad: 'mined '// Notification payload (optional)
              );
              
        }
        // Future<void> _firebaseMessagingBackgroundHandler(
        //     RemoteMessage message) async {
        //   print("Handling a background message: ${message.data}");
        //   // Display local notification using Flutter Local Notifications
        //   return await notificationService.showNotification(
        //       id: 0, // Notification ID
        //       title: '${message.notification!.title}', // Notification title
        //       body: '${message.notification!.body}', // Notification body
        //       payLoad: 'Piney' // Notification payload (optional)
        //       );
        // }

        // FirebaseMessaging.onBackgroundMessage(
        //     _firebaseMessagingBackgroundHandler);
      });
  }
}

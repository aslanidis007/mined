import 'package:mined/firebase/firebase_notification.dart';
import 'package:permission_handler/permission_handler.dart';

resultNotificationStatus() async{
  var status = await Permission.notification.status;
    if(status.isGranted){
      return true;
    }else{
      return false;
    }
}

  notifyPermission(context) async{
     await FirebaseMessage().initNotifications(context);
     return true;
  }
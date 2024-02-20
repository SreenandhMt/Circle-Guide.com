
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging _messaging = FirebaseMessaging.instance;

class FirebaseNotification {
  Future<String?>getFirebaseMessagingToken() async{
   await _messaging.requestPermission();
   final location = await _messaging.getToken();
   log(location.toString());
   return location;
  }
}
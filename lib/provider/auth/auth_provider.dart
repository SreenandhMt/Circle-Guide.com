import 'dart:developer';

import 'package:circle_guide/module/messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPeovider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseNotification notification = FirebaseNotification();
  String? error;
  Future<void> loginWithEmailAndPassword(String email,String password,BuildContext ctx)async{
    try {
      String? token = await notification.getFirebaseMessagingToken();
      if(token==null)return;
      log(token);
      await auth.signInWithEmailAndPassword(email: email, password: password).then((value) => firestore.collection('profile').doc(auth.currentUser!.uid).update({
        'uid':value.user!.uid,
        'email':value.user!.email,
        'NotificationId':token
      }));
    } on FirebaseAuthException catch (e) {
      error= e.message!;
      return;
    }
  }
  Future<void> newCreateWithEmailAndPassword(String email,String password,String confromPass,String name,BuildContext ctx)async{
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      String? token = await notification.getFirebaseMessagingToken();
      if(token==null)return;
      log(token);
      firestore.collection('profile').doc(auth.currentUser!.uid).set({
        'uid':auth.currentUser!.uid,
        'email':auth.currentUser!.email,
        'NotificationId':token,
        'name':auth.currentUser!.displayName,
      });
      await auth.currentUser!.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      error= e.message!;
      return;
    }
  }
  void logout(){
    auth.signOut();
    ChangeNotifier();
  }
}
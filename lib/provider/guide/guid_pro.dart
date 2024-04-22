
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GuideProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<Map<String,dynamic>>? friendRequest, guidesRequest,myGuides, myFriendsCollection;
  
  
  Future<void> sendGuideRequest(String uid,String chatId,String senderId,String senderName,String senderEmail,String token)async{
    try {
      await firestore.collection("Folders/GuidesRequest/$senderId").doc("$uid+$chatId+$senderId").set({
        "senderId":senderId,
        "receverId":uid,
        "senderEmail":senderEmail,
        "senderName":senderName,
        "token":token,
        "id":uid,
        "date":Timestamp.now().millisecondsSinceEpoch,
        "chatId":chatId,
        "docId":"$uid+$chatId+$senderId"
      });
      // final data = await firestore.collection("chats/$chatId").get().then((value) => value.docs.map((e) => MassageModule.formJeson(e.data())).toList());
      return;
    } catch (e) {
      return;
    }
  }

  Future<void> getGuideRequest(String uid)async{
    try {
      guidesRequest = await firestore.collection("Folders/GuidesRequest/$uid").get().then((value) => value.docs.map((e) => e.data()).toList());
      log("guide data =< $guidesRequest");
      notifyListeners();
      // final data = await firestore.collection("chats/$chatId").get().then((value) => value.docs.map((e) => MassageModule.formJeson(e.data())).toList());
      return;
    } catch (e) {
      return;
    }
  }

  Future<void> acceptGuideRequest(String uid,String uName,String uEmail,String uToken,String chatId,String senderId,String senderName,String senderEmail,String docId)async{
    try {
      await firestore.collection("Folders/GuidesRequest/$uid").doc(docId).delete();
      await getGuideRequest(uid);
      notifyListeners();
      firestore.collection("Folders/MyGuide/$senderId").doc(uid).set({
        "senderId":senderId,
        "gId":uid,
        "gName":uName,
        "gEmail":uEmail,
        "gToken":uToken,
        "senderEmail":senderEmail,
        "senderName":senderName,
        "date":Timestamp.now().millisecondsSinceEpoch,
        "chatId":chatId
      });
      await getGuideDatas(uid);
      // final data = await firestore.collection("chats/$chatId").get().then((value) => value.docs.map((e) => MassageModule.formJeson(e.data())).toList());
      return;
    } catch (e) {
      return;
    }
  }

  Future<void> getGuideDatas(String uid)async{
    try {
       myGuides= await firestore.collection("Folders/MyGuide/$uid").get().then((value) => value.docs.map((e) => e.data()).toList());
       notifyListeners();
      // final data = await firestore.collection("chats/$chatId").get().then((value) => value.docs.map((e) => MassageModule.formJeson(e.data())).toList());
      return;
    } catch (e) {
      return;
    }
  }

  Future<void> deleteGuide(String uid,String senderId)async{
    try {
      firestore.collection("Folders/MyGuide/$uid").doc(senderId).delete();
      // final data = await firestore.collection("chats/$chatId").get().then((value) => value.docs.map((e) => MassageModule.formJeson(e.data())).toList());
      return;
    } catch (e) {
      return;
    }
  }

}



class MassageModule {
  const MassageModule(
    this.massage,
    this.senderid,
    this.locx,
    this.loxy,
    this.time,
  );
  final String? massage;
  final String senderid;
  final double? locx;
  final double? loxy;
  final String time;

  factory MassageModule.formJeson(Map<String,dynamic> map){
    return MassageModule(map["massage"], map['senderid'], map["locx"],map["locy"],map["time"]);
  }


}

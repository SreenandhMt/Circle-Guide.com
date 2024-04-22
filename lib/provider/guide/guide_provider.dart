import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GuidePageProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<Map<String,dynamic>>? friendRequest, myFriendsCollection;

  Future<void> sendFriendRequest(String receverId,String senderId,String senderName,String senderEmail,String senderToken)async{
    try {
      await firestore.collection("Folders/request/$receverId").doc("$receverId+$senderId").set({
        "senderId":senderId,
        "senderEmail":senderEmail,
        "senderName":senderName,
        "senderToken":senderToken,
        "docId":"$receverId+$senderId"
      });
      // final data = await firestore.collection("chats/$chatId").get().then((value) => value.docs.map((e) => MassageModule.formJeson(e.data())).toList());
      return;
    } catch (e) {
      return;
    }
  }
  Future<void> acceptFriendRequest(String senderId,String senderName,String senderEmail,String senderToken,String docId)async{
    try {
      final id = await firestore.collection("chats").add({}).then((value) => value.id);
      await firestore.collection("Folders/myFriends/${firebaseAuth.currentUser!.uid}").doc(senderId).set({
        "fId":senderId,
        "fEmail":senderEmail,
        "fName":senderName,
        "ftoken":senderToken,
        "chatId":id,
        "date":Timestamp.now().microsecondsSinceEpoch
      });
      await firestore.collection("Folders/myFriends/$senderId").doc(firebaseAuth.currentUser!.uid).set({
        "fId":firebaseAuth.currentUser!.uid,
        "fEmail":firebaseAuth.currentUser!.email,
        "fName":firebaseAuth.currentUser!.displayName,
        "ftoken":firebaseAuth.currentUser!.photoURL,
        "chatId":id,
        "date":Timestamp.now().microsecondsSinceEpoch
      });
      await firestore.collection("Folders/request/${firebaseAuth.currentUser!.uid}").doc(docId).delete();
      // final data = await firestore.collection("chats/$chatId").get().then((value) => value.docs.map((e) => MassageModule.formJeson(e.data())).toList());
      return;
    } catch (e) {
      return;
    }
  }
  Future<void> deleteFriend(String senderId,String chatId)async{
    try {
      await firestore.collection("Folders/myFriends/${firebaseAuth.currentUser!.uid}").doc(senderId).delete();
      await firestore.collection("Folders/myFriends/$senderId").doc(firebaseAuth.currentUser!.uid).delete();
      await getMyFriends();
      notifyListeners();
      try {
        await firestore.collection("Folders/chats/$chatId").get().then((value) => value.docs.map((e)async{
          await firestore.collection("Folders/chats/$chatId").doc(e.id).delete();
          log(e.id);
          return 1;
        }).toList());
      } catch (e) {
        log(e.toString());
      }
      return;
    } catch (e) {
      return;
    }
  }
  Future<String?> getMyFriends()async{
    try {
      myFriendsCollection = await firestore.collection("Folders/myFriends/${firebaseAuth.currentUser!.uid}").orderBy("date",descending: true).get().then((value) => value.docs.map((e) => e.data()).toList());
      notifyListeners();
      return "";
    } catch (e) {
      return e.toString();
    }
  }
  Future<void> getMyRequest()async{
    try {
      log(firebaseAuth.currentUser!.uid);
      friendRequest = await firestore.collection("Folders/request/${firebaseAuth.currentUser!.uid}").get().then((value) => value.docs.map((e) => e.data()).toList());
      log("data done => $friendRequest");
      notifyListeners();
      return ;
    } catch (e) {
      return ;
    }
  }

  Future<void> updateSeenData(String senderid,String receverId,String? massage)async{
    DateTime date = DateTime.now();
    final newDate = formatDate(date, [hh, ':', nn, ' ', am]);
    if(massage==null)
    {
      try{
      final data = await firestore.collection("Folders/myFriends/$senderid").doc(receverId).get().then((value) => value.data());
        // "fId":firebaseAuth.currentUser!.uid,
        // "fEmail":firebaseAuth.currentUser!.email,
        // "fName":firebaseAuth.currentUser!.displayName,
        // "chatId":id,
        // "date":Timestamp.now().microsecondsSinceEpoch
        await firestore.collection("Folders/myFriends/$senderid").doc(receverId).update({
        "lastMassage":"Location Sended",
        "time":newDate,
        "receverId":receverId,
        "senderId":senderid,
        "loc":null,
        "seenBy":0,
        "fId":data!['fId'],
        "fEmail":data["fEmail"],
        "fName":data["fName"],
        "chatId":data['chatId'],
        "date":Timestamp.now().microsecondsSinceEpoch
      });
        } catch (e) {
          log(e.toString());
        }
        try {
          final data = await firestore.collection("Folders/myFriends/$receverId").doc(senderid).get().then((value) => value.data());
        // "fId":firebaseAuth.currentUser!.uid,
        // "fEmail":firebaseAuth.currentUser!.email,
        // "fName":firebaseAuth.currentUser!.displayName,
        // "chatId":id,
        // "date":Timestamp.now().microsecondsSinceEpoch
        await firestore.collection("Folders/myFriends/$receverId").doc(senderid).update({
        "lastMassage":"Location Sended",
        "time":newDate,
        "receverId":receverId,
        "senderId":senderid,
        "loc":null,
        "seenBy":1,
        "fId":data!['fId'],
        "fEmail":data["fEmail"],
        "fName":data["fName"],
        "chatId":data['chatId'],
        "date":Timestamp.now().microsecondsSinceEpoch
      });
        } catch (e) {
          log(e.toString());
        }
        notifyListeners();
        return;
    }
    try {
          final data = await firestore.collection("Folders/myFriends/$senderid").doc(receverId).get().then((value) => value.data());
        // "fId":firebaseAuth.currentUser!.uid,
        // "fEmail":firebaseAuth.currentUser!.email,
        // "fName":firebaseAuth.currentUser!.displayName,
        // "chatId":id,
        // "date":Timestamp.now().microsecondsSinceEpoch
        await firestore.collection("Folders/myFriends/$senderid").doc(receverId).update({
        "lastMassage":massage,
        "time":newDate,
        "receverId":receverId,
        "senderId":senderid,
        "loc":null,
        "seenBy":0,
        "fId":data!['fId'],
        "fEmail":data["fEmail"],
        "fName":data["fName"],
        "chatId":data['chatId'],
        "date":Timestamp.now().microsecondsSinceEpoch
      });
        } catch (e) {
          log(e.toString());
        }
        try {
          final data = await firestore.collection("Folders/myFriends/$receverId").doc(senderid).get().then((value) => value.data());
        // "fId":firebaseAuth.currentUser!.uid,
        // "fEmail":firebaseAuth.currentUser!.email,
        // "fName":firebaseAuth.currentUser!.displayName,
        // "chatId":id,
        // "date":Timestamp.now().microsecondsSinceEpoch
        await firestore.collection("Folders/myFriends/$receverId").doc(senderid).update({
        "lastMassage":massage,
        "time":newDate,
        "receverId":receverId,
        "senderId":senderid,
        "loc":null,
        "seenBy":1,
        "fId":data!['fId'],
        "fEmail":data["fEmail"],
        "fName":data["fName"],
        "chatId":data['chatId'],
        "date":Timestamp.now().microsecondsSinceEpoch
      });
        } catch (e) {
          log(e.toString());
        }
        notifyListeners();
        return;
  }
}

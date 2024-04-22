import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../guide/guid_pro.dart';
import '../guide/guide_provider.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class ChatProvider extends ChangeNotifier {
  Stream<List<MassageModule>>? currentScreenMassage;
  bool isLoding = false;

  Future<List<MassageModule>?> getMassages(String chatId) async {
    try {
      isLoding = true;
      currentScreenMassage = firestore
          .collection("Folders/chats/$chatId")
          .orderBy("date")
          .snapshots()
          .map((snapShot) => snapShot.docs
              .map((document) => MassageModule.formJeson(document.data()))
              .toList()); //get().then((value) => value.docs.map((e) => MassageModule.formJeson(e.data())).toList());
      isLoding = false;
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> removeSeenData(Map<String, dynamic> data) async {
    try {
      if (data['receverId'] == firebaseAuth.currentUser!.uid) {
        final og = await firestore
            .collection("Folders/myFriends/${data['receverId']}")
            .doc(data['senderId'])
            .get()
            .then((value) => value.data());
        await firestore
            .collection("Folders/myFriends/${data['receverId']}")
            .doc(data['senderId'])
            .update({
          "lastMassage": data['lastMassage'],
          "time": data["time"],
          "loc": data["loc"],
          "seenBy": 0,
          "fId": og!['fId'],
          "fEmail": og["fEmail"],
          "fName": og["fName"],
          "chatId": data['chatId'],
          "date": data['date']
        });
        notifyListeners();
      }

      return;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> sendMassages(String receverId, String receverToken,
      String chatId, String senderid, String massage) async {
    try {
      // Timestamp time = Timestamp.now();
      DateTime date = DateTime.now();
      final newDate = formatDate(date, [hh, ':', nn, ' ', am]);
      await firestore.collection("Folders/chats/$chatId").add({
        "massage": massage,
        "senderid": senderid,
        "time": newDate,
        "date": Timestamp.now(),
        "locx": null,
        "locy": null,
      });
      // await getMassages(chatId);
      notifyListeners();
      await GuidePageProvider().updateSeenData(senderid, receverId, massage);

      try {
        final body = {
          "to": receverToken,
          "notification": {
            "title": firebaseAuth.currentUser!.displayName,
            "body": massage
          }
        };
        // post notification
        await post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader:
                'key=AAAACbahdFs:APA91bE9uTLs08FY-2yMELR310O3lcq6Dr8puEeaZPj4eCslm1sfXOicO1xtkpg64q_kglDP6Qx_KyYCxK5MIdmbnqGWhEtEz4VG0tMqxY7JO6vfLwvMnwc1he_gTN-gVwrU3lxIxkVn'
          },
          body: jsonEncode(body),
        );
      } catch (e) {
        log("error notificarion mapping state => $e");
      }

      return;
    } catch (e) {
      return;
    }
  }

  Future<List<MassageModule>?> sendLocation(String chatId, String receverId,
      String senderid, double locx, double locy) async {
    try {
      DateTime date = DateTime.now();
      final newDate = formatDate(date, [hh, ':', nn, ' ', am]);
      await firestore.collection("Folders/chats/$chatId").add({
        "massage": null,
        "senderid": senderid,
        "time": newDate,
        "date": Timestamp.now(),
        "locx": locx,
        "locy": locy,
      });
      // await getMassages(chatId);
      notifyListeners();
      await GuidePageProvider().updateSeenData(senderid, receverId, null);
      return null;
    } catch (e) {
      return null;
    }
  }

  void sos(locx, locy) async {
    log('try');
    // geting my guide data
    await firestore
        .collection("Folders/MyGuide/${firebaseAuth.currentUser!.uid}")
        .get()
        .then((value) {
      // map list of data
      return value.docs.map((e) {
        // send notification on user in 2 time
        mappingnotification(e.data(), locx, locy);
        // returning
        return e.data();
      }).toList();
    });

    // finaly listening
    notifyListeners();
  }

  // sending notifiation on each guides
  Future<void> mappingnotification(data, x, y) async {
    try {
      final body = {
        "to": data['gToken'],
        "notification": {
          "title": "Emergency Notification",
          "body":
              "${data['name']} This Person is Emergency Situcation Please Help"
        }
      };
      // post notification
      await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader:
              'key=AAAACbahdFs:APA91bE9uTLs08FY-2yMELR310O3lcq6Dr8puEeaZPj4eCslm1sfXOicO1xtkpg64q_kglDP6Qx_KyYCxK5MIdmbnqGWhEtEz4VG0tMqxY7JO6vfLwvMnwc1he_gTN-gVwrU3lxIxkVn'
        },
        body: jsonEncode(body),
      );

      await sendLocation(data["chatId"], data["gId"], data["senderId"], x, y);
    } catch (e) {
      log("error notificarion mapping state => $e");
    }
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class GuideProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // adding user to guide
  void addGuideUser(String gid, String token, String email) async {
    Timestamp time = Timestamp.now();
    try {
      //set my guide data
      await firestore
          .collection(
              'Data/UserData/MyGuides/data/${firebaseAuth.currentUser!.uid}')
          .doc(gid)
          .set({
        'gid': gid,
        'uid': firebaseAuth.currentUser!.uid,
        'email': email,
        'token': token,
        'time': time
      });
      // set my user data
      await firestore
          .collection('Data/GuiderData/$gid')
          .doc(firebaseAuth.currentUser!.uid)
          .set({
        'uid': firebaseAuth.currentUser!.uid,
        'gid': gid,
        'email': firebaseAuth.currentUser!.email,
        'time': time,
        'seen': 0
      });
      log('set');
    } catch (e) {
      log(e.toString());
      return;
    }
  }

  //delete user guide
  Future<bool> deleteData(String uid, String gid) async {
    try {
      //delete my guide data
      await firestore
          .collection('Data/UserData/MyGuides/data/$uid')
          .doc(gid)
          .delete();
      //delete my user data
      await firestore.collection('Data/GuiderData/$gid').doc(uid).delete();
      log('delete');
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // get user to all guide data
  Future<List<Map<String, dynamic>>?> getMyGuideData() async {
    try {
      List<Map<String, dynamic>> data = await firestore
          .collection(
              'Data/UserData/MyGuides/data/${firebaseAuth.currentUser!.uid}')
          .orderBy('time', descending: false)
          .get()
          .then((value) => value.docs.map((e) => e.data()).toList());
      notifyListeners();
      return data;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get guide to all user data
  Future<List<Map<String, dynamic>>?> getMyUserData() async {
    try {
      List<Map<String, dynamic>> data = await firestore
          .collection('Data/GuiderData/${firebaseAuth.currentUser!.uid}')
          .orderBy('time', descending: true)
          .get()
          .then((value) => value.docs.map((e) => e.data()).toList());
      notifyListeners();
      return data;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // remove seen data
  Future<void> removeSeenData(data) async {
    try {
      await firestore
          .collection('Data/GuiderData/${data['gid']}')
          .doc(data['uid'])
          .update({
        'uid': data['uid'],
        'gid': data['gid'],
        'email': data['email'],
        'time': data['time'],
        'seen': 0
      });
      log('updated');

      notifyListeners();
    } catch (e) {
      log(e.toString());
      return;
    }
  }

  // sos setup
  void sos(locx, locy) async {
    log('try');
    // geting my guide data
    await firestore
        .collection(
            'Data/UserData/MyGuides/data/${firebaseAuth.currentUser!.uid}')
        .orderBy('time', descending: false)
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
    Timestamp time = Timestamp.now();
    DateTime date = DateTime.now();
    final newDate = formatDate(date, [hh, ':', nn, ' ', am]);
    try {
      log('dddddd');
      // set body
      final body = {
        "to": data['token'],
        "notification": {"title": data['email'], "body": "I Need Help !!!!"}
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
      //update user timestamp for geting time this value come top
      final guider = await firestore
          .collection('Data/GuiderData/${data['gid']}')
          .doc(data['uid'])
          .get();
      await firestore
          .collection('Data/GuiderData/${data['gid']}')
          .doc(data['uid'])
          .update({
        'uid': guider.data()!['uid'],
        'email': guider.data()!['email'],
        'gid': guider.data()!['gid'],
        'time': time,
        'seen': 1
      });
      await firestore
          .collection('Data')
          .doc('help')
          .collection('${guider.data()!['gid']}+${guider.data()!['uid']}')
          .add({
        'time': time,
        'date': newDate,
        'locx': x,
        'locy': y,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  //get location data
  Future<List<Map<String, dynamic>>?> getLocation(
      String uid, String gid) async {
    try {
      final List<Map<String, dynamic>> data = await firestore
          .collection('Data/help/$gid+$uid')
          .orderBy('time', descending: false)
          .get()
          .then((value) => value.docs.map((e) => e.data()).toList());
      notifyListeners();
      return data;
    } catch (e) {
      return null;
    }
  }

  // get all user data
  Future<List<Map<String, dynamic>>?> getGuideData() async {
    try {
      final List<Map<String, dynamic>> data = await firestore
          .collection('profile')
          .get()
          .then((value) => value.docs.map((e) => e.data()).toList());
      notifyListeners();
      return data;
    } catch (e) {
      return null;
    }
  }
}

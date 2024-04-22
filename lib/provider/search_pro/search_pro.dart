
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<Map<String, dynamic>> searchQuary=[];
  List<Map<String, dynamic>>? quarySaver;

  Future<List<Map<String, dynamic>>?> searchData(String search) async {
    try {
      if(search.isEmpty)
      {
        searchQuary.clear();
        notifyListeners();
        return null;
      }
      searchQuary.clear();
      if (quarySaver == null ||quarySaver!.isEmpty) {
        quarySaver = await firestore
            .collection('profile')
            .get()
            .then((value) => value.docs.map((e) => e.data()).toList());
      }
      for (var data in quarySaver!) {
        if (data['email'] != firebaseAuth.currentUser!.email &&
            search.isNotEmpty &&
            data['email'].toString().startsWith(search.toLowerCase())||data['email'] != firebaseAuth.currentUser!.email &&
            search.isNotEmpty &&data['name'].toString().startsWith(search.toLowerCase())) {
          searchQuary.add(data);
        }
      }
      notifyListeners();
      return searchQuary;
    } catch (e) {
      return null;
    }
  }
}

import 'package:circle_guide/bottom_and_screen_conf.dart';
import 'package:circle_guide/page/auth/auth_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthRout extends StatelessWidget {
  const AuthRout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snap){
      if(snap.hasData)
      {
        return const MainScreen();
      }else{
        return const MainAuthScreenData();
      }
    }),
    );
  }
}
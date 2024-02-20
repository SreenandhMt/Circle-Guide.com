import 'package:circle_guide/core/size/size.dart';
import 'package:circle_guide/provider/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class ScreenAccount extends StatelessWidget {
  const ScreenAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account'),),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            const SizedBox(height: 29,),
          const CircleAvatar(
            radius: 50,
          ),
          kHeight30,
          Text(_auth.currentUser!.displayName.toString(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          Text(_auth.currentUser!.email.toString(),),
          const SizedBox(height: 30,),
          TextButton(onPressed: (){
            context.read<AuthPeovider>().logout();
          }, child: const Text('Logout'))
          ],
        ),
      ),
    );
  }
}
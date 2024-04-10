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
            backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTl57bnOsiSuCYk-5Z7jZBAFA-1q9-P-pgeiA&s"),
            radius: 50,
          ),
          kHeight30,
          Text(_auth.currentUser!.displayName.toString(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          Text(_auth.currentUser!.email.toString(),),
          const Expanded(child: SizedBox(height: 30,)),
          ElevatedButton(onPressed: (){
            context.read<AuthPeovider>().logout();
          }, child: const Text('Logout')),
          const SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}
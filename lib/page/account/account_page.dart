import 'package:circle_guide/core/size/size.dart';
import 'package:circle_guide/core/theme/thmes.dart';
import 'package:circle_guide/provider/auth/auth_provider.dart';
import 'package:circle_guide/provider/chat/chat_provider.dart';
import 'package:circle_guide/provider/guide/guid_pro.dart';
import 'package:circle_guide/provider/theme_provider/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class ScreenAccount extends StatelessWidget {
  const ScreenAccount({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<GuideProvider>().getGuideRequest(firebaseAuth.currentUser!.uid);
    context.read<GuideProvider>().getGuideDatas(firebaseAuth.currentUser!.uid);
    return Consumer<GuideProvider>(
      builder: (context, value, child) {
        if(value.guidesRequest==null)
        {
          return Scaffold(
        appBar: AppBar(title: const Text('Account'),backgroundColor: Theme.of(context).colorScheme.secondary,),
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
            const Expanded(child: SizedBox()),
            ElevatedButton(onPressed: (){
              context.read<AuthPeovider>().logout();
            }, child: const Text('Logout')),
            const SizedBox(height: 30,)
            ],
          ),
        ),
      );
        }
        return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text('Account'),actions: [
          IconButton(onPressed: (){
            Provider.of<ThemeProvider>(context,listen: false).setData();
          }, icon: Icon(Provider.of<ThemeProvider>(context).theme==themeDark?Icons.dark_mode_rounded:Icons.light_mode_rounded)),
          IconButton(onPressed: (){
            context.read<AuthPeovider>().logout();
          }, icon: const Icon(Icons.logout_outlined))
        ],),
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
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
              const SizedBox(height: 40,),
              value.guidesRequest!=null&&value.guidesRequest!.isNotEmpty?const Row(
                children: [
                  SizedBox(width: 15,),
                  Text("Guide Requst"),
                ],
              ):const SizedBox(),
              Column(
                children: List.generate(value.guidesRequest!.length, (index) => Container(margin: const EdgeInsets.only(left: 10,right: 10,bottom: 3,top: 3),decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary,borderRadius: BorderRadius.circular(10)),child: ListTile(leading: const CircleAvatar(radius: 14,backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTl57bnOsiSuCYk-5Z7jZBAFA-1q9-P-pgeiA&s"),),title: Text(value.guidesRequest![index]["senderName"]),onTap: () => value.acceptGuideRequest(firebaseAuth.currentUser!.uid,firebaseAuth.currentUser!.displayName!,firebaseAuth.currentUser!.email!,firebaseAuth.currentUser!.photoURL!,value.guidesRequest![index]["chatId"], value.guidesRequest![index]["receverId"], value.guidesRequest![index]["senderName"], value.guidesRequest![index]["senderEmail"], value.guidesRequest![index]["docId"]),))),
              ),
              const SizedBox(height: 20,),
              value.myGuides!=null&&value.myGuides!.isNotEmpty?
              const Row(
                children: [
                  SizedBox(width: 15,),
                  Text("You'r Guides"),
                ],
              ):const SizedBox(),
              
              value.myGuides!=null?Column(
                children: List.generate(value.myGuides!.length, (index) => Container(margin: const EdgeInsets.only(left: 10,right: 10,bottom: 3,top: 3),decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary,borderRadius: BorderRadius.circular(10)),child: ListTile(leading: const CircleAvatar(radius: 14,backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTl57bnOsiSuCYk-5Z7jZBAFA-1q9-P-pgeiA&s"),),title: Text(value.myGuides![index]["gName"]),subtitle: Text(value.myGuides![index]['gEmail']),))),
              ):const SizedBox(),
              const SizedBox(height: 30,)
              ],
            ),
          ),
        ),
      );
      },
    );
  }
}
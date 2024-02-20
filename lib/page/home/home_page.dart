import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'package:circle_guide/provider/guide/guide_provider.dart';
import 'package:url_launcher/url_launcher.dart';

dynamic _locx,_locy;
FirebaseAuth _auth = FirebaseAuth.instance;

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 8, bottom: 8, top: 4),
          width: 20,
          height: 20,
          color: Colors.red,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_auth.currentUser!.displayName.toString(), style: const TextStyle(fontSize: 13)),
            const Text(
              'Complete Profile',
              style: TextStyle(fontSize: 14, color: Colors.yellow),
            )
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 8,
                ),
                Text('Alan Stre...'),
                Text(
                  'Safe Location',
                  style: TextStyle(color: Colors.yellow),
                )
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children:  [
             const SizedBox(
              height: 26,
            ),
             const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Emergency Help',
                  style: TextStyle(fontSize: 37),
                ),
                Text(
                  'Needed ?',
                  style: TextStyle(fontSize: 37),
                )
              ],
            ),
             const SizedBox(
              height: 30,
            ),
             CircleAvatar(
              radius: 110,
              backgroundColor: Colors.white,
              child:CircleAvatar(
              radius: 105,
              backgroundColor: Colors.red,
              child: IconButton(onPressed: ()async{
                await locGetLocationUpdates();
                if(!context.mounted)return;
                context.read<GuideProvider>().sos(_locx, _locy);
              }, icon: const Icon(
                Icons.sensors,
                size: 200,
              ),)
            ),
            ),
            
            const SizedBox(
              height: 6,
            ),
            const Align(alignment: Alignment.center,child: Text('Press tha button to send SOS')),
             const SizedBox(
              height: 30,
            ),
             Padding(
              padding:  const EdgeInsets.only(left: 8),
              child:  Column(
                children: [
                  Row(
                    children: [
                      CustomCard(icon: Icons.local_police_outlined,text: 'Police\n100',onTap: ()=>FlutterPhoneDirectCaller.callNumber('+100000'),),
                      CustomCard(icon: Icons.woman_rounded,text: 'Women\nhelpline',onTap: ()=>FlutterPhoneDirectCaller.callNumber('+1380'),),
                    ],
                  ),
                   Row(
                    children: [
                      CustomCard(icon: Icons.healing_sharp,text: 'Nearby\nHospital',onTap: (){
                        launchUrl(Uri.parse('https://www.google.com/search?q=nearby+hospitals'));
                      }),
                      CustomCard(icon: Icons.business_rounded,text: 'Nearby\nPolice Station',onTap:(){
                        launchUrl(Uri.parse('https://www.google.com/search?q=nearby+police+station'));
                      }),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> locGetLocationUpdates()async{
    Location location =Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    log('set log');
    serviceEnabled = await location.serviceEnabled();
    if(serviceEnabled)
    {
      serviceEnabled = await location.requestService();
    }else{
      return;
    }
    permissionGranted = await location.hasPermission();
    if(permissionGranted == PermissionStatus.denied)
    {
      permissionGranted = await location.requestPermission();
      if(permissionGranted != PermissionStatus.granted)
      {
        log('error');
        return;
      }
    }
     location.getLocation().then((loccation) {
      if(loccation.latitude!=null&&loccation.longitude!=null)
      {
        log('data gets');
        _locx = loccation.latitude!;
        _locy = loccation.longitude!;
      }
    });
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    required this.text,
    required this.icon,
    this.onTap,
  }) : super(key: key);
  final String text;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final sreenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        height: sreenSize.height*0.14,
        width: sreenSize.width*0.44,
        decoration: BoxDecoration(color: Colors.grey[800],borderRadius: BorderRadius.circular(5)),
        child:  Stack(
          children: [
            Positioned(left: 5,top: 10,child: Row(
              children: [
                Icon(icon,size: 50,color: Colors.grey),
                const SizedBox(width: 8,),
                Text(text,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
              ],
            )),
            const Positioned(right: 4,top: 4,child: Icon(Icons.question_mark_rounded),),
            const Positioned(right: 0,bottom: 4,child: Icon(Icons.navigate_next_sharp,size: 30,color: Colors.red,))
          ],
        ),
      ),
    );
  }
}

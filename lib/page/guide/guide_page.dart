import 'package:circle_guide/page/search/friend_request.dart';
import 'package:circle_guide/provider/chat/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:circle_guide/page/search/search_guide_page.dart';
import 'package:circle_guide/page/chat/chat_page.dart';

import '../../provider/guide/guide_provider.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class ScreenGuide extends StatelessWidget {
  const ScreenGuide({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<GuidePageProvider>().getMyFriends();
    return Consumer<GuidePageProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text('Guides'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contex) => const ScreenNewGuideAdding()));
                },
                icon: const Icon(Icons.group_add_outlined)),
            IconButton(onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contex) => const FriendRequestListPage()));
            }, icon: const Icon(Icons.notification_add_sharp)),
          ],
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 17),
              child: Text(
                'Contacts',
                style: TextStyle(fontSize: 16),
              ),
            ),
            value.myFriendsCollection != null
                ? Column(
                    children: List.generate(
                        value.myFriendsCollection!.length,
                        (index) => GuideTile(
                              data: value.myFriendsCollection![index]
                            )),
                  )
                : const SizedBox(),
          ],
        ),
      );
    });
  }

}

class GuideTile extends StatelessWidget {
  const GuideTile({
    Key? key,
    required this.data
  }) : super(key: key);
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.read<ChatProvider>().removeSeenData(data);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScreenChatPage(
                    data: data,
                  )));
      },
      child: 
      Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Theme.of(context).colorScheme.primary),
        width: double.infinity,height: 70,child: Stack(
          children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Align(alignment: Alignment.centerLeft,child: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.background,child: data['seenBy']==1?const Align(alignment: Alignment.topRight,child: CircleAvatar(radius: 3,backgroundColor: Colors.red,)):const SizedBox(),)),
        ),
        Align(alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${data['fName']??""}'),
          Text("${data['lastMassage']}")
            ],
          ),
        ),
        Align(alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text("${data['time']??""}",style: const TextStyle(fontSize: 10),),
          ),
        ),
      ],),)
      // ListTile(
      //   leading: const CircleAvatar(),
      //   title: Text('${data['fName']}'),
      //   subtitle: ,
      //   trailing:data['seenBy']==1?CircleAvatar(radius: 3,backgroundColor: Colors.red,):SizedBox(),
      // ),
    );
  }
}

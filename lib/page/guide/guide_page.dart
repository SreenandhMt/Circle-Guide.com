import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:circle_guide/page/add_guide/add_guide_page.dart';
import 'package:circle_guide/page/chat/help_page.dart';
import 'package:circle_guide/provider/guide/guide_provider.dart';

List<Map<String, dynamic>>? guiderValues;
List<Map<String, dynamic>>? guiderData;
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class ScreenGuide extends StatelessWidget {
  const ScreenGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GuideProvider>(builder: (context, value, child) {
      getMyGuideData(context);
      getMyUserData(context);
      return Scaffold(
        appBar: AppBar(
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
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            guiderData != null
                ? const Padding(
                    padding: EdgeInsets.only(left: 17),
                    child: Text(
                      'You Are a Guide',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : const SizedBox(),
            guiderData != null
                ? Column(
                    children: List.generate(
                        guiderData!.length,
                        (index) => GuideTile(
                              data: guiderData![index],
                              type: true,
                              newData: index == 0 ? true : false,
                            )),
                  )
                : const SizedBox(),
            const Padding(
              padding: EdgeInsets.only(left: 17),
              child: Text(
                'Guides',
                style: TextStyle(fontSize: 16),
              ),
            ),
            guiderValues != null
                ? Column(
                    children: List.generate(
                        guiderValues!.length,
                        (index) => GuideTile(
                              data: guiderValues![index],
                              type: false,
                              newData: false,
                            )),
                  )
                : const SizedBox(),
          ],
        ),
      );
    });
  }

  void getMyGuideData(BuildContext context) async {
    final value = await context.read<GuideProvider>().getMyGuideData();
    if (value != null && value.isNotEmpty) {
      guiderValues = value;
    }else{
      guiderValues=null;
    }
  }

  void getMyUserData(BuildContext context) async {
    final value = await context.read<GuideProvider>().getMyUserData();
    if (value != null && value.isNotEmpty) {
      guiderData = value;
    }else{
      guiderData = null;
    }
  }
}

class GuideTile extends StatelessWidget {
  const GuideTile({
    Key? key,
    required this.data,
    required this.type,
    required this.newData,
  }) : super(key: key);
  final Map<String, dynamic> data;
  final bool type;
  final bool newData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (type) {
          await context.read<GuideProvider>().removeSeenData(data);
          if (!context.mounted) return;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScreenChatPage(
                type: type,
                    data: data,
                  )));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScreenChatPage(
                type: type,
                    data:data,
                  )));
        }
      },
      child: ListTile(
        leading: const CircleAvatar(),
        title: const Text('Name'),
        subtitle: Text(data['email']),
        trailing: data['seen'] != null && data['seen'] != 0
            ? const CircleAvatar(radius: 5)
            : const SizedBox(),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/guide/guide_provider.dart';

class FriendRequestListPage extends StatelessWidget {
  const FriendRequestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GuidePageProvider>(
      builder: (context, value, child) {
        context.read<GuidePageProvider>().getMyRequest();
        if (value.friendRequest == null) {
          return Scaffold(
            appBar: AppBar(title: const CupertinoSearchTextField(),centerTitle: true,),);
        }
        return Scaffold(
            appBar: AppBar(title: const CupertinoSearchTextField(),centerTitle: true,),
            body: ListView(
              children: List.generate(
                  value.friendRequest!.length,
                  (index) => Container(margin: const EdgeInsets.only(left: 10,right: 10,bottom: 3,top: 3),decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary,borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                          title: Text(value.friendRequest![index]["senderName"]),
                          subtitle: Text(value.friendRequest![index]["senderEmail"]),
                          leading: const CircleAvatar(radius: 13,),
                          onTap: () => context
                              .read<GuidePageProvider>()
                              .acceptFriendRequest(
                                  value.friendRequest![index]["senderId"],
                                  value.friendRequest![index]["senderName"],
                                  value.friendRequest![index]["senderEmail"],
                                  value.friendRequest![index]["senderToken"],
                                  value.friendRequest![index]["docId"]),
                        ),
                  )),
            ));
      },
    );
  }
}


import 'package:circle_guide/provider/chat/chat_provider.dart';
import 'package:circle_guide/provider/search_pro/search_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/guide/guide_provider.dart';



class ScreenNewGuideAdding extends StatelessWidget {
  const ScreenNewGuideAdding({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Consumer<SearchProvider>(
      builder: (context,value,_) {
        return Scaffold(
          appBar: AppBar(
            title: Card(
              child: CupertinoSearchTextField(
                onChanged: (value){
                    context.read<SearchProvider>().searchData(value);
                  
                },
              ),
            ),
          ),
          body:  value.searchQuary.isNotEmpty?
          ListView(
           children: List.generate(value.searchQuary.length, (index) => GuideTile(data: value.searchQuary[index])),
                    ):const Center(child: Text('Hide data'),),
        );
      }
    );
  }
  
}

class GuideTile extends StatelessWidget {
  const GuideTile({
    Key? key,
    required this.data,
  }) : super(key: key);
  final Map<String,dynamic> data;

  @override
  Widget build(BuildContext context) {
      return Container(margin: const EdgeInsets.only(left: 10,right: 10,bottom: 3,top: 3),decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary,borderRadius: BorderRadius.circular(10)),
        child: ListTile(
              leading: const CircleAvatar(),
              title: Text("${data['name']}"),
              subtitle: Text(data['email']),
              onTap: (){
                context.read<GuidePageProvider>().sendFriendRequest(data["uid"], firebaseAuth.currentUser!.uid, firebaseAuth.currentUser!.displayName!, firebaseAuth.currentUser!.email!,firebaseAuth.currentUser!.photoURL!);
              },
              trailing: Container(
                width: 70,
                height: 30,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.green,),
                child: const Center(
                  child: Text('add'),
                ),
              ),
            ),
      );
  }
}

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/guide/guide_provider.dart';

ValueNotifier<String> _searchData = ValueNotifier('');
List<Map<String,dynamic>>? _mainUserData;


class ScreenNewGuideAdding extends StatelessWidget {
  const ScreenNewGuideAdding({super.key});

  @override
  Widget build(BuildContext context) {
    setdata(context);
    return Consumer<GuideProvider>(
      builder: (context,value,_) {
        return Scaffold(
          appBar: AppBar(
            title: Card(
              child: CupertinoSearchTextField(
                onChanged: (value){
                  _searchData.value=value;
                },
              ),
            ),
          ),
          body:  _mainUserData!=null?
          ValueListenableBuilder(valueListenable: _searchData, builder: (context,values,_){
           return ListView(
            children: List.generate(_mainUserData!.length, (index) => GuideTile(data: _mainUserData![index])),
          );
          }):const Center(child: Text('Hide data'),),
        );
      }
    );
  }
  void setdata(BuildContext context)async{
    final value = await context.read<GuideProvider>().getGuideData();
    if(value!=null&&value.isNotEmpty)
    {
      log('data load');
      _mainUserData=value;
    }
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
    if(_searchData.value.isNotEmpty&&data['email'].toString().startsWith(_searchData.value.toLowerCase()))
    {
      return ListTile(
            leading: const CircleAvatar(),
            title: const Text('Name'),
            subtitle: Text(data['email']),
            trailing: GestureDetector(
              onTap: (){
                log('seee');
                context.read<GuideProvider>().addGuideUser(data['uid'], data['NotificationId'],data['email']);
              },
              child: Container(
                width: 70,
                height: 30,
                color: Colors.redAccent,
                child: const Center(
                  child: Text('remove'),
                ),
              ),
            ),
          );
    }else{
      return const SizedBox();
    }
  }
}

import 'dart:developer';

import 'package:circle_guide/page/auth/login/login.dart';
import 'package:circle_guide/page/auth/register/registeration.dart';
import 'package:flutter/material.dart';

ValueNotifier<bool> _notifier = ValueNotifier(true);

class MainAuthScreenData extends StatefulWidget {
  const MainAuthScreenData({
    Key? key,
  }) : super(key: key);

  @override
  State<MainAuthScreenData> createState() => _MainAuthScreenDataState();
}

class _MainAuthScreenDataState extends State<MainAuthScreenData> {
  void getPage() {
    setState(() {
      _notifier.value = !_notifier.value;
      log("ddddddd");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_notifier.value) {
      return ScreenLogin(
        onTap: getPage,
      );
    } else {
      return ScreenRegister(
        onTap: getPage,
      );
    }
  }
}

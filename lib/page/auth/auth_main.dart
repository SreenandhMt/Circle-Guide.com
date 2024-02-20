import 'package:circle_guide/page/auth/login/login.dart';
import 'package:circle_guide/page/auth/register/registeration.dart';
import 'package:flutter/material.dart';

ValueNotifier<bool> _notifier = ValueNotifier(false);

class MainAuthScreenData extends StatelessWidget {
  const MainAuthScreenData({
    Key? key,
  }) : super(key: key);

  void getPage() {
    _notifier.value = !_notifier.value;
  }

  @override
  Widget build(BuildContext context) {
   return ValueListenableBuilder(
        valueListenable: _notifier,
        builder: (context, value, _) {
          if (_notifier.value) {
            return ScreenLogin(onTap: getPage,);
          } else {
            return ScreenRegister(onTap: getPage,);
          }
        });
  }
}

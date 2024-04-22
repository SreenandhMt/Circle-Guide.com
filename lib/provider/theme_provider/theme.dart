import 'dart:developer';

import 'package:circle_guide/core/theme/thmes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class ThemeProvider extends ChangeNotifier {
  
  // ThemeData theme = themeDark;
  ThemeData theme(){
    final data = prefs.getBool('dark');
    if(data!=null&&data)
    {
      return themeDark;
    }else{
      return themeLight;
    }
  }
  void setData()async
  {
    if(theme() == themeDark)
    {
      await prefs.setBool('dark', false);
      theme();
    }else{
      await prefs.setBool('dark', true);
      theme();
    }
    notifyListeners();
  }
}
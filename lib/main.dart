import 'package:circle_guide/firebase_options.dart';
import 'package:circle_guide/module/messaging/firebase_messaging.dart';
import 'package:circle_guide/page/splash/splash_screen.dart';
import 'package:circle_guide/provider/auth/auth_provider.dart';
import 'package:circle_guide/provider/chat/chat_provider.dart';
import 'package:circle_guide/provider/guide/guide_provider.dart';
import 'package:circle_guide/provider/search_pro/search_pro.dart';
import 'package:circle_guide/provider/theme_provider/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/guide/guid_pro.dart';

FirebaseNotification notification = FirebaseNotification();
var prefs;

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider<ThemeProvider>(create: (context){
    return ThemeProvider();
  },child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthPeovider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GuideProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GuidePageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Circle Guide',
        // darkTheme: themeDark,
        theme: Provider.of<ThemeProvider>(context).theme(),
        home: const SplashScreen(),
      ),
    );
  }
}

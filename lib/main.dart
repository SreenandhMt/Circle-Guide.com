import 'package:circle_guide/firebase_options.dart';
import 'package:circle_guide/module/messaging/firebase_messaging.dart';
import 'package:circle_guide/page/auth/auth_rout/auth_rout.dart';
import 'package:circle_guide/provider/auth/auth_provider.dart';
import 'package:circle_guide/provider/guide/guide_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

FirebaseNotification notification = FirebaseNotification();

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(create: (context)=>AuthPeovider(),child: const MyApp(),));
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
          create: (context) => GuideProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Circle Guide',
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const AuthRout(),
      ),
    );
  }
}

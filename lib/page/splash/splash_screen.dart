import 'package:circle_guide/page/auth/auth_rout/auth_rout.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    setPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(image: DecorationImage(image: Theme.of(context).brightness == Brightness.dark?const AssetImage("assets/splash/splash_dark.gif"):const AssetImage("assets/splash/splash.gif"),fit: BoxFit.cover)),
    ),
    );
  }
  
  void setPage() async{
    await Future.delayed(const Duration(seconds: 5),() => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthRout(),), (route) => false),);
  }
}
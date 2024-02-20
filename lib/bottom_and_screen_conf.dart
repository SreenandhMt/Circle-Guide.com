import 'package:circle_guide/page/account/account_page.dart';
import 'package:circle_guide/page/guide/guide_page.dart';
import 'package:circle_guide/page/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier value = ValueNotifier(0);
FirebaseAuth _auth = FirebaseAuth.instance;

List _page = [
  const ScreenHome(),
  const ScreenGuide(),
  const ScreenAccount(),
];

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: value,
      builder: (context, dd, _) {
        return Scaffold(
          body: _page[value.value],
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: value.value,
              onTap: (index) {
                value.value = index;
              },
              selectedIconTheme: const IconThemeData(color: Colors.white),
              unselectedIconTheme: const IconThemeData(color: Colors.grey),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.group_add_outlined), label: 'Guide'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_outlined),
                    label: 'Account'),
              ]),
        );
      },
    );
  }
}

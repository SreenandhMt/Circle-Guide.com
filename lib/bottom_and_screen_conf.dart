import 'package:circle_guide/page/account/account_page.dart';
import 'package:circle_guide/page/guide/guide_page.dart';
import 'package:circle_guide/page/home/home_page.dart';
import 'package:flutter/material.dart';

ValueNotifier value = ValueNotifier(0);

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
          bottomNavigationBar: Theme(
            data: ThemeData(splashColor: Colors.transparent,highlightColor: Colors.transparent,),
            child: BottomNavigationBar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
                currentIndex: value.value,
                type: BottomNavigationBarType.fixed,
                onTap: setPage,
                selectedIconTheme: IconThemeData(color: Theme.of(context).brightness == Brightness.dark? Colors.white:Colors.black),
                unselectedIconTheme: const IconThemeData(color: Colors.grey),
                selectedItemColor: Theme.of(context).brightness == Brightness.dark? Colors.white:Colors.black,
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
          ),
        );
      },
    );
  }

  void setPage(index) {
    value.value = index;
  }
}

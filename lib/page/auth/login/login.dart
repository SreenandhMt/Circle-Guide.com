import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:circle_guide/core/size/size.dart';
import 'package:circle_guide/page/auth/auth_main.dart';
import 'package:circle_guide/provider/auth/auth_provider.dart';
import 'package:circle_guide/widget/button/custom_button.dart';
import 'package:circle_guide/widget/custom/text_field.dart';

TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({
    Key? key,
    this.onTap,
  }) : super(key: key);
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthPeovider>(builder: (context, value, child) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                  child: Text(
                'Welcome',
                style: TextStyle(fontSize: 30),
              )),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(text: 'Email', controller: _email),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(text: 'Password', controller: _password),
              const SizedBox(
                height: 20,
              ),
              GradiantButton(
                onTap: () async {
                  await value.loginWithEmailAndPassword(_email.text, _password.text,context);
                },
                text:'Login',
              ),
              kHeight15,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('alrady a member'),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainAuthScreenData(                              
                                  )),
                          (route) => false);
                    },
                    child: const Text(
                      'registor',
                      style: TextStyle(color: Colors.green),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

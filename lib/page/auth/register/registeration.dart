
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:circle_guide/core/size/size.dart';
import 'package:circle_guide/page/auth/auth_main.dart';
import 'package:circle_guide/provider/auth/auth_provider.dart';
import 'package:circle_guide/widget/button/custom_button.dart';
import 'package:circle_guide/widget/custom/text_field.dart';
TextEditingController _name = TextEditingController();
TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();
TextEditingController _conformpass = TextEditingController();

class ScreenRegister extends StatelessWidget {
  const ScreenRegister({
    Key? key,
    this.onTap,
  }) : super(key: key);
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthPeovider>(
      builder: (context,value,_) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(child: Text('Welcome',style: TextStyle(fontSize: 30),)),
              kHeight10,
              CustomTextField(text: 'Display name',controller: _name),
              kHeight30,
               CustomTextField(text: 'Email',controller: _email),
              kHeight20,
               CustomTextField(text: 'Password',controller: _password),
              kHeight20,
              CustomTextField(text: 'enter a number',controller: _conformpass),
              kHeight20,
              GradiantButton(onTap: ()async{
                final data = Provider.of<AuthPeovider>(context,listen: false);
                await data.newCreateWithEmailAndPassword(_email.text, _password.text,_conformpass.text,_name.text,context);
              }, text:'Register'),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('alrady a member'),
                  const SizedBox(width: 4,),
                  GestureDetector(onTap: ()async{
                 Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>const MainAuthScreenData()), (route) => false);
              }, child: const Text('Login',style: TextStyle(color: Colors.green),))
                ],
              ),
            ],
                ),
          ),
        );
      }
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:circle_guide/core/size/size.dart';
import 'package:circle_guide/provider/auth/auth_provider.dart';
import 'package:circle_guide/widget/button/custom_button.dart';

TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({
    Key? key,
    this.onTap,
  }) : super(key: key);
  final void Function()? onTap;

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthPeovider>(builder: (context, state, child) {
      return Form(
        key: _form,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                    child: Text(
                  'Welcome',
                  style: TextStyle(fontSize: 37,fontWeight: FontWeight.w700),
                )),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  key: const ValueKey("email"),
                  validator: (value) {
                    log(value.toString());
                    if(value!.isEmpty)
                    {
                      return "Enter a Email";
                    }
                    else if(!value.contains("@"))
                    {
                      return "Invaled Email";
                    }else if(state.error!=null&&state.error!.isNotEmpty)
                    {
                      return state.error;
                    }
                    else{
                      return null;
                    }
                  },
                  controller: _email,
                  decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25))),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  key: const ValueKey("password"),

                  validator: (value) {
                    if(value!.isEmpty)
                    {
                      return "Enter a Password";
                    }
                    else if(value.length<=6)
                    {
                      return "Password Minimum 6 Characters";
                    }else{
                      return null;
                    }
                  },
                  controller: _password,
                  decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25))),
                ),
                const SizedBox(
                  height: 20,
                ),
                GradiantButton(
                  onTap: () async {
                    _form.currentState!.validate();
                    // {
                    //   _form.currentState!.save();
                    // }
                    setState(() {
                      
                    });
                    
                    await state.loginWithEmailAndPassword(_email.text, _password.text,context);
                    
                  },
                  text:'Login',
                ),
                kHeight15,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('You are not a member',style: TextStyle(fontSize: 13)),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap:widget.onTap,
                      child: const Text(
                        'Registor',
                        style: TextStyle(color: Colors.green,fontSize: 15),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

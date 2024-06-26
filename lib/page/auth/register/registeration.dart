
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:circle_guide/core/size/size.dart';
import 'package:circle_guide/provider/auth/auth_provider.dart';
import 'package:circle_guide/widget/button/custom_button.dart';
TextEditingController _name = TextEditingController();
TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();
TextEditingController _conformpass = TextEditingController();

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({
    Key? key,
    this.onTap,
  }) : super(key: key);
  final void Function()? onTap;

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthPeovider>(
      builder: (context,state,_) {
        return Form(
          key: _form,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(child: Text('Welcome',style: TextStyle(fontSize: 37,fontWeight: FontWeight.w700),)),
                kHeight15,
                TextFormField(
                    key: const ValueKey("name"),
                        
                    validator: (value) {
                      if(value!.isEmpty)
                      {
                        return "Enter a Name";
                      }
                      else if(value.length<=3)
                      {
                        return "Name Minimum 3 Characters";
                      }else{
                        return null;
                      }
                    },
                    controller: _name,
                    decoration: InputDecoration(
                        hintText: "Enter Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                kHeight10,
                TextFormField(
                    key: const ValueKey("email"),
                    validator: (value) {
                      if(value!.isEmpty)
                      {
                        return "Enter a Email";
                      }
                      else if(!value.contains("@"))
                      {
                        return "Invaled Email";
                      }
                      else if(state.error!=null&&state.error!.isNotEmpty)
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
                kHeight10,
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
                kHeight15,
                GradiantButton(onTap: ()async{
                  _form.currentState!.validate();
                  final data = Provider.of<AuthPeovider>(context,listen: false);
                  await data.newCreateWithEmailAndPassword(_email.text, _password.text,_conformpass.text,_name.text,context);
                }, text:'Register'),
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already a Member',style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 4,),
                    GestureDetector(onTap: widget.onTap, child: const Text('Login',style: TextStyle(color: Colors.green,fontSize: 15),))
                  ],
                ),
              ],
                  ),
            ),
          ),
        );
      }
    );
  }
}

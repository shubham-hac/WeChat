import 'package:flutter/material.dart';
import 'package:wechat/pages/login.dart';
import 'package:wechat/pages/register.dart';

class LoginorRegister extends StatefulWidget {
  const LoginorRegister({super.key});

  @override
  State<LoginorRegister> createState() => _LoginorRegisterState();
}

class _LoginorRegisterState extends State<LoginorRegister> {
  bool showLoginpage = true;

  void togglepages() {
    setState(() {
      showLoginpage = !showLoginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginpage) {
      return Login(onTap: togglepages);
    } else {
      return Myregister(onTap: togglepages);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat/components/mybutton.dart';
import 'package:wechat/components/txtfield.dart';
import 'package:wechat/services/auth/authservice.dart';

class Login extends StatefulWidget {
  final void Function()? onTap;
  const Login({
    super.key,
    required this.onTap,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ignore: non_constant_identifier_names
  void SignIn() async {
    // get auth service
    final authServices = Provider.of<AuthServices>(
      context, 
      listen: false
    );

    try {
      // sign in
      await authServices.signInWithEmailandPassword(
          emailController.text, 
          passwordController.text
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              //logo
              const Icon(
                Icons.messenger_outline_sharp,
                size: 100,
              ),

              const SizedBox(
                height: 30,
              ),

              // welcome
              const Text(
                "Welome Back Login to get started",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // email
              Mytxtfield(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(
                height: 10,
              ),

              // password
              Mytxtfield(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(
                height: 10,
              ),

              // signin
              MyButton(onTap: SignIn, text: 'Sign In'),

              const SizedBox(
                height: 15,
              ),

              // register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('First Time here? '),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      ' Register now!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}

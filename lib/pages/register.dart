import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat/components/mybutton.dart';
import 'package:wechat/components/txtfield.dart';
import 'package:wechat/services/auth/authservice.dart';

class Myregister extends StatefulWidget {
  final void Function()? onTap;
  const Myregister({
    super.key,
    required this.onTap,
  });

  @override
  State<Myregister> createState() => _MyregisterState();
}

class _MyregisterState extends State<Myregister> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  // ignore: non_constant_identifier_names
  Future<void> SignUp() async {
    if (passwordController.text != confirmpasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    //get auth
    final authService = Provider.of<AuthServices>(context, listen: false);
    try {
      await authService.signUpWithEmailandPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
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
                size: 90,
              ),

              const SizedBox(
                height: 25,
              ),

              // welcome
              const Text(
                "Let's Create an account for you!!!",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),

              const SizedBox(
                height: 20,
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

              // confirm password
              Mytxtfield(
                controller: confirmpasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

              const SizedBox(
                height: 10,
              ),

              // signup
              MyButton(onTap: SignUp, text: 'Sign Up'),

              const SizedBox(
                height: 10,
              ),

              // registered
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Already Registerd '),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Login here',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

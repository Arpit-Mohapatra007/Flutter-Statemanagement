import 'package:flutter/material.dart';
import 'package:learning_bloc_2/strings.dart' show enterYourPasswordHere;

class PasswordTextField extends StatelessWidget {
  final TextEditingController passwordController;

  const PasswordTextField({super.key, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: true,
      obscuringCharacter: '*',
      autocorrect: false,
      decoration: const InputDecoration(
        hintText: enterYourPasswordHere
      ),
    );
  }
}
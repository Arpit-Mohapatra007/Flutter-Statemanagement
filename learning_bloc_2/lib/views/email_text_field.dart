import 'package:flutter/material.dart';
import 'package:learning_bloc_2/strings.dart' show enterYourEmailHere;

class EmailTextField extends StatelessWidget {
  final TextEditingController emailController;

  const EmailTextField({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: const InputDecoration(
        hintText: enterYourEmailHere
      ),
    );
  }
}
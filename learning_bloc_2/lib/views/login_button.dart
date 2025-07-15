import 'package:flutter/material.dart';
import 'package:learning_bloc_2/dialogs/generic_dialog.dart';
import 'package:learning_bloc_2/strings.dart';

typedef OnLoginTapped = void Function(
  String email,
  String password,
);

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final OnLoginTapped onLoginTapped;
  const LoginButton({super.key, required this.emailController, required this.passwordController, required this.onLoginTapped});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (){
        final email = emailController.text;
        final password = passwordController.text;
        if(email.isEmpty || password.isEmpty){
         showGenericDialog<bool>(
          context: context, 
          title: emailOrPasswordEmptyDialogTitle, 
          content: emailOrPasswordEmptyDescription, 
          optionsBuilder: ()=>{ok: true}
          );
        }
        else{
          onLoginTapped(email, password);
        }
      }, 
      child: const Text(login)
    );
  }
}
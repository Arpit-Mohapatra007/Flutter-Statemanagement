import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:learning_mobx/state/app_state.dart';
import 'package:provider/provider.dart';

class RegisterView extends HookWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Email you email here...',
              ),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Password here...',
              ),
              obscureText: true,
              obscuringCharacter: '*',
              keyboardAppearance: Brightness.dark,
            ),
            TextButton(
              onPressed: (){
                final email = emailController.text;
                final password = passwordController.text;
                context.read<AppState>().register(email: email, password: password);
              }, 
              child: const Text('Register')
              ),
            TextButton(onPressed: (){
              context.read<AppState>().goTo(AppScreen.login);
            }, child: const Text('Already registered? Login here!'))
          ],
        ),
      ),
    );
  }
}
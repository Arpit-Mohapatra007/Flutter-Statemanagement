import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:learning_mobx/dialogs/show_auth_error.dart';
import 'package:learning_mobx/firebase_options.dart';
import 'package:learning_mobx/loading/loading_screen.dart';
import 'package:learning_mobx/state/app_state.dart';
import 'package:learning_mobx/views/login_view.dart';
import 'package:learning_mobx/views/register_view.dart';
import 'package:learning_mobx/views/reminders_view.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 runApp(
  Provider(
    create: (_) => AppState()..initialize(),
    child: const App()
    )
 );
}

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: ReactionBuilder(
        builder: (context){
          return autorun((_){
            final isLoading = context.read<AppState>().isLoading;
            if(isLoading){
              LoadingScreen.instance().show(
                context: context, 
                text: 'Loading...'
                );
            } else{
              LoadingScreen.instance().hide();
            }

            final authError = context.read<AppState>().authError;
            if(authError != null){
              showAuthError(
                authError: authError, 
                context: context
              );
            }
          }
        );
      },
        child: Observer(
          name: 'Current Scrren',
          builder: (context){
            switch(context.read<AppState>().currentScreen){
              case AppScreen.login:
                return const LoginView();
              case AppScreen.register:
                return const RegisterView();
              case AppScreen.reminders:
                return const RemindersView();
              }
            }
          ),
        ),
    );
  }
}


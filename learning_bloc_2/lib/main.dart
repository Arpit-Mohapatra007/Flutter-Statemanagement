import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc_2/apis/login_api.dart';
import 'package:learning_bloc_2/apis/notes_api.dart';
import 'package:learning_bloc_2/bloc/actions.dart';
import 'package:learning_bloc_2/bloc/app_bloc.dart';
import 'package:learning_bloc_2/bloc/app_state.dart';
import 'package:learning_bloc_2/dialogs/generic_dialog.dart';
import 'package:learning_bloc_2/dialogs/loading_screen.dart';
import 'package:learning_bloc_2/models.dart';
import 'package:learning_bloc_2/strings.dart';
import 'package:learning_bloc_2/views/iterable_list_view.dart';
import 'package:learning_bloc_2/views/login_view.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage)
          ),
        body: BlocConsumer<AppBloc, AppState>(
          builder: (context, appState){
            final notes = appState.fetchedNotes;
            if(notes == null){
              return LoginView(
                onLoginTapped: (email,password){
                  context.read<AppBloc>().add(
                    LoginAction(
                      email: email, 
                      password: password
                    )
                  );
                });
            }
            else{
              return notes.toListView();
            }
          }, 
          listener:(context,appState){
            if(appState.isLoading){
              LoadingScreen.instance().show(
                context: context, 
                text: pleaseWait
                );
            } else{
              LoadingScreen.instance().hide();
            }

            final loginError = appState.loginError;
            if(loginError != null){
              showGenericDialog(
                context: context, 
                title: loginErrorDialogTitle, 
                content: loginErrorDialogContent, 
                optionsBuilder: ()=>{ok:true}
                );
          }

          if(appState.isLoading == false 
          && appState.loginError == null 
          && appState.loginHandle == const LoginHandle.foobar() 
          && appState.fetchedNotes == null){
            context.read<AppBloc>().add(const LoadNotesAction());
          }

          }
          )
      ),
    );
  }
}

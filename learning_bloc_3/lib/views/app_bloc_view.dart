import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc_3/bloc/app_bloc.dart';
import 'package:learning_bloc_3/bloc/app_state.dart';
import 'package:learning_bloc_3/bloc/bloc_events.dart';
import 'package:learning_bloc_3/extensions/stream/start_with.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({super.key});

  void startUpdatingBloc(BuildContext context){
    Stream.periodic(
      const Duration(seconds: 10),
      (_)=> const LoadNextUrlEvent(),
      ).startWith(const LoadNextUrlEvent()).forEach((event){
        // ignore: use_build_context_synchronously
        context.read<T>().add(event);
      });
  }

  @override
  Widget build(BuildContext context) {
    startUpdatingBloc(context);
    return Expanded(
      child: BlocBuilder<T, AppState>(
        builder: (context, appState) {
          if(appState.error != null){
            return const Text('An Error Occurred. Try again in a moment');
          }else if(appState.data != null){
            return Image.memory(
              appState.data!,
              fit: BoxFit.fitHeight,
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }
}
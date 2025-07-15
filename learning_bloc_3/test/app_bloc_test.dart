import 'dart:typed_data' show Uint8List;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_bloc_3/bloc/app_bloc.dart';
import 'package:learning_bloc_3/bloc/app_state.dart';
import 'package:learning_bloc_3/bloc/bloc_events.dart';

extension ToList on String{
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

final text1Data = 'Foo'.toUint8List();
final text2Data = 'Bar'.toUint8List();

enum Errors{dummy}
void main(){
  blocTest<AppBloc, AppState>(
    'Initial state of the bloc should be empty', 
    build: () => AppBloc(urls: []),
    verify: (appBloc) => expect(appBloc.state, const AppState.empty())
    );

  blocTest<AppBloc, AppState>(
    'Loading data from one url testing',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_)=> '',
      urlLoader: (_)=> Future.value(text1Data),
      ),
      act: (appBloc)=> appBloc.add(
        const LoadNextUrlEvent(),
      ),
      expect: ()=>[
        const AppState(isLoading: true, data: null, error: null),
        AppState(isLoading: false, data: text1Data, error: null)
      ]
    );

    blocTest<AppBloc, AppState>(
    'Test throwing an error',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_)=> '',
      urlLoader: (_)=> Future.error(Errors.dummy)),
      act: (appBloc)=> appBloc.add(
        const LoadNextUrlEvent(),
      ),
      expect: ()=>[
        const AppState(isLoading: true, data: null, error: null),
        AppState(isLoading: false, data: null, error: Errors.dummy.toString())
      ]
    );

    blocTest<AppBloc, AppState>(
    'Loading data from more than one url testing',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_)=> '',
      urlLoader: (_)=> Future.value(text2Data),
      ),
      act: (appBloc){
      appBloc.add(
        const LoadNextUrlEvent(),
      );
      appBloc.add(
        const LoadNextUrlEvent(),
      );
    },
      expect: ()=>[
        const AppState(isLoading: true, data: null, error: null),
        AppState(isLoading: false, data: text2Data, error: null),
        const AppState(isLoading: true, data: null, error: null),
        AppState(isLoading: false, data: text2Data, error: null)
      ]
    );
  
}
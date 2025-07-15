import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:learning_bloc_2/apis/login_api.dart';
import 'package:learning_bloc_2/apis/notes_api.dart';
import 'package:learning_bloc_2/bloc/actions.dart';
import 'package:learning_bloc_2/bloc/app_bloc.dart';
import 'package:learning_bloc_2/bloc/app_state.dart';
import 'package:learning_bloc_2/models.dart';

const Iterable<Note> mockNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3'),
];

@immutable 
class DummyNotesApi implements NotesApiProtocol{
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturnForAcceptedLoginHandle;

  const DummyNotesApi({
    required this.acceptedLoginHandle,
    required this.notesToReturnForAcceptedLoginHandle
  });

  const DummyNotesApi.empty()
    : acceptedLoginHandle = const LoginHandle.foobar(),
      notesToReturnForAcceptedLoginHandle = null;
      
  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    if(loginHandle == acceptedLoginHandle){
      return notesToReturnForAcceptedLoginHandle;
    }else{
      return null;
    }
  }
}

@immutable 
class DummyLoginApi implements LoginApiProtocol{
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandle handleToReturn;

  const DummyLoginApi({
    required this.handleToReturn,
    required this.acceptedEmail,
    required this.acceptedPassword
  });
  
  const DummyLoginApi.empty()
    : acceptedEmail = '',
      acceptedPassword = '',
      handleToReturn = const LoginHandle.foobar();

  @override
  Future<LoginHandle?> login({required String email, required String password}) async {
    if(email == acceptedEmail && password == acceptedPassword){
      return handleToReturn;
    }else{
      return null;
    }
  }
}

void main(){
  blocTest<AppBloc,AppState>(
    'Initial state of the bloc should be AppState.empty()',
    build: () => AppBloc(loginApi: const DummyLoginApi.empty(), notesApi: const DummyNotesApi.empty(), acceptedLoginHandle: LoginHandle(token: 'ABC')),
    verify: (appState)=> expect(appState.state, const AppState.empty())
  );

  blocTest<AppBloc,AppState>(
    'Can we login with correct credentials?',
    build: () => AppBloc(loginApi: const DummyLoginApi(acceptedEmail: 'bar@baz.com', acceptedPassword: 'barbaz', handleToReturn: LoginHandle(token: 'ABC')), notesApi: const DummyNotesApi.empty(), acceptedLoginHandle: LoginHandle(token: 'ABC')),
    act: (appBloc) => appBloc.add(const LoginAction(email: 'bar@baz.com', password: 'barbaz')),
    expect:() => [
      const AppState(isLoading: true, loginError: null, loginHandle: null, fetchedNotes: null),
      const AppState(isLoading: false, loginError: null, loginHandle: LoginHandle(token: 'ABC'), fetchedNotes: null),
    ],
  );

  blocTest<AppBloc,AppState>(
    'We should not be able to login with incorrect credentials?',
    build: () => AppBloc(loginApi: const DummyLoginApi(acceptedEmail: 'bar@baz.com', acceptedPassword: 'barbaz', handleToReturn: LoginHandle(token: 'ABC')), notesApi: const DummyNotesApi.empty(), acceptedLoginHandle: LoginHandle(token: 'ABC')),
    act: (appBloc) => appBloc.add(const LoginAction(email: 'bar@baz.com', password: 'baz')),
    expect:() => [
      const AppState(isLoading: true, loginError: null, loginHandle: null, fetchedNotes: null),
      const AppState(isLoading: false, loginError: LoginErrors.invalidHandle, loginHandle: null, fetchedNotes: null),
    ],
  );

  blocTest<AppBloc,AppState>(
    'Load some notes with valid login handle',
    build: () => AppBloc(loginApi: const DummyLoginApi(acceptedEmail: 'bar@baz.com', acceptedPassword: 'barbaz', handleToReturn: LoginHandle(token: 'ABC')), notesApi: const DummyNotesApi(acceptedLoginHandle: LoginHandle(token: 'ABC'), notesToReturnForAcceptedLoginHandle: mockNotes), acceptedLoginHandle: LoginHandle(token: 'ABC')),
    act: (appBloc) {
      appBloc.add(const LoginAction(email: 'bar@baz.com', password: 'barbaz'));
      appBloc.add(const LoadNotesAction());
    },
    expect:() => [
      const AppState(isLoading: true, loginError: null, loginHandle: null, fetchedNotes: null),
      const AppState(isLoading: false, loginError: null, loginHandle: LoginHandle(token: 'ABC'), fetchedNotes: null),
      const AppState(isLoading: true, loginError: null, loginHandle: LoginHandle(token: 'ABC'), fetchedNotes: null),
      const AppState(isLoading: false, loginError: null, loginHandle: LoginHandle(token: 'ABC'), fetchedNotes: mockNotes)
    ],
  );
}
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:learning_bloc/bloc/bloc_actions.dart';
import 'package:learning_bloc/bloc/person.dart';
import 'package:learning_bloc/bloc/persons_bloc.dart';

const mockedPersons1 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];

const mockedPersons2 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];

Future<Iterable<Person>> mockGetPersons1(String _)=>
  Future.value(mockedPersons1);

Future<Iterable<Person>> mockGetPersons2(String _)=>
  Future.value(mockedPersons2);

void main(){
  group('Testing bloc',(){
    late PersonsBloc bloc;
    setUp((){
      bloc = PersonsBloc();
    });

    blocTest<PersonsBloc,FetchResult?>(
      'Test intial state', 
      build: ()=>bloc,
      verify: (bloc) => expect(bloc.state, null)
      );

    blocTest<PersonsBloc,FetchResult?>(
      'Mock retrieving persons from first iterable', 
      build: ()=>bloc,
      act: (bloc){
        bloc.add(const LoadPersonsAction(
          loader: mockGetPersons1, 
          url: 'Dummy_url')
          );
        bloc.add(const LoadPersonsAction(
          loader: mockGetPersons1, 
          url: 'Dummy_url')
          );
      },
      expect: ()=>[
        const FetchResult(persons: mockedPersons1, isRetrievedFromCache: false),
        const FetchResult(persons: mockedPersons1, isRetrievedFromCache: true)
      ]
      );

    blocTest<PersonsBloc,FetchResult?>(
      'Mock retrieving persons from second iterable', 
      build: ()=>bloc,
      act: (bloc){
        bloc.add(const LoadPersonsAction(
          loader: mockGetPersons2, 
          url: 'Dummy_url')
          );
        bloc.add(const LoadPersonsAction(
          loader: mockGetPersons2, 
          url: 'Dummy_url')
          );
      },
      expect: ()=>[
        const FetchResult(persons: mockedPersons2, isRetrievedFromCache: false),
        const FetchResult(persons: mockedPersons2, isRetrievedFromCache: true)
      ]
      );
    
  });
}
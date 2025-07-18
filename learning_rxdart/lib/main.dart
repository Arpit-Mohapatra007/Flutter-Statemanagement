import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/transformers.dart';

void main() {
 runApp(
  const App()
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
      home: const HomePage(),
    );
  }
}

@immutable class Bloc{
  final Sink<String?> setFirstName;
  final Sink<String?> setLastName;
  final Stream<String> fullName;

  const Bloc._({required this.setFirstName, required this.setLastName, required this.fullName});

  void dispose(){
    setFirstName.close();
    setLastName.close();
  }

  factory Bloc(){
    final firstNameSubject = BehaviorSubject<String?>();
    final lastNameSubject = BehaviorSubject<String?>();
    final Stream<String> fullName = Rx.combineLatest2(
      firstNameSubject.startWith(null),
      lastNameSubject.startWith(null),
      (String? firstName, String? lastName){
        if(firstName != null && firstName.isNotEmpty && lastName != null && lastName.isNotEmpty){
          return '$firstName $lastName';
        }else{
          return 'Both first and last name must be provided';
        }
      }
    );
    return Bloc._(
      setFirstName: firstNameSubject.sink,
      setLastName: lastNameSubject.sink,
      fullName: fullName
    );
  }
}

typedef AsyncSnapshotBuilderCallback<T> = Widget Function(BuildContext context, T? snapshot);


class AsyncSnapshotBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final AsyncSnapshotBuilderCallback<T>? onNone;
  final AsyncSnapshotBuilderCallback<T>? onWaiting;
  final AsyncSnapshotBuilderCallback<T>? onActive;
  final AsyncSnapshotBuilderCallback<T>? onDone;


  const AsyncSnapshotBuilder({super.key, required this.stream,  this.onNone,  this.onWaiting,  this.onActive,  this.onDone});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream, builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
            final callback = onNone ?? (_,__) => const SizedBox();
            return callback(context, snapshot.data);
          case ConnectionState.waiting:
            final callback = onWaiting ?? (_,__) => const CircularProgressIndicator();
            return callback(context, snapshot.data);
          case ConnectionState.active:
            final callback = onActive ?? (_,__) => const SizedBox();
            return callback(context, snapshot.data);
          case ConnectionState.done:
            final callback = onDone ?? (_,__) => const SizedBox();
            return callback(context, snapshot.data);
        }
      }
    );
  }
}


class HomePage extends StatefulWidget {
 const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Bloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = Bloc();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: const Text('CombineLatest with RxDart'),
   ),
   body: Column(
    children: [
      TextField(
        decoration: const InputDecoration(
          hintText: 'First Name',
        ),
        onChanged: _bloc.setFirstName.add,
      ),
      TextField(
        decoration: const InputDecoration(
          hintText: 'Last Name',
        ),
        onChanged: _bloc.setLastName.add 
          ),
      AsyncSnapshotBuilder(stream: _bloc.fullName, onActive: (context, String? value) {
        return Text(value ?? '');
      },)
    ],
   )
  );
 }
}
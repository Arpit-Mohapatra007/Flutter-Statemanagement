import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
 runApp(
  const App()
 );
}

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

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

void testIt() async{
  final stream1= Stream.periodic(const Duration (seconds: 1),(count)=>'Stream 1, count =$count');
  final stream2= Stream.periodic(const Duration (seconds: 3),(count)=>'Stream 2, count =$count');
  final combined = Rx.combineLatest2(stream1,stream2,(one,two)=>'One = ($one), Two = ($two)');
  await for (final value in combined){
    value.log();
  }
}

class HomePage extends StatelessWidget {
 const HomePage({super.key});

 @override
 Widget build(BuildContext context) {
  testIt();
  return Scaffold(
   appBar: AppBar(
    title: const Text('Home Page'),
   ),
   body: const Center(
    child: Text('Hello, Flutter!'),
   ),
  );
 }
}
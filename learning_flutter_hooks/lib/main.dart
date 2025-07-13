

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension CompactMap<T> on Iterable<T> {
  Iterable<T> compactMap<E>([
    E? Function(T?)? transform
  ]) => 
  map(
    transform ?? (e) => e,
  ).where((e)=> e!=null).cast();
}

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

const url = 'https://bit.ly/4kBPrj6';


class HomePage extends HookWidget {
 const HomePage({super.key});

 @override
 Widget build(BuildContext context) {
 late final StreamController<double> controller;
 controller = useStreamController<double>(onListen: () {
   controller.sink.add(0.0);
 },);
  return Scaffold(
   appBar: AppBar(
    title:Text('Home Page'),
    ),
    body: StreamBuilder<double>(
      stream: controller.stream,
      builder: (context, snapshot){
        if(!snapshot.hasData) {return const CircularProgressIndicator();}
        else{
        final rotation = snapshot.data ?? 0.0;
        return GestureDetector(
        onTap: () {
          controller.sink.add(rotation + 10.0);
        },
        child: RotationTransition(
          turns: AlwaysStoppedAnimation(rotation/360.0),
          child: Center(
            child: Image.network(url)
            ),
        ),
      );
        }
      }
      
    ),
  );
 }
}
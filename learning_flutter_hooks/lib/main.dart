


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
  final state = useAppLifecycleState();
  return Scaffold(
   appBar: AppBar(
    title:Text('Home Page'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Opacity(
        opacity: state == AppLifecycleState.resumed ? 1 : 0.0,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              blurRadius: 10,
              color: Colors.white.withAlpha(100),
              spreadRadius: 10,
            ),]
          ),
          child: Image.asset('assets/photo.png'),
        ),
      ),
    ),
  );
 }
}

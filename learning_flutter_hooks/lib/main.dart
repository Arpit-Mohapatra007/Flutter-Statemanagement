import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
Stream<String> getTime()=>Stream.periodic(
  const Duration(seconds: 1),
  (_)=>DateTime.now().toIso8601String()
  );

class HomePage extends HookWidget {
 const HomePage({super.key});

 @override
 Widget build(BuildContext context) {
  final dateTime = useStream(getTime());
  return Scaffold(
   appBar: AppBar(
    title: Text(dateTime.data ?? 'Home Page'),
  )
  );
 }
}
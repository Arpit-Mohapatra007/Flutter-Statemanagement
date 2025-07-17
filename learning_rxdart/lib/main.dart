import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

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

class HomePage extends HookWidget {
 const HomePage({super.key});

 @override
 Widget build(BuildContext context) {
final subject = useMemoized(()=>BehaviorSubject<String>(),[key]);
useEffect(()=>subject.close, [subject]);

  return Scaffold(
   appBar: AppBar(
    title: StreamBuilder<String>(
        stream: subject.distinct().debounceTime(const Duration(seconds: 1)), 
        initialData: 'Please start typing...',
        builder: (context, snapshot) => Text(snapshot.requireData)
        ),
   ),
   body: Padding(
     padding: const EdgeInsets.all(8.0),
     child: TextField(
      onChanged: subject.sink.add,
     ),
   )
  );
 }
}
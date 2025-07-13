import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final future = useMemoized(
    () =>
    NetworkAssetBundle(
    Uri.parse(url)
    )
    .load(url)
    .then((data)=>data.buffer.asUint8List())
    .then((data)=>Image.memory(data))
  );
  final snapshot = useFuture(future);
  return Scaffold(
   appBar: AppBar(
    title:Text('Home Page')
    ),
    body: Column(
      children: <Widget>[?snapshot.data].compactMap().toList(),
    ),
  );
 }
}
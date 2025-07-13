

import 'dart:math' show max;

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
const imageHeight = 300.0;

extension Normalize on num{
  num normalized(
    num selfRangeMin,
    num selfRangeMax,[
      num normalizedRangeMin = 0.0,
      num normalizedRangeMax = 1.0,
    ])=>
     (normalizedRangeMax-normalizedRangeMin)*((this-selfRangeMin)/(selfRangeMax-selfRangeMin))+normalizedRangeMin;
}

class HomePage extends HookWidget {
 const HomePage({super.key});

 @override
 Widget build(BuildContext context) {
  final opacity = useAnimationController(
    duration: const Duration(seconds: 1),
    initialValue: 1.0,
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  final size = useAnimationController(
    duration: const Duration(seconds: 1),
    initialValue: 1.0,
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  final controller = useScrollController();
  useEffect((){
    controller.addListener((){
      final newOpacity = max(imageHeight-controller.offset, 0.0);
      final normalized = newOpacity.normalized(0.0, imageHeight).toDouble();
      opacity.value = normalized;
      size.value = normalized;
    });
    return null;
  },[controller]);

  return Scaffold(
   appBar: AppBar(
    title:Text('Home Page'),
    ),
    body: Column(
      children: [
        SizeTransition(
          sizeFactor: size,
          axis: Axis.vertical,
          axisAlignment: -1.0,
          child: FadeTransition(
            opacity: opacity,
            child: Image.network(
              url,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: controller,
            itemCount: 100,
            itemBuilder: (context, index){
            return ListTile(
              title: Text('Item ${index+1}'),
            );
          }, ),
        )
      ]
    ),
  );
 }
}
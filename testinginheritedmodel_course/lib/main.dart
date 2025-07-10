
import 'dart:math' show Random;
import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';

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

class HomePage extends StatefulWidget {
 const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  var color1 = Colors.yellow;
  var color2 = Colors.blue;

  @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: const Text('Home Page'),
   ),
   body: AvailableColorsWidget( 
    color1: color1, 
    color2: color2,
    child: Column(
      children:[
        Row(
          children: [
            TextButton(
              onPressed: (){
                setState(() {
                  color1 = colors.getRandomElement() as MaterialColor;
                  });
              }, 
              child: const Text('Change Color 1')
              ),
              TextButton(
              onPressed: (){
                setState(() {
                  color2 = colors.getRandomElement() as MaterialColor;
                  });
              }, 
              child: const Text('Change Color 2')
              )
          ],
        ),
        const ColorWidget(color: AvailableColors.one),
        const ColorWidget(color: AvailableColors.two),
       ]
      ),
    ),
  );
 }
}
enum AvailableColors {one,two}
class AvailableColorsWidget extends InheritedModel<AvailableColors> {
  final MaterialColor color1;
  final MaterialColor color2;

  const AvailableColorsWidget(
    {super.key,
     required super.child, 
     required this.color1, 
     required this.color2});

  static AvailableColorsWidget of(BuildContext context, AvailableColors aspect){
    return InheritedModel.inheritFrom<AvailableColorsWidget>(
      context,
      aspect: aspect)!;
  }
  
  @override
  bool updateShouldNotify(covariant AvailableColorsWidget oldWidget) {
    devtools.log('updateShouldNotify');
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }
  
  @override
  bool updateShouldNotifyDependent(covariant AvailableColorsWidget oldWidget, Set<AvailableColors> dependencies) {
    devtools.log('updateShouldNotifyDependent');
    if(dependencies.contains(AvailableColors.one) && color1 != oldWidget.color1){
      return true;
    }
    if(dependencies.contains(AvailableColors.two) && color2 != oldWidget.color2){
      return true;
    }
    return false;
  }
}
class ColorWidget extends StatelessWidget {
  final AvailableColors color;
  const ColorWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    switch(color){
      case AvailableColors.one:
        devtools.log('Color1 widget got rebuilt !');
        break;
      case AvailableColors.two:
        devtools.log('Color2 widget got rebuilt !');
        break;
      } 

      final provider = AvailableColorsWidget.of(context, color);
      return Container(
        height: 100,
        color: color == AvailableColors.one ? provider.color1 :provider.color2,
      );
    }
  }
final colors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
  Colors.pink,
  Colors.teal,
  Colors.cyan,
  Colors.lime,
  Colors.amber,
  Colors.brown,
  Colors.grey,
  Colors.black,
  Colors.white,
];
extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => 
  elementAt(Random().nextInt(length));
}

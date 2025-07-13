import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
  final controller = useTextEditingController();
  final text = useState('');
  useEffect((){
    controller.addListener((){
      text.value = controller.text;
    });
    return null;
  }, [controller]);
  return Scaffold(
   appBar: AppBar(
    title:Text('Home Page')
    ),
    body:Column(
        children: [
          TextField(
            controller: controller,
          ),
          Text('You typed ${text.value}'),
        ]
      ),
  );
 }
}
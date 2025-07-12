import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

String now() => DateTime.now().toIso8601String();

@immutable
class Seconds{
  final String value;
  Seconds():value=now();
}

@immutable
class Minutes{
  final String value;
  Minutes():value=now();
}

class SecondsWidget extends StatelessWidget {
  const SecondsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final seconds = context.watch<Seconds>();
    return Expanded(
      child: Container(
        color: Colors.red,
        height: 100,
        child: Center(
          child: Text(seconds.value),
        ),
      ),
    );
  }
}

class MinutesWidget extends StatelessWidget {
  const MinutesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final minutes = context.watch<Minutes>();
    return Expanded(
      child: Container(
        color: Colors.blue,
        height: 100,
        child: Center(
          child: Text(minutes.value),
        ),
      ),
    );
  }
}


class HomePage extends StatelessWidget {
 const HomePage({super.key});

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: const Text('Home Page'),
   ),
   body: MultiProvider(
    providers: [
      StreamProvider.value(
        value: Stream<Seconds>.periodic(
          const Duration(seconds: 1), (_) => Seconds()
          ),
          initialData: Seconds(),
          ),
      StreamProvider<Minutes>.value(
        value: Stream.periodic(
          const Duration(minutes: 1), (_) => Minutes()
          ),
          initialData: Minutes(),
          ),
    ],
    child: Column(
      children: [
        Row(
          children: const [
            SecondsWidget(),
            MinutesWidget(),
          ],
        )
      ],
    ),
    )
  );
 }
}
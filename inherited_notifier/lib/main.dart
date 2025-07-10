import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

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

class SliderData extends ChangeNotifier {
  double _value = 0.0;
  double get value => _value;
  set value(double newValue) {
    if (newValue != _value) {
      _value = newValue;
      notifyListeners();
    }
  }
}

class SliderInheritedNotifier extends InheritedNotifier<SliderData> {
  const SliderInheritedNotifier({
    super.key,
    required SliderData sliderData,
    required super.child,
  }) : super(notifier: sliderData);

  static SliderData of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SliderInheritedNotifier>()
          ?.notifier ??
      SliderData();
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sliderData = SliderData(); // Create the instance here
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: SliderInheritedNotifier(
        sliderData: sliderData,
        child: Builder(
          builder: (context) {
            final slider = SliderInheritedNotifier.of(context);
            return Column(
              children: [
                Slider(
                  value: slider.value,
                  onChanged: (value) {
                    slider.value = value;
                  },
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Opacity(
                      opacity: slider.value,
                      child: Container(
                        color: Colors.yellow,
                        height: 200,
                      ),
                    ),
                    Opacity(
                      opacity: slider.value,
                      child: Container(
                        color: Colors.blue,
                        height: 200,
                      ),
                    )
                  ].expandEqually().toList(),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

extension ExpandEqually on Iterable<Widget> {
  Iterable<Widget> expandEqually() => map((w) => Expanded(child: w));
}
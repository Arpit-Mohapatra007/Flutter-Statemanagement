import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
 runApp(
  ProviderScope(child: const App())
 );
}

extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    if (this == null && other == null) return null;
    return (this ?? 0 as T) + (other ?? 0 as T) as T;
  }
}

class Counter extends StateNotifier<int?> {
  Counter() : super(null);
  void increment() =>state = state == null ? 1 : state + 1;
}

final counterProvider = StateNotifierProvider<Counter, int?>(
  (ref) => Counter()
);


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



class HomePage extends ConsumerWidget {
 const HomePage({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    title: Consumer(
      builder: (context, ref, child) {
        final count = ref.watch(counterProvider);
        final text = count == null ? 'Press the button' : count.toString();
        return Text(text);
      },
    ),
   ),
   body: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextButton(
        onPressed: () => ref.read(counterProvider.notifier).increment(), 
        child: const Text('Increment Counter')
      )
    ],
   )
  );
 }
}
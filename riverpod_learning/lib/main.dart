import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
 runApp(
  ProviderScope(child: const App())
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

const names = [
  'Alice',
  'Bob',
  'Charlie',
  'David',
  'Eve',
  'Frank',
  'Grace',
  'Heidi',
  'Ivan',
  'Judy',
];

final tickerProvider = StreamProvider((ref)=>
 Stream.periodic(const Duration(seconds:1),(i)=>i+1)
,);

final namesProvider = StreamProvider((ref)=>
  // ignore: deprecated_member_use
  ref.watch(tickerProvider.stream).map((count)=>
   names.getRange(0, count)
));

class HomePage extends ConsumerWidget {
 const HomePage({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final names = ref.watch(namesProvider);
  return Scaffold(
   appBar: AppBar(
    title: const Text('Stream Provider'),
   ),
   body: names.when(
    data: (names){
      return ListView.builder(
        itemCount: names.length,
        itemBuilder: (context,index){
          return ListTile(
            title: Text(names.elementAt(index)),
          );
        }
        );
    }, 
    error: (error, stack)=> Center(child: Text('Reached the end of the list')),
    loading: ()=> const Center(child: CircularProgressIndicator()),
    ),
  );
 }
}
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
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
    return ChangeNotifierProvider(
      create: (_)=>ObjectProvider(),
      child: MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        home: const HomePage(),
      ),
    );
  }
}

@immutable
class BaseObject{
  final String id;
  final String lastUpdated;

  BaseObject(): id = const Uuid().v4(),
                lastUpdated = DateTime.now().toIso8601String();

  @override
  bool operator ==(covariant BaseObject other)=> id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}

@immutable
class ExpensiveObject extends BaseObject{}

@immutable
class CheapObject extends BaseObject{}

class ObjectProvider extends ChangeNotifier{
  late String id;
  late CheapObject _cheapObject;
  late StreamSubscription _cheapObjectStreamSubs;
  late ExpensiveObject _expensiveObject;
  late StreamSubscription _expensiveObjectStreamSubs;

  CheapObject get cheapObject => _cheapObject;
  ExpensiveObject get expensiveObject => _expensiveObject;

  ObjectProvider():id = const Uuid().v4(), 
      _cheapObject = CheapObject(), 
      _expensiveObject = ExpensiveObject(){
        start();
      }

  void start(){
    _cheapObjectStreamSubs = Stream.periodic(const Duration(seconds: 1)).listen((_){
      _cheapObject = CheapObject();
      notifyListeners();
    });
    _expensiveObjectStreamSubs = Stream.periodic(const Duration(seconds: 10)).listen((_){
      _expensiveObject = ExpensiveObject();
      notifyListeners();
    });
  }

  @override
  void notifyListeners() {
    id = const Uuid().v4();
    super.notifyListeners();
  }

  void stop(){
    _cheapObjectStreamSubs.cancel();
    _expensiveObjectStreamSubs.cancel();
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
   body: Column(
    children: [
      Row(
        children: [
          Expanded(
            child: CheapWidget(),
          ),
          Expanded(
            child: ExpensiveWidget(),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
        child: ObjectProviderWidget(),
        ),
        ]
      ),
      Row(
        children: [
          TextButton(
            onPressed: (){
              context.read<ObjectProvider>().stop();
            },
            child: const Text(
              'Stop',
            )
            ),
          TextButton(
            onPressed:(){
              context.read<ObjectProvider>().start();
            }, 
            child: const Text(
              'Start',
              )
            )
        ]
      )
    ],
   )
  );
 }
}

class ExpensiveWidget extends StatelessWidget {
  const ExpensiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final expensiveObject = context.select<ObjectProvider, ExpensiveObject>(
          (provider) => provider.expensiveObject
          );
    
    return Container(
      height: 100,
      color: Colors.blue,
      child: Column(
        children: [
          const Text(
            'Expensive Widget'
          ),
          const Text(
            'Last Updated: '
          ),
          Text(
            expensiveObject.lastUpdated
          ),
        ],
      ),
    );
  }
}

class CheapWidget extends StatelessWidget {
  const CheapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cheapObject = context.select<ObjectProvider, CheapObject>(
      (provider) => provider.cheapObject
    );
    return Container(
      height: 100,
      color: const Color.fromARGB(255, 255, 59, 59),
      child: Column(
        children: [
          const Text(
            'Cheap Widget'
          ),
          const Text(
            'Last Updated: ',
          ),
          Text(
            cheapObject.lastUpdated
          ),
        ],
      ),
    );
  }
}

class ObjectProviderWidget extends StatelessWidget {
  const ObjectProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ObjectProvider>();
    return Container(
      height: 100,
      color: Colors.purple,
      child: Column(
        children: [
          const Text(
            'Object Provider Widget'
          ),
          const Text(
            'ID: '
          ),
          Text(
            provider.id
          ),
        ],
      ),
    );
  }
}
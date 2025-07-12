import 'dart:collection';

import 'package:flutter/material.dart';
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
      create: (_)=>BreadCrumbProvider(),
      child: MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        home: const HomePage(),
        routes: {
          '/new':(context)=>const NewBreadCrumbWidget()
          },
      ),
    );
  }
}
class BreadCrumb{
  bool _isActive = false;
  final String uuid;
  final String name;
  BreadCrumb({required this.name}):uuid = const Uuid().v4();
  void activate(){
    _isActive = true;
  }
  @override
  bool operator == (covariant BreadCrumb other)=> 
    uuid == other.uuid;
  @override
  int get hashCode => uuid.hashCode;

  String get title => name + (_isActive?' > ': '');
}

class BreadCrumbProvider extends ChangeNotifier{
  final List<BreadCrumb> _items =[];
  UnmodifiableListView<BreadCrumb> get items => UnmodifiableListView(_items);

  void add(BreadCrumb breadCrumb){
    for(final item in _items){
      item.activate();
    }
    _items.add(breadCrumb);
    notifyListeners();
  }
  void reset(){
    _items.clear();
    notifyListeners();
  }
}
class BreadCrumbsWidget extends StatelessWidget {
  final UnmodifiableListView<BreadCrumb> breadCrumbs;
  const BreadCrumbsWidget({super.key, required this.breadCrumbs});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: breadCrumbs.map((breadCrumb){
        return Text(
          breadCrumb.title,
          style: TextStyle(
            color: breadCrumb._isActive ? Colors.blue : Colors.yellow,
          ),
        );
      }).toList(),
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
   body: Column(
    children: [
      Consumer<BreadCrumbProvider>(
        builder: (context, value, child){
          return BreadCrumbsWidget(breadCrumbs: value.items);
        }
        ),
      TextButton(onPressed: (){
        Navigator.of(context).pushNamed('/new');
      }, child: const Text(
        'Add new bread crumb',
        )
      ),
      TextButton(onPressed: (){
        context.read<BreadCrumbProvider>().reset();
      }, child: const Text(
        'Reset',
        )
      ),
    ],
   )
  );
 }
}

class NewBreadCrumbWidget extends StatefulWidget {
  const NewBreadCrumbWidget({super.key});

  @override
  State<NewBreadCrumbWidget> createState() => _NewBreadCrumbWidgetState();
}

class _NewBreadCrumbWidgetState extends State<NewBreadCrumbWidget> {
  late final TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Bread Crumb'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Enter a new bread crumb here..."
            ),
          ),
          TextButton(
            onPressed: (){
              final text = _controller.text;
              if(text.isNotEmpty){
                final breadCrumb = BreadCrumb( name: text);
                context.read<BreadCrumbProvider>().add(breadCrumb);
              }
              Navigator.of(context).pop();
            }, 
            child: const Text('Add')
            )
        ],
        ),
    );
  }
}
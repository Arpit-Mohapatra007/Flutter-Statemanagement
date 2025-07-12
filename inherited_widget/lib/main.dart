import 'package:flutter/material.dart';
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
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: ApiProvider(
      api: Api(),
      child: const HomePage(),
    ),
    );
  }
}

class ApiProvider extends InheritedWidget{
  final Api api;
  final String uuid;

  ApiProvider({
    Key? key, 
    required this.api, 
    required Widget child,
    }) : uuid= const Uuid().v4(),
    super(
      key: key,
      child:child
      );
      
        @override
        bool updateShouldNotify(covariant ApiProvider oldWidget) {
          return uuid != oldWidget.uuid;
        }

        static ApiProvider of(BuildContext context){
          return context.dependOnInheritedWidgetOfExactType<ApiProvider>()!;
        }
}

class HomePage extends StatefulWidget {
 const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueKey _textKey = const ValueKey<String?>(null);

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: Text(ApiProvider.of(context).api.dateAndTime ?? ''),
   ),
   body: GestureDetector(
    onTap: () async{
       final api = ApiProvider.of(context).api;
       final dateAndTime = await api.getDateAndTime();
      setState(() {
        _textKey = ValueKey(dateAndTime);
      });
    },
     child: SizedBox.expand(
       child: Container(
        color: Colors.black,
        child: DateTimeWidget(
         key: _textKey
         ),
       ),
     ),
   )
  );
 }
}

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiProvider.of(context).api;
    return Text(api.dateAndTime ?? 'Tap on Screen to fetch date and time');
  }
}

class Api{
  String? dateAndTime;

  Future<String> getDateAndTime(){
    return Future.delayed(
      const Duration(seconds:1),
      ()=>DateTime.now().toIso8601String(),
    ).then((value){
      dateAndTime = value;
      return value; 
    });
  }
}
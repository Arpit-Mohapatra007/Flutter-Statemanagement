import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/transformers.dart';

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
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

 late final BehaviorSubject<DateTime> subject;
 late final Stream<String> streamOfStrings;

 @override
  void initState() {
    super.initState();
    subject = BehaviorSubject<DateTime>();
    streamOfStrings = subject.switchMap((dateTime)=>
    Stream.periodic(const Duration(seconds: 1),
    (count)=>'Stream count = $count, dateTime = $dateTime'
    ));
  } 

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: const Text('Home Page'),
   ),
   body: Column(
    children: [
      StreamBuilder(
        stream: streamOfStrings, 
        builder: (context,snapshot){
          if(snapshot.hasData){
            final string = snapshot.requireData;
            return Text(string);
          }
          else{
            return const Text('Waiting for the button to be pressed');
          }
        }
        ),
      TextButton(
        onPressed: (){
          subject.add(DateTime.now());
          },
         child: const Text('Start the stream !'))
    ],
   )
  );
 }
}
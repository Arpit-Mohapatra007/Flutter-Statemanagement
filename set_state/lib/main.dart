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
      home: const HomePage(),
      routes: {
        '/new-contact': (context) => const NewContactView(),
      },
    );
  }
}
class Contact{
  final String id;
  final String name;

   Contact({required this.name}):id = const Uuid().v4();
}

class ContactBook extends ValueNotifier<List<Contact>>{
  ContactBook._sharedInstance(): super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  int get length => value.length;

  void add({required Contact contact}){
    final contacts = value;
    contacts.add(contact);
    notifyListeners();
  }
  void remove({required Contact contact}){
    final contacts = value;
    if(contacts.contains(contact)){
      contacts.remove(contact);
      notifyListeners();
    }
  }
  Contact? contact({required int atIndex})
    => value.length > atIndex ? value[atIndex] : null;
}
class HomePage extends StatelessWidget {
 const HomePage({super.key});

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: const Text('Home Page'),
   ),
   body: ValueListenableBuilder(
     valueListenable: ContactBook(),
     builder: (context, value, child) {
      final contacts = value;
       return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
       return Dismissible(
        onDismissed: (direction) {
          ContactBook().remove(contact: contact);
        },
        key: ValueKey(contact.id),
         child: Material(
          color: Colors.white,
          elevation: 6.0,
           child: ListTile(
            title: Text(contact.name),
           ),
         ),
       );
     },);
     },
   ),
   floatingActionButton: FloatingActionButton(
    onPressed: (){
      Navigator.of(context).pushNamed('/new-contact');
    },
    child: const Icon(Icons.add),
   ),
  );
 }
}
class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {

  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
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
        title: const Text('Add a New Contact'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter new contact name here:',
            ),
          ),
          TextButton(
            onPressed: (){
              final contact = Contact(name: _controller.text);
              ContactBook().add(contact: contact);
              Navigator.of(context).pop();
            }, 
            child: const Text('Add Contact'),
            )
        ],
      )
    );
  }
}
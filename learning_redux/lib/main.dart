// ignore_for_file: implicit_call_tearoffs

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' as hooks;
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

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

enum ItemFilter{
  all,
  longText,
  shortText,
}

@immutable
class State{
  final Iterable<String> items;
  final ItemFilter filter;

  const State({required this.items, required this.filter});

  Iterable<String> get filteredItems{
    switch(filter){
      case ItemFilter.all:
        return items;
      case ItemFilter.longText:
       return items.where((element) => element.length >= 10);
      case ItemFilter.shortText:
       return items.where((element) => element.length <= 3);
    }
  }
}

@immutable
abstract class Action{
  const Action();
}

@immutable
class ChangeFilterTypeAction extends Action{
  final ItemFilter filter;
  const ChangeFilterTypeAction(this.filter);
}

@immutable
abstract class ItemAction extends Action{
  final String item;
  const ItemAction(this.item);
}

@immutable
class AddItemAction extends ItemAction{
  const AddItemAction(super.item);
}

@immutable
class RemoveItemAction extends ItemAction{
  const RemoveItemAction(super.item);
}

extension AddRemoveItems<T> on Iterable<T>{
  Iterable<T> operator +(T other)=> followedBy([other]);
  Iterable<T> operator -(T other)=> where((element) => element != other);
}

Iterable<String> addItemReducer(
  Iterable<String> previousItems,
  AddItemAction action,
)=> previousItems + action.item;

Iterable<String> removeItemReducer(
  Iterable<String> previousItems,
  RemoveItemAction action,
)=> previousItems - action.item;

Reducer<Iterable<String>> itemReducer = 
    combineReducers<Iterable<String>>([
      TypedReducer<Iterable<String>, AddItemAction>(
        addItemReducer
      ),
      TypedReducer<Iterable<String>, RemoveItemAction>(
        removeItemReducer
      ),
    ]
    );

ItemFilter itemFilterReducer(State oldState, Action action){
  if(action is ChangeFilterTypeAction){
    return action.filter;
  }else{
    return oldState.filter;
  } 
}

State appStateReducer(State oldState,action)=>
  State(
    items: itemReducer(oldState.items, action), 
    filter: itemFilterReducer(oldState, action)
    );

class HomePage extends hooks.HookWidget {
 const HomePage({super.key});

 @override
 Widget build(BuildContext context) {
  final store = Store(
    appStateReducer, 
    initialState: const State(
      items: [], 
      filter: ItemFilter.all
        )
      );
  final textController = hooks.useTextEditingController();
  return Scaffold(
   appBar: AppBar(
    title: const Text('Home Page'),
   ),
   body: StoreProvider(
    store: store, 
    child: Column(
      children: [
        Row(
          children: [
            TextButton(
              onPressed: (){
                store.dispatch(
                  const ChangeFilterTypeAction(ItemFilter.all)
                  );
              }, 
              child: Text('All')
              ),
            TextButton(
              onPressed: (){
                store.dispatch(
                  const ChangeFilterTypeAction(ItemFilter.longText)
                  );
              }, 
              child: Text('Long Items')
              ),
            TextButton(
              onPressed: (){
                store.dispatch(
                  const ChangeFilterTypeAction(ItemFilter.shortText)
                  );
              }, 
              child: Text('Short Items')
              ),
          ],
        ),
        TextField(
          controller: textController,
        ),
        Row(
          children: [
            TextButton(
              onPressed: (){
                store.dispatch(
                  AddItemAction(textController.text)
                  );
                  textController.clear();
              }, 
              child: Text('Add Item')
              ),
            TextButton(
              onPressed: (){
                store.dispatch(
                  RemoveItemAction(textController.text)
                  );
                  textController.clear();
              }, 
              child: Text('Remove Item')
              ),
          ],
          ),
          StoreConnector<State, Iterable<String>>(
            converter: (store)=>store.state.filteredItems,
            builder: (context,items){
              return Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context,index){
                    final item = items.elementAt(index);
                    return ListTile(
                      title: Text(item),
                    );
                  }
                  ),
              );
            }, 
            )
      ],
    )
    )
  );
 }
}
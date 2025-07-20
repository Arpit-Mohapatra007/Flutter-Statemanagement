// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


void main() {
 runApp(
  ProviderScope(child: const App())
 );
}

@immutable
class Film{
  final String id;
  final String title;
  final String description;
  final bool isFavorite;

  const Film({required this.id, required this.title, required this.description, required this.isFavorite});

  Film copy({required bool isFavorite})=>
    Film(id: id, title: title, description: description, isFavorite: isFavorite);

  @override
  String toString()=> 'Film(id: $id, title: $title, description: $description, isFavorite: $isFavorite)';

  @override
  bool operator ==(covariant Film other) =>
    id == other.id &&
    isFavorite == other.isFavorite;

  @override
  int get hashCode => Object.hashAll([id, isFavorite]);
}

const allFilms = [
  Film(
    id: '1',
    title: 'The Shawshank Redemption',
    description: 'Description for The Shawshank Redemption',
    isFavorite: false,
  ),
  Film(
    id: '2',
    title: 'The Godfather',
    description: 'Description for The Godfather',
    isFavorite: false,
  ),
  Film(
    id: '3',
    title: 'The Dark Knight',
    description: 'Description for The Dark Knight',
    isFavorite: false,
  ),
  Film(
    id: '4',
    title: 'Pulp Fiction',
    description: 'Description for Pulp Fiction',
    isFavorite: false,
  ),
];

class FilmsNotifier extends StateNotifier<List<Film>>{
  FilmsNotifier():super(allFilms);

  void update(Film film,bool isFavorite){
    state = state.map((thisFilm)=>
      thisFilm.id == film.id?
      thisFilm.copy(isFavorite: isFavorite)
      :thisFilm).toList();
  }
}

enum FavoriteStatus{
  all,
  favorites,
  notFavorites,
}

final favoriteStatusProvider = StateProvider<FavoriteStatus>(
  (_)=> FavoriteStatus.all,
);

final allFilmsProvider = StateNotifierProvider<FilmsNotifier, List<Film>>(
  (_)=> FilmsNotifier(),
);

final favoriteFilmsProvider = Provider<Iterable<Film>>((ref)=>
  ref.watch(allFilmsProvider).where((film)=>film.isFavorite)
);

final notFavoriteFilmsProvider = Provider<Iterable<Film>>((ref)=>
  ref.watch(allFilmsProvider).where((film)=>!film.isFavorite)
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
    title: const Text('Films'),
   ),
   body: Column(
    children: [
      const FilterWidget(),
      Consumer(builder: (context, ref, child) {
        final filter = ref.watch(favoriteStatusProvider);
        switch(filter){
          case FavoriteStatus.all:
            return FilmsWidget(provider: allFilmsProvider);
          case FavoriteStatus.favorites:
            return FilmsWidget(provider: favoriteFilmsProvider);
          case FavoriteStatus.notFavorites:
            return FilmsWidget(provider: notFavoriteFilmsProvider);
        }
      }),

    ],
   ),
  );
 }
}

class FilmsWidget extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;

 const FilmsWidget({required this.provider, super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final films = ref.watch(provider);
  return Expanded(
    child: ListView.builder(
      itemCount: films.length,
      itemBuilder: (context, index) {
        final film = films.elementAt(index);
        final favoriteIcon = film.isFavorite
        ? const Icon(Icons.favorite)
        : const Icon(Icons.favorite_border);
        return ListTile(
          title: Text(film.title),
          subtitle: Text(film.description),
          trailing: IconButton(
            icon: favoriteIcon,
            onPressed: (){
              final isFavorite = !film.isFavorite;
              ref.read(allFilmsProvider.notifier).update(film, isFavorite);
            },
            )
          );
      }
    ) 
    );
 }
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return DropdownButton(
        value: ref.watch(favoriteStatusProvider),
        items: FavoriteStatus.values.map((status)=>
        DropdownMenuItem(
          value: status,
          child: Text(status.toString().split('.').last),
        )).toList(),
        onChanged: (FavoriteStatus? fs){
          ref.read(favoriteStatusProvider.state).state = fs!;
        },
        );
    });
  }
}
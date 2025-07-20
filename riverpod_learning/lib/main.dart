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

enum City {
  waterloo,
  stalingrad,
  berlin,
  paris,
  auschwitz,
}

typedef WeatherEmojy = String;

Future<WeatherEmojy> getWeather(City city){
  // Simulate a network call
  return Future.delayed(
    const Duration(seconds: 1),
    () =>{
      City.waterloo: '🌧️',
      City.stalingrad: '❄️',
      City.berlin: '☀️',
      City.paris: '🌤️',
      City.auschwitz: '🌪️',
    }[city]!,
  );
}

const unknownWeatherEmojy = '🤷‍♂️';

final currentCityProvider = StateProvider<City?>((ref)=>null,);
final weatherProvider = FutureProvider((ref){
  final city = ref.watch(currentCityProvider);
  if (city == null) {
    return unknownWeatherEmojy;
  }
  return getWeather(city);
});

class HomePage extends ConsumerWidget {
 const HomePage({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final currentWeather = ref.watch(weatherProvider);
  return Scaffold(
   appBar: AppBar(
    title: const Text('Weather'),
   ),
   body: Column(
    children: [
      currentWeather.when(
        data: (data) => Text(data as String, style: const TextStyle(fontSize: 40),),
        loading: () => const CircularProgressIndicator(),
        error: (_,__)=> const Text('FAT BOY 💣 DROPPED HERE!!')
      ),
      const SizedBox(height: 20),
      Expanded(
        child: ListView.builder(
          itemCount: City.values.length,
          itemBuilder: (context, index){
            final city = City.values[index];
            final isSelected = city == ref.watch(currentCityProvider);
            return ListTile(
              title: Text(city.name),
              trailing: isSelected ? const Icon(Icons.check) : null,
              onTap: (){
                ref.read(currentCityProvider.notifier).state = city;
              },
            );
          }
        )
      )
    ]
   ),
  );
 }
}
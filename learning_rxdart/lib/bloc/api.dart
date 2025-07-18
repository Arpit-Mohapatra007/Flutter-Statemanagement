import 'dart:convert';
import 'dart:io';

import 'package:learning_rxdart/models/animal.dart';
import 'package:learning_rxdart/models/person.dart';
import 'package:learning_rxdart/models/thing.dart';

typedef SearchTerm = String;

class Api {
  List<Animal>? _animals;
  List<Person>? _persons;
  Api();

  Future<List<Thing>> search(SearchTerm searchTerm) async {
    final term = searchTerm.trim().toLowerCase();

    final cachedResults = _extractThingsUsingSearchTerm(term);
    if(cachedResults != null){
      return cachedResults;
    }

    final persons = await _getJson('http://10.0.2.2:5500/apis/persons.json')
    .then((json)=>json.map((value)=>Person.fromJson(value)));
    _persons = persons.toList();

    final animals = await _getJson('http://10.0.2.2:5500/apis/animals.json')
    .then((json)=>json.map((value)=>Animal.fromJson(value)));
    _animals = animals.toList();

    return _extractThingsUsingSearchTerm(term) ?? [];
  }

  List<Thing>? _extractThingsUsingSearchTerm(SearchTerm term) {
    final cachedAnimals = _animals;
    final cachedPersons = _persons;
    if(cachedAnimals != null && cachedPersons != null){
      List<Thing> result = [];
      for(final animal in cachedAnimals){
        if(animal.name.trimmedContains(term) || animal.type.name.trimmedContains(term)){
          result.add(animal);
        }
      }
      for(final person in cachedPersons){
        if(person.name.trimmedContains(term)|| person.age.toString().trimmedContains(term)){
          result.add(person);
        }
      }
      return result;
    }else{
      return null;
    }
  }

  Future<List<dynamic>>_getJson(String url)=>
    HttpClient()
    .getUrl(Uri.parse(url))
    .then((req)=>req.close())
    .then((response)=>response.transform(utf8.decoder).join())
    .then((jsonString)=>json.decode(jsonString)as List<dynamic>);
}

extension TrimmedCaseInsensitiveContain on String{
  bool trimmedContains(String other)=>
    trim().toLowerCase().contains(other.trim().toLowerCase());
}


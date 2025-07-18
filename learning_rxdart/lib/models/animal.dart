import 'package:flutter/material.dart';
import 'package:learning_rxdart/models/thing.dart';

enum AnimalType {
  dog,cat,rabbit,unknown
}

@immutable class Animal extends Thing {
  final AnimalType type;
  const Animal({required this.type,required super.name});

  @override
  String toString()=>'Animal, name: $name, type: $type';

  factory Animal.fromJson(Map<String,dynamic> json) {
    final AnimalType animalType;
    switch((json["type"] as String).toLowerCase().trim()) {
      case "dog":
        animalType = AnimalType.dog;
        break;
      case "cat":
        animalType = AnimalType.cat;
        break;
      case "rabbit":
        animalType = AnimalType.rabbit;
        break;
      default:
        animalType = AnimalType.unknown;
    }
    return Animal(name: json["name"],type: animalType);
  }
}
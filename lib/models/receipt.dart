import 'package:flutter/material.dart';

@immutable
class Recipe {

  const Recipe({
    required this.name,
    required this.author,
    required this.likes,
    required this.dislikes,
    required this.brewMethod,
    required this.coffeeAmount,
    required this.groundSize,
    this.steps = const [],
    this.description,
    this.youtubeLink,
  });

  final String name;
  final String? description;
  final String author;
  final int likes;
  final int dislikes;
  final String brewMethod;
  final String? youtubeLink;
  final List<BrewStep> steps;
  final int coffeeAmount;
  final int groundSize;

  Recipe addStep(BrewStep step) {
    return copyWith(
      steps: [...steps, step]
    );
  }

  Recipe copyWith({
    List<BrewStep>? steps
  }) {
    return Recipe(
      name: name, 
      description: description, 
      author: author, 
      likes: likes,
      dislikes: dislikes, 
      brewMethod: brewMethod, 
      coffeeAmount: coffeeAmount,
      groundSize: groundSize,
      steps: steps ?? this.steps
    );
  }
}

class BrewStep {
  BrewStep({
    required this.start,
    required this.instructions,
    this.description,
  });
  final Duration start;
  final String instructions;
  final String? description;
}

var hoffman = const Recipe(
  name: "Ultimate Hoffmann", 
  author: "James Hoffmann", 
  coffeeAmount: 18,
  groundSize: 4,
  likes: 0, 
  dislikes: 0, 
  brewMethod: "V60", 
  steps: []
)
.addStep(BrewStep(start: const Duration(seconds: 0), instructions: "Pour 30ml for Blooming"))
.addStep(BrewStep(start: const Duration(seconds: 45), instructions: "Pour until 180ml"))
.addStep(BrewStep(start: const Duration(minutes: 1, seconds: 15), instructions: "Pour until 250ml"));

var hoffman_short = const Recipe(
  name: "Short Ultimate Hoffmann", 
  author: "James Hoffmann", 
  coffeeAmount: 18,
  groundSize: 4,
  likes: 0, 
  dislikes: 0, 
  brewMethod: "V60", 
  steps: []
)
.addStep(BrewStep(start: const Duration(seconds: 0), instructions: "Pour 30ml for Blooming"))
.addStep(BrewStep(start: const Duration(seconds: 10), instructions: "Pour until 180ml"))
.addStep(BrewStep(start: const Duration(minutes: 0, seconds: 15), instructions: "Pour until 250ml"));



import 'package:chumzy/data/models/flashcard_model.dart';
import 'package:flutter/material.dart';


class CardProvider with ChangeNotifier {
    final List<FlashCard> _flashcards = [
    FlashCard(
      definitionOnlyWithoutTheAnswer: "The process by which plants convert sunlight into energy.",
      shortTermOnlyWithoutDefinition: "Photosynthesis",
      multichoiceOptions: ["Respiration", "Photosynthesis", "Digestion", "Evaporation"],
      multichoiceAnswer: "Photosynthesis",
      trueOrFalseStatement: "Photosynthesis occurs in animal cells.",
      trueOrFalseAnswer: false,
    ),
    FlashCard(
      definitionOnlyWithoutTheAnswer: "A shape with four equal sides and four right angles.",
      shortTermOnlyWithoutDefinition: "Square",
      multichoiceOptions: ["Rectangle", "Square", "Circle", "Triangle"],
      multichoiceAnswer: "Square",
      trueOrFalseStatement: "A square has four equal sides.",
      trueOrFalseAnswer: true,
    ),
    FlashCard(
      definitionOnlyWithoutTheAnswer: "The chemical symbol for water.",
      shortTermOnlyWithoutDefinition: "H2O",
      multichoiceOptions: ["CO2", "H2O", "O2", "N2"],
      multichoiceAnswer: "H2O",
      trueOrFalseStatement: "H2O is the chemical formula for oxygen gas.",
      trueOrFalseAnswer: false,
    ),
    FlashCard(
      definitionOnlyWithoutTheAnswer: "The largest planet in our solar system.",
      shortTermOnlyWithoutDefinition: "Jupiter",
      multichoiceOptions: ["Earth", "Mars", "Jupiter", "Saturn"],
      multichoiceAnswer: "Jupiter",
      trueOrFalseStatement: "Jupiter is smaller than Earth.",
      trueOrFalseAnswer: false,
    ),
    FlashCard(
      definitionOnlyWithoutTheAnswer: "The number of continents on Earth.",
      shortTermOnlyWithoutDefinition: "Seven",
      multichoiceOptions: ["Five", "Six", "Seven", "Eight"],
      multichoiceAnswer: "Seven",
      trueOrFalseStatement: "There are seven continents on Earth.",
      trueOrFalseAnswer: true,
    ),
  ];

  List<FlashCard> get flashcards => _flashcards;

}

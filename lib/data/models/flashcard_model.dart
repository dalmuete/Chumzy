class FlashCard {
  final String? flashcardId;
  final String definitionOnlyWithoutTheAnswer;
  final String shortTermOnlyWithoutDefinition;
  final List<dynamic> multichoiceOptions;
  final String multichoiceAnswer;
  final String trueOrFalseStatement;
  final bool trueOrFalseAnswer;
  final DateTime? lastUpdatedAt;
  final String? topicId;

  FlashCard({
    this.flashcardId,
    required this.definitionOnlyWithoutTheAnswer,
    required this.shortTermOnlyWithoutDefinition,
    required this.multichoiceOptions,
    required this.multichoiceAnswer,
    required this.trueOrFalseStatement,
    required this.trueOrFalseAnswer,
    this.lastUpdatedAt,
    this.topicId,
  });

  // Factory constructor to create a Card from JSON
  factory FlashCard.fromJson(Map<String, dynamic> json) {
    return FlashCard(
      definitionOnlyWithoutTheAnswer: json['definitionOnlyWithoutTheAnswer'],
      shortTermOnlyWithoutDefinition: json['shortTermOnlyWithoutDefinition'],
      multichoiceOptions: List<String>.from(json['multichoiceOptions']),
      multichoiceAnswer: json['multichoiceAnswer'],
      trueOrFalseStatement: json['trueOrFalseStatement'],
      trueOrFalseAnswer: json['trueOrFalseAnswer'],
    );
  }
}

// ```json
// {
//   "definitionOnlyWithoutTheAnswer": "The physical parts of a computer or device.",
//   "shortTermOnlyWithoutDefinition": "Hardware",
//   "multichoiceOptions": [
//     "Software",
//     "Hardware",
//     "Algorithm",
//     "Atom"
//   ],
//   "multichoiceAnswer": "Hardware",
//   "trueOrFalseStatement": "Hardware includes the physical components of a computer, like the motherboard and monitor.",
//   "trueOrFalseAnswer": true
// }
// ```
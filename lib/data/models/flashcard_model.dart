class FlashCard {
  final String definitionOnlyWithoutTheAnswer;
  final String shortTermOnlyWithoutDefinition;
  final List<String> multichoiceOptions;
  final String multichoiceAnswer;
  final String trueOrFalseStatement;
  final bool trueOrFalseAnswer;
  final DateTime? lastUpdatedAt;

  FlashCard({
    required this.definitionOnlyWithoutTheAnswer,
    required this.shortTermOnlyWithoutDefinition,
    required this.multichoiceOptions,
    required this.multichoiceAnswer,
    required this.trueOrFalseStatement,
    required this.trueOrFalseAnswer,
     this.lastUpdatedAt,
  });
}

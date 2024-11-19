import 'package:chumzy/data/models/flashcard_model.dart';
import 'package:flutter/material.dart';

class DoneQuizScreen extends StatefulWidget {
  final List<Map<String, dynamic>> assignedItems;

  DoneQuizScreen({required this.assignedItems});

  @override
  State<DoneQuizScreen> createState() => _DoneQuizScreenState();
}

class _DoneQuizScreenState extends State<DoneQuizScreen> {
  int score = 0;

  String getCorrectAnswerForItem(FlashCard card, String type) {
    switch (type) {
      case 'Identification':
        return card.shortTermOnlyWithoutDefinition;
      case 'Multiple Choice':
        return card.multichoiceAnswer;
      case 'True or False':
        return card.trueOrFalseAnswer ? 'True' : 'False';
      default:
        return 'No answer';
    }
  }

  int calculateScore() {
    int calculatedScore = 0;
    for (var item in widget.assignedItems) {
      var card = item['card'] as FlashCard;
      var type = item['type'] as String;
      var userAnswer =
          item['userAnswer']?.toString().trim().toLowerCase() ?? '';
      var correctAnswer =
          getCorrectAnswerForItem(card, type).trim().toLowerCase();

      if (userAnswer == correctAnswer) {
        calculatedScore++;
      }
    }
    return calculatedScore;
  }

  @override
  Widget build(BuildContext context) {
    score = calculateScore();

    return Scaffold(
      appBar: AppBar(
        title: Text("DONE QUIZ"),
      ),
      body: Column(
        children: [
          Text("Your score is $score / ${widget.assignedItems.length}"),
          Expanded(
            child: ListView.builder(
              itemCount: widget.assignedItems.length,
              itemBuilder: (context, index) {
                var item = widget.assignedItems[index];
                var card = item['card'] as FlashCard;
                var type = item['type'] as String;
                var userAnswer =
                    item['userAnswer']?.toString().trim().toLowerCase() ?? '';
                var correctAnswer =
                    getCorrectAnswerForItem(card, type).trim().toLowerCase();

                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type == 'Identification'
                                ? card.definitionOnlyWithoutTheAnswer
                                : type == 'True or False'
                                    ? card.trueOrFalseStatement
                                    : card.definitionOnlyWithoutTheAnswer,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          if (type == 'Multiple Choice')
                            ...card.multichoiceOptions.map((option) {
                              return Text(
                                option,
                                style: TextStyle(
                                  color: userAnswer == option.toLowerCase()
                                      ? Colors.blue
                                      : null,
                                ),
                              );
                            }).toList(),
                          if (type == 'Identification')
                            Text("Your answer: $userAnswer"),
                          if (type == 'True or False')
                            Text(
                                "Your answer: ${userAnswer == 'true' ? 'True' : 'False'}"),
                          SizedBox(height: 8),
                          Text(
                            "Correct answer: $correctAnswer",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: userAnswer == correctAnswer
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

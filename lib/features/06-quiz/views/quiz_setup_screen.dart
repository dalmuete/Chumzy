// ignore_for_file: unnecessary_null_comparison

import 'package:chumzy/data/models/flashcard_model.dart';
import 'package:chumzy/features/06-quiz/views/quiz_screen.dart';
import 'package:flutter/services.dart';
import 'package:chumzy/core/widgets/buttons/custom_btn.dart';
import 'package:chumzy/core/widgets/textfields/custom_bordertextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class QuizSetupScreen extends StatefulWidget {
  const QuizSetupScreen({super.key});

  @override
  State<QuizSetupScreen> createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  final List<FlashCard> _cardsList = [
    FlashCard(
      shortTermOnlyWithoutDefinition: "photosynthesis",
      definitionOnlyWithoutTheAnswer:
          "The process by which plants convert sunlight into energy.",
      multichoiceOptions: [
        "evaporation",
        "gravity",
        "photosynthesis",
        "mitosis"
      ],
      multichoiceAnswer: "photosynthesis",
      trueOrFalseStatement: "Photosynthesis produces oxygen.",
      trueOrFalseAnswer: true,
      lastUpdatedAt: DateTime.now(),
    ),
    FlashCard(
      shortTermOnlyWithoutDefinition: "evaporation",
      definitionOnlyWithoutTheAnswer:
          "The process of turning liquid into vapor.",
      multichoiceOptions: [
        "photosynthesis",
        "osmosis",
        "evaporation",
        "gravity"
      ],
      multichoiceAnswer: "evaporation",
      trueOrFalseStatement: "Evaporation requires sunlight to occur.",
      trueOrFalseAnswer: true,
      lastUpdatedAt: DateTime.now(),
    ),
    FlashCard(
      shortTermOnlyWithoutDefinition: "gravity",
      definitionOnlyWithoutTheAnswer:
          "The force that attracts objects toward the center of the Earth.",
      multichoiceOptions: [
        "mitosis",
        "evaporation",
        "gravity",
        "photosynthesis"
      ],
      multichoiceAnswer: "gravity",
      trueOrFalseStatement: "Gravity only exists on Earth.",
      trueOrFalseAnswer: false,
      lastUpdatedAt: DateTime.now(),
    ),
    FlashCard(
      shortTermOnlyWithoutDefinition: "mitosis",
      definitionOnlyWithoutTheAnswer:
          "The process by which a cell divides into two identical cells.",
      multichoiceOptions: ["mitosis", "osmosis", "evaporation", "gravity"],
      multichoiceAnswer: "mitosis",
      trueOrFalseStatement: "Mitosis results in two identical daughter cells.",
      trueOrFalseAnswer: true,
      lastUpdatedAt: DateTime.now(),
    ),
    FlashCard(
      shortTermOnlyWithoutDefinition: "osmosis",
      definitionOnlyWithoutTheAnswer:
          "The movement of water molecules through a semi-permeable membrane.",
      multichoiceOptions: ["evaporation", "mitosis", "osmosis", "gravity"],
      multichoiceAnswer: "osmosis",
      trueOrFalseStatement: "Osmosis involves the movement of gases.",
      trueOrFalseAnswer: false,
      lastUpdatedAt: DateTime.now(),
    ),
  ];

  List<Map<String, dynamic>> assignedItems = [];

  List<Map<String, dynamic>> preAssignTypesToItems(
      List<FlashCard> items, List<String> selectedQuizTypes) {
    int itemsPerType = items.length ~/ selectedQuizTypes.length;
    int remainingItems = items.length % selectedQuizTypes.length;


    List<String> distributionOrder = [];
    assignedItems.clear();
    for (String type in selectedQuizTypes) {
      int count = itemsPerType + (remainingItems > 0 ? 1 : 0);
      remainingItems--;
      distributionOrder.addAll(List.filled(count, type));
    }

    distributionOrder.shuffle();

    for (int i = 0; i < items.length; i++) {
      FlashCard card = items[i];
      String type = distributionOrder[i];

      if (type == "Multiple Choice" && card.multichoiceOptions != null) {
        card.multichoiceOptions.shuffle();
      }

      assignedItems.add({
        "card": card,
        "type": type,
        "userAnswer": null,
      });
    }

    return assignedItems;
  }

  void _shuffleAndFilterCards(List<FlashCard> allFlashCards, int noOfItems) {
    List<FlashCard> filteredCards = allFlashCards.where((card) {
      return _selectedQuizTypes.contains("Identification") ||
          _selectedQuizTypes.contains("Multiple Choice") ||
          _selectedQuizTypes.contains("True or False");
    }).toList();
    if (noOfItems < 1) {
      setState(() {
        _shuffledCards = filteredCards;
      });
    } else {
      filteredCards.shuffle();
      setState(() {
        _shuffledCards = filteredCards.take(noOfItems).toList();
      });
    }
  }

  void _onStartQuiz() {
    print('Time in seconds: $_timeInSeconds');

    if (_selectedQuizTypes.isEmpty || totalItems <= 0) {
      return;
    }
    int noOfItems = int.tryParse(_itemController.text) ?? 0;
    _shuffleAndFilterCards(_cardsList, noOfItems);
    print(_shuffledCards.length);

    preAssignTypesToItems(
      _shuffledCards,
      _selectedQuizTypes,
    );
    for (var item in assignedItems) {
      var card = item['card'];
      var type = item['type'];
      var userAnswer = item['userAnswer'];

      print('Card: $card, Type: $type, User Answer: $userAnswer');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          assignedItems: assignedItems,
          timerDuration: hasTimer ? _timeInSeconds : null,
        ),
      ),
    );
  }

  final List<String> _quizTypes = [
    'Identification',
    'Multiple Choice',
    'True or False'
  ];

  List<String> _selectedQuizTypes = [];

  List<FlashCard> _shuffledCards = [];

  bool hasTimer = false;
  var _hourFnode = FocusNode();
  var _minuteFnode = FocusNode();
  var _secondFnode = FocusNode();
  var _itemFnode = FocusNode();
  TextEditingController _hourController = TextEditingController();
  TextEditingController _minuteController = TextEditingController();
  TextEditingController _secondController = TextEditingController();
  TextEditingController _itemController = TextEditingController();

  int? _timeInSeconds;

  int totalItems = 0;

  void _validateAndUpdateItemCount(String value, int totalItems) {
    int inputValue = int.tryParse(value) ?? 0;

    if (inputValue > totalItems) {
      _itemController.text = totalItems.toString();
    }
  }

  void _updateTime() {
    int hour = int.tryParse(_hourController.text) ?? 0;
    int minute = int.tryParse(_minuteController.text) ?? 0;
    int second = int.tryParse(_secondController.text) ?? 0;

    if (hour < 0 || hour > 3) {
      hour = 0;
      _hourController.text = "0";
    }

    if (minute < 0 || minute >= 60) {
      if (minute == 60) {
        hour = 1;
        _hourController.text = "1";
      }
      minute = 0;
      _minuteController.text = "0";
    }

    if (second < 0 || second >= 60) {
      if (second == 60) {
        minute = 1;
        _minuteController.text = "1";
      }
      second = 0;
      _secondController.text = "0";
    }

    if (hour == 0 && minute == 0 && second < 30) {
      second = 30;
    }

    setState(() {
      _timeInSeconds = (hour * 3600) + (minute * 60) + second + 1;
    });
  }

  @override
  void initState() {
    super.initState();
    _secondController.text = '30';
    totalItems = _cardsList.length;
    _itemController.text = totalItems.toString();
    _updateTime();
  }

  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
    _hourFnode.dispose();
    _minuteFnode.dispose();
    _secondFnode.dispose();
    _itemFnode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(right: 30.w, left: 30.w, bottom: 30.w),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Gap(68.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(10.r),
                              splashColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              onTap: () => Navigator.pop(context),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: 5.r, top: 5.r, bottom: 5.r),
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  size: 24.r,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Gap(20.w),
                            Image.asset(
                              'assets/icons/quiz_icon.png',
                              height: 22.h,
                            ),
                            Gap(10.w),
                            Flexible(
                              child: Text(
                                "Chapter 2: Science Basics",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Gap(30.h),
                        Text("Let's set up your Quiz!",
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.tertiary)),
                        Gap(50.h),
                        Text("Select one or more quiz types"),
                        Gap(15.h),
                        Column(
                          children: _quizTypes.map((type) {
                            return Padding(
                              padding: EdgeInsets.all(5.r),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ChoiceChip(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25.r,
                                          vertical: 15.r),
                                      label: Text(type),
                                      side: BorderSide(
                                          color: Colors.grey, width: 0.5),
                                      selected:
                                          _selectedQuizTypes.contains(type),
                                      onSelected: (selected) {
                                        setState(() {
                                          if (selected) {
                                            _selectedQuizTypes.add(type);
                                          } else {
                                            _selectedQuizTypes.remove(type);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        Gap(50.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("How many items would you like?"),
                                    Text(
                                      "You currently have $totalItems cards in this topic",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(20.w),
                                Expanded(
                                  child: CustomBorderTextField(
                                    hintText: totalItems.toString(),
                                    focusNode: _itemFnode,
                                    textAlign: TextAlign.center,
                                    controller: _itemController,
                                    textInputType:
                                        TextInputType.numberWithOptions(
                                            decimal: false, signed: false),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(
                                          totalItems.toString().length),
                                    ],
                                    onChanged: (value) =>
                                        _validateAndUpdateItemCount(
                                            value, totalItems),
                                  ),
                                ),
                              ],
                            ),
                            Gap(20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Do you want to set a timer?"),
                                Transform.scale(
                                  scale: (0.8).r,
                                  child: CupertinoSwitch(
                                    value: hasTimer,
                                    onChanged: (value) {
                                      setState(() {
                                        hasTimer = value;
                                        if (hasTimer &&
                                            _timeInSeconds == null) {
                                          _timeInSeconds = 30;
                                        }
                                      });
                                    },
                                    applyTheme: true,
                                    activeColor:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            Gap(10.h),
                            if (hasTimer) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Hours",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    "Minutes",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    "Seconds",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(5.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: CustomBorderTextField(
                                      textAlign: TextAlign.center,
                                      focusNode: _hourFnode,
                                      hintText: "00",
                                      controller: _hourController,
                                      textInputType:
                                          TextInputType.numberWithOptions(
                                              signed: false),
                                      onChanged: (value) {
                                        _updateTime();
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5.r),
                                    child: Text(':',
                                        style: TextStyle(fontSize: 20.sp)),
                                  ),
                                  Expanded(
                                    child: CustomBorderTextField(
                                      textAlign: TextAlign.center,
                                      focusNode: _minuteFnode,
                                      hintText: "00",
                                      controller: _minuteController,
                                      textInputType:
                                          TextInputType.numberWithOptions(
                                              signed: false),
                                      onChanged: (value) {
                                        _updateTime();
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5.r),
                                    child: Text(':',
                                        style: TextStyle(fontSize: 20.sp)),
                                  ),
                                  Expanded(
                                    child: CustomBorderTextField(
                                      textAlign: TextAlign.center,
                                      focusNode: _secondFnode,
                                      hintText: "30",
                                      controller: _secondController,
                                      textInputType:
                                          TextInputType.numberWithOptions(
                                              signed: false),
                                      onChanged: (value) {
                                        _updateTime();
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            Gap(60.h),
                            if (!hasTimer) Gap(86.h),
                            CustomButton(
                              text: "Start quiz",
                              onPressed: _onStartQuiz,
                              textColor: _selectedQuizTypes.isEmpty
                                  ? Colors.grey.withOpacity(0.7)
                                  : Colors.black,
                              backgroundColor: _selectedQuizTypes.isEmpty
                                  ? Colors.grey.withOpacity(0.5)
                                  : Theme.of(context).colorScheme.secondary,
                              padding: 15.r,
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

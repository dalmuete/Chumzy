import 'package:chumzy/core/widgets/buttons/custom_btn.dart';
import 'package:chumzy/data/models/flashcard_model.dart';
import 'package:chumzy/features/05-flashcards/views/done_flashcards_screen.dart';
import 'package:chumzy/features/05-flashcards/widgets/build_card_content.dart';
import 'package:chumzy/features/05-flashcards/widgets/explain_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/percent_indicator.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  final FlipCardController flashcardController = FlipCardController();
  int currentIndex = 0;
  bool isBack = false;
  bool isTermFront = false;
  String frontContent = "Definition";

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

  void handleCardFlip() {
    flashcardController.flipcard();
    setState(() {
      isBack = true;
    });
  }

  void toggleFrontContent() {
    if (frontContent == "Definition") {
      setState(() {
        frontContent = "Term";
      });
    } else {
      setState(() {
        frontContent = "Definition";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(right: 30.w, left: 30.w, bottom: 30.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Gap(68.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(10.r),
                        splashColor:
                            Theme.of(context).primaryColor.withOpacity(0.2),
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
                        'assets/icons/flashcard_icon.png',
                        height: 25.h,
                      ),
                      Gap(10.w),
                      Flexible(
                        child: Text(
                          "Chapter 2: Science Basics",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Gap(20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: LinearPercentIndicator(
                          animation: true,
                          animationDuration: 300,
                          animateFromLastPercent: true,
                          barRadius: Radius.circular(20.r),
                          lineHeight: 10.h,
                          percent: (currentIndex + 1) / _cardsList.length,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.4),
                          progressColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        "${(currentIndex + 1)} / ${_cardsList.length}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Gap(50.h),
                  GestureDetector(
                    onTap: () {
                      handleCardFlip();
                    },
                    child: FlipCard(
                        key: ValueKey(currentIndex),
                        animationDuration: const Duration(milliseconds: 500),
                        rotateSide: RotateSide.bottom,
                        onTapFlipping: false,
                        axis: FlipAxis.horizontal,
                        controller: flashcardController,
                        frontWidget: frontContent == "Definition"
                            ? BuildCardContent(
                                content: _cardsList[currentIndex]
                                    .definitionOnlyWithoutTheAnswer,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                borderColor: Colors.grey,
                                shadowColor: Colors.grey,
                                borderWidth: 1)
                            : BuildCardContent(
                                content: _cardsList[currentIndex]
                                    .shortTermOnlyWithoutDefinition,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                borderColor: Colors.grey,
                                shadowColor: Colors.grey,
                                borderWidth: 1),
                        backWidget: frontContent == "Definition"
                            ? BuildCardContent(
                                content: _cardsList[currentIndex]
                                    .shortTermOnlyWithoutDefinition,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                borderColor:
                                    Theme.of(context).colorScheme.secondary,
                                shadowColor:
                                    Theme.of(context).colorScheme.secondary,
                                borderWidth: 2)
                            : BuildCardContent(
                                content: _cardsList[currentIndex]
                                    .definitionOnlyWithoutTheAnswer,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                borderColor:
                                    Theme.of(context).colorScheme.secondary,
                                shadowColor:
                                    Theme.of(context).colorScheme.secondary,
                                borderWidth: 2)),
                  ),
                  Gap(20.h),
                  Text(
                    "Tap the card to flip",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Gap(50.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: currentIndex > 0
                              ? () {
                                  setState(() {
                                    currentIndex--;
                                    isBack = false;
                                  });
                                }
                              : null,
                          icon: CircleAvatar(
                            backgroundColor: currentIndex > 0
                                ? Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1)
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.05),
                            radius: 35.r,
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: currentIndex > 0
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5)
                                  : Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.15),
                            ),
                          ),
                        ),
                        if (isBack)
                          CustomButton(
                              text: 'Explain',
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              prefixIcon: Image.asset(
                                'assets/icons/chatbot_tertiary_icon.png',
                                width: 24.w,
                              ),
                              fontweight: FontWeight.w600,
                              padding: 18.r,
                              borderColor:
                                  Theme.of(context).colorScheme.tertiary,
                              textColor: Theme.of(context).colorScheme.tertiary,
                              onPressed: () {
                                explainModal(
                                  context: context,
                                  setState: setState,
                                );
                              }),
                        IconButton(
                          onPressed: currentIndex < _cardsList.length - 1
                              ? () {
                                  setState(() {
                                    currentIndex++;
                                    isBack = false;
                                  });
                                }
                              : () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          DoneFlashcardsScreen()));
                                },
                          icon: CircleAvatar(
                            backgroundColor:
                                currentIndex < _cardsList.length - 1
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1)
                                    : Theme.of(context).colorScheme.secondary,
                            radius: 35.r,
                            child: Icon(Icons.arrow_forward_ios_rounded,
                                color: currentIndex < _cardsList.length - 1
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5)
                                    : Color(0xFF1c1c1e)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Front: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Gap(5.w),
                  InkWell(
                    onTap: () {
                      toggleFrontContent();
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                        width: 80.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 7.w),
                                child: Text(
                                  frontContent,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7.w),
                              child: Image.asset(
                                'assets/icons/arrows_up_down_icon.png',
                                width: 7.w,
                              ),
                            )
                          ],
                        ))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

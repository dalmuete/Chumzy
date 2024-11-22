// ignore_for_file: avoid_print

import 'package:chumzy/data/models/subject_model.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:chumzy/data/providers/subject_provider.dart';
import 'package:chumzy/features/02-home/widgets/quote_widget.dart';
import 'package:chumzy/features/02-home/widgets/recent-topic_card.dart';
import 'package:chumzy/features/03-subjects/views/subjects_screen.dart';
import 'package:chumzy/features/04-topics/views/topic_view_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final subjectProvider =
        Provider.of<SubjectProvider>(context, listen: false);
    subjectProvider.fetchSubjects();
    List<Subject> subjectListt = subjectProvider.subjects;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/chumzy_character/chumzy_logo_text.png',
              width: MediaQuery.of(context).size.width * 0.4,
            )
          ],
        ),
        Gap(20.h),
        QuoteOfTheDayWidget(
          quote:
              "Education is the most powerful weapon which you can use to change the world.",
          author: "Nelson Mandela",
        ),
        Gap(50.h),
        Text("Recent",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600)),
        Gap(20.h),
        Expanded(
          child: subjectListt.isNotEmpty
              ? ListView.builder(
                  itemCount: subjectListt.length,
                  itemBuilder: (BuildContext context, int i) {
                    final topic = subjectListt[i];
                    return RecentTopicCard(
                      selectedSubject: subjectListt[i],
                      lineColor: subjectListt[i].lineColor,
                      title: topic.title,
                      totalNoItems: topic.totalNoItems,
                      lastUpdated: topic.lastUpdated,
                      isSubject: false,
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => SubjectsScreen(),
                        ));
                      },
                    );
                  },
                )
              : const Center(child: Text("No recents at the moment.")),
        ),
      ],
    );
  }
}

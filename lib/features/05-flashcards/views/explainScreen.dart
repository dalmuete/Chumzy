import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:chumzy/core/widgets/textfields/custom_bordertextfield.dart';
import 'package:chumzy/data/providers/flashcard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class Explainscreen extends StatefulWidget {
  String term;
  String definition;
  Explainscreen({super.key, required this.term, required this.definition});

  @override
  State<Explainscreen> createState() => _ExplainscreenState();
}

String response = "";

// late CardProvider cardsProvider;
// @override
// void initState() async {
//   super.initState();
//   response = await  cardsProvider
//         .explainFurther(context, widget.term, widget.definition)
// }
class _ExplainscreenState extends State<Explainscreen> {
  @override
  Widget build(BuildContext context) {
    var cardsProvider = Provider.of<CardProvider>(context, listen: false);
    cardsProvider
        .explainFurther(context, widget.term, widget.definition)
        .then((returnedString) {
      setState(() {
        response = returnedString;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Chumzy AI - Explain"),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5),
                      backgroundImage:
                          AssetImage('assets/chumzy_character/chumzy_icon.png'),
                      radius: 20.r,
                    ),
                    Gap(10.w),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Flexible(child: Text(response)),
                    ),
                  ],
                ),
              ),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SubjectController extends ChangeNotifier {
  List<TextEditingController> controllers = [TextEditingController()];
  List<FocusNode> focusNodes = [FocusNode()];
  List<Color> subjectColors = [Colors.white];
  static const int maxFields = 5;

  void addTextField(Function setState) {
    if (controllers.length < maxFields) {
      setState(() {
        controllers.add(TextEditingController());
        focusNodes.add(FocusNode());
        subjectColors.add(Colors.white);
      });
    }
  }

  void removeTextField(int index, Function setState) {
    if (controllers.length > 1) {
      setState(() {
        controllers.removeAt(index);
        focusNodes.removeAt(index);
        subjectColors.removeAt(index);
      });
    }
  }

  void resetAllTextFields(Function setState) {
    setState(() {
      for (var controller in controllers) {
        controller.clear();
      }
      for (var controller in controllers) {
        controller.dispose();
      }
      for (var focusNode in focusNodes) {
        focusNode.dispose();
      }

      controllers.clear();
      focusNodes.clear();
      subjectColors.clear();

      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
      subjectColors.add(Colors.white);

      debugPrint("CLEAR FORM and ADD 1 TEXTFIELD");
    });
  }

  void disposeControllers() {
    for (var controller in controllers) {
      controller.dispose();
    }
    debugPrint("Disposing TextEditingController in DISPOSE");

    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    debugPrint("Disposing FocusNode in DISPOSE");
  }
}

import 'package:flutter/material.dart';

class TopicController {
  List<TextEditingController> controllers = [TextEditingController()];
  List<FocusNode> focusNodes = [FocusNode()];
  static const int maxFields = 5;

  // void addTextField(Function setState) {
  //   if (controllers.length < maxFields) {
  //     setState(() {
  //       controllers.add(TextEditingController());
  //       focusNodes.add(FocusNode());
  //     });
  //   }
  // }

  void addTextField(Function setState) {
    if (controllers.length < maxFields) {
      setState(() {
        controllers.add(TextEditingController());
        focusNodes.add(FocusNode());
      });
    }
  }

  // void removeTextField(int index, Function setState) {
  //   if (controllers.length > 1) {
  //     setState(() {
  //       controllers.removeAt(index);
  //       focusNodes.removeAt(index);
  //     });
  //   }
  // }

  void removeTextField(int index, Function setState) {
    if (controllers.length > 1) {
      setState(() {
        focusNodes[index].dispose();
        controllers[index].dispose();
        controllers.removeAt(index);
        focusNodes.removeAt(index);
      });
    }
  }

  // void resetAllTextFields(Function setState) {
  //   setState(() {
  //     for (var controller in controllers) {
  //       controller.clear();
  //     }
  //     for (var controller in controllers) {
  //       controller.dispose();
  //     }
  //     for (var focusNode in focusNodes) {
  //       focusNode.dispose();
  //     }

  //     controllers.clear();
  //     focusNodes.clear();

  //     controllers.add(TextEditingController());
  //     focusNodes.add(FocusNode());
  //   });
  // }

  void resetAllTextFields(Function setState) {
    setState(() {
      for (var controller in controllers) {
        controller.dispose();
      }
      for (var focusNode in focusNodes) {
        focusNode.dispose();
      }

      controllers.clear();
      focusNodes.clear();

      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    });
  }

  // void disposeControllers() {
  //   for (var controller in controllers) {
  //     controller.dispose();
  //   }
  //   for (var focusNode in focusNodes) {
  //     focusNode.dispose();
  //   }
  // }

  void disposeControllers() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
  }
}

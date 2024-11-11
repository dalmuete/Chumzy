class SubjectsTopicsController {
  bool isAscending = false;
  bool isSortByAlpha = false;

  void onDescending() {
    print("Descending function called");
  }

  void onAscending() {
    print("Ascending function called");
  }

  void toggleArrow() {
    isAscending = !isAscending;
    if (isAscending) {
      onAscending();
    } else {
      onDescending();
    }
  }

  void sortByAlpha() {
    print("sortByAlpha function called");
  }

  void sortByDate() {
    print("sortByDate function called");
  }

  void toggleSort() {
    isSortByAlpha = !isSortByAlpha;
    if (isSortByAlpha) {
      sortByAlpha();
    } else {
      sortByDate();
    }
  }
}

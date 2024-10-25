mixin CommonMixin {
  String masknumbers(String number) {
    String maskedData = '';
    for (var i = 0; i < number.length; i++) {
      if (i == 2 || i == 3 || i == 4 || i == 5 || i == 6 || i == 7) {
        maskedData += "*";
      } else {
        maskedData += number[i];
      }
    }
    return maskedData;
  }
}

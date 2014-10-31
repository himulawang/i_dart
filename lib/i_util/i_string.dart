class IString {
  static String makeUpperFirstLetter(String word) {
    if (word.length <= 1) return word.toUpperCase();
    return word[0].toUpperCase() + word.substring(1);
  }
}
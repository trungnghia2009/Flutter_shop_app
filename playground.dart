void main() {
  List<String> listA = ['nghia', 'ngoc', 'ngoan', 'chinh'];

  List getResult(String key) {
    List temp = [];
    for (var i = 0; i < listA.length; i++) {
      if (listA[i].contains(key)) {
        temp.add(listA[i]);
      }
    }
    return temp;
  }

  String S = 'ABCABCABC';

  List countString(String text) {
    List result = [];

    // Compare
    for (var i = 0; i < text.length - 2; i++) {
      int count = 0;
      String tempString = text[i] + text[i + 1] + text[i + 2];
      print(tempString);
      for (var j = 0; j < text.length - 2; j++) {
        String tempString2 = text[j] + text[j + 1] + text[j + 2];
        print(tempString2);
        if (tempString == tempString2) {
          count += 1;
        }
      }
      print('-----------');
      result.add('$tempString: $count');
    }

    // Remove duplication
    var distinctIds = Set.of(result).toList();
    return distinctIds;
  }

  void printStar(int n) {
    for (var i = 1; i <= n; i++) {
      print('*' * i);
    }
  }

  print(countString(S));
}

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

  print(getResult('ngoc'));
}

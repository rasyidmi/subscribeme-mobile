final List<String> _alphabet = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J'
];

extension IntegerExtension on int {
  String getAlphabet() {
    return _alphabet[this];
  }
}

extension NullableIntegerExtension on int? {
  bool get isNotNull {
    return this != null;
  }
}

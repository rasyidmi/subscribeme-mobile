// Code from https://parthsamnani.medium.com/format-string-to-title-case-using-dart-extensions-7c96bd97b78f
List<String> exceptions = ['dan'];
extension StringExtension on String {
  String get toTitleCase {
    return toLowerCase().replaceAllMapped(RegExp(r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
        (Match match) {
      if (exceptions.contains(match[0])) {
        return match[0]!;
      }
      return "${match[0]![0].toUpperCase()}${match[0]!.substring(1).toLowerCase()}";
    }).replaceAll(RegExp(r'(_|-)+'), ' ');
  }
}

extension NullableStringExtension on String? {
  bool get isNull {
    return this == null;
  }
}

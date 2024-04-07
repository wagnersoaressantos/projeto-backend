// ignore_for_file: type_literal_in_constant_pattern

extension ParserExtension on String {
  toType(Type type) {
    switch (type) {
      case String:
        return toString();
      case int:
        return int.parse(toString());
      default:
        return toString();
    }
  }
}

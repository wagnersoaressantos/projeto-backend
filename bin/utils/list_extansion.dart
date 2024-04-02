extension ListExtension<E> on List<E> {
  E? firstWhereOnNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension StringExtensions on String {
  String get titleCase {
    if (this.isEmpty) return this;
    return this.split(' ').map((word) {
      return word.length > 1
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : word.toUpperCase();
    }).join(' ');
  }

  String get capitalize {
    if (this.isEmpty) return this;
    return this.split(' ').map((word) {
      return word.length > 1
          ? word[0].toUpperCase() + word.substring(1).toUpperCase()
          : word.toUpperCase();
    }).join(' ');
  }
}

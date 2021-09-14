enum MyConfig {
  URL,
}

extension MyConfigExtension on MyConfig {
  String get name {
    return [
      'http://localhost/',
    ][this.index];
  }
}

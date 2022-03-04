enum MyConfig {
  URL,
  PROJ,
}

extension MyConfigExtension on MyConfig {
  String get name {
    return [
      '192.168.50.238',
      'smilesmart',
    ][this.index];
  }
}

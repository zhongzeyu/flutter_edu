enum MyConfig {
  URL,
  PROJ,
}

extension MyConfigExtension on MyConfig {
  String get name {
    return [
      '192.168.50.239',
      'smilesmart',
    ][this.index];
  }
}

enum MyConfig {
  URL,
  PROJ,
  DOWNLOAD,
}

extension MyConfigExtension on MyConfig {
  String get name {
    return [
      '192.168.50.239',
      'smilesmart',
      'download',
    ][this.index];
  }
}

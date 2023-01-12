enum MyConfig {
  URL,
  URLAddress,
  PROJ,
  DOWNLOAD,
  UPLOAD,
}

extension MyConfigExtension on MyConfig {
  dynamic get name {
    return [
      '192.168.50.238',
      'https://ws1.postescanada-canadapost.ca/AddressComplete/Interactive/Find/v2.10/json3ex.ws?Key=HG78-NR98-GK34-JA39&',
      'smilesmart',
      'download',
      'upload',
    ][this.index];
  }
}

enum MyConfig {
  TABLEID,
  FORMID,
  EMAIL,
  SINGLEINT,
  PASSWORD,
  DATE,
  DATEFORMAT,
  TEXT,
  URL
}

extension MyConfigExtension on MyConfig {
  String get name {
    return [
      'id',
      'formid',
      'email',
      'singleint',
      'password',
      'date',
      'yyyy-MM-dd',
      'text',
      'http://localhost/'
    ][this.index];
  }
}

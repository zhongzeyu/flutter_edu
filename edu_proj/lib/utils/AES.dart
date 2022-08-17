import 'package:encrypt/encrypt.dart';

class AESUtil {
  static final dynamic _defaultKey =
      '5f1354c7268451d0dcc5f21da45a96ca063e2dc5bd691768edd15603372f990e';

  static dynamic getAESKey(dynamic key) {
    if (key == null || key.length < 16) {
      key = _defaultKey;
    }
    return key.substring(0, 16);
  }

  static dynamic encrypting(source, keyOriginal) {
    final key = Key.fromUtf8(getAESKey(keyOriginal));
    AES aes = AES(key, mode: AESMode.ecb);
    final encrypter = Encrypter(aes);

    dynamic encrypted = encrypter.encrypt(source, iv: IV.fromLength(0)).base64;
    return encrypted;
  }

  static dynamic decrypting(source, keyOriginal) {
    final key = Key.fromUtf8(getAESKey(keyOriginal));
    AES aes = AES(key, mode: AESMode.ecb);
    final encrypter = Encrypter(aes);

    dynamic decrypted = encrypter.decrypt64(source, iv: IV.fromLength(0));
    return decrypted;
  }
}

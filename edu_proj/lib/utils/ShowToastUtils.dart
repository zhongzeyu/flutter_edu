import 'package:fluttertoast/fluttertoast.dart';

class ShowToast {
  static warning(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5);
  }
}

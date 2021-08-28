// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(name) => "Please enter an valid ${name}";

  static m1(name) => "${name} is required";

  static m2(number, unit) => "Please enter less than ${number} ${unit}";

  static m3(number, unit) => "Please enter at least ${number} ${unit}";

  static m4(responseCode, responsebody) => "Failed, Http response code is not right, [${responseCode}], [${responsebody}]";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "addnew" : MessageLookupByLibrary.simpleMessage("Add New"),
    "backbtn" : MessageLookupByLibrary.simpleMessage("  <- "),
    "changepassword" : MessageLookupByLibrary.simpleMessage("Change Password"),
    "character" : MessageLookupByLibrary.simpleMessage("characters"),
    "checkverifycode" : MessageLookupByLibrary.simpleMessage("Please check email for verify code"),
    "createAccount" : MessageLookupByLibrary.simpleMessage("Create Account"),
    "createnewpassword" : MessageLookupByLibrary.simpleMessage("Create new password"),
    "delete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "employee" : MessageLookupByLibrary.simpleMessage("Employee"),
    "eteremailtoresetpassword" : MessageLookupByLibrary.simpleMessage("Entere your email address and we\'ll send you an email with code to reset your password. "),
    "forgetpassword" : MessageLookupByLibrary.simpleMessage("Forget password?"),
    "home" : MessageLookupByLibrary.simpleMessage("Home"),
    "invalidname" : m0,
    "isrequired" : m1,
    "login" : MessageLookupByLibrary.simpleMessage("Login"),
    "maxinput" : m2,
    "mininput" : m3,
    "password" : MessageLookupByLibrary.simpleMessage("Password"),
    "plsenteremail" : MessageLookupByLibrary.simpleMessage("Please enter email address"),
    "program" : MessageLookupByLibrary.simpleMessage("Program"),
    "resetpassword" : MessageLookupByLibrary.simpleMessage("Reset password"),
    "role" : MessageLookupByLibrary.simpleMessage("Role"),
    "serverdown" : MessageLookupByLibrary.simpleMessage("Failed! server is not response, please retry after a while"),
    "serverwrongcode" : m4,
    "student" : MessageLookupByLibrary.simpleMessage("Student"),
    "submit" : MessageLookupByLibrary.simpleMessage("Submit"),
    "system" : MessageLookupByLibrary.simpleMessage("System"),
    "systemtitle" : MessageLookupByLibrary.simpleMessage("Smile Smart"),
    "tablerole" : MessageLookupByLibrary.simpleMessage("Table Role"),
    "tutor" : MessageLookupByLibrary.simpleMessage("Tutor"),
    "updatepassword" : MessageLookupByLibrary.simpleMessage("Update password"),
    "verifycode" : MessageLookupByLibrary.simpleMessage("Verify Code"),
    "welcome" : MessageLookupByLibrary.simpleMessage("Welcome")
  };
}

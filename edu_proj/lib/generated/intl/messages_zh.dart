// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static m0(name) => "请输入合法的${name}";

  static m1(name) => "${name}必填";

  static m2(number, unit) => "请输入少于${number}个${unit}";

  static m3(number, unit) => "请输入至少${number}个${unit}";

  static m4(responseCode, responsebody) => "失败！ 服务器返回错误信息, [${responseCode}], [${responsebody}]";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "backbtn" : MessageLookupByLibrary.simpleMessage("  <- "),
    "changepassword" : MessageLookupByLibrary.simpleMessage("修改密码"),
    "character" : MessageLookupByLibrary.simpleMessage("字节"),
    "checkverifycode" : MessageLookupByLibrary.simpleMessage("请查收邮件找到验证码"),
    "createAccount" : MessageLookupByLibrary.simpleMessage("创建帐号"),
    "createnewpassword" : MessageLookupByLibrary.simpleMessage("创建新密码"),
    "email" : MessageLookupByLibrary.simpleMessage("电子邮件"),
    "employee" : MessageLookupByLibrary.simpleMessage("员工"),
    "eteremailtoresetpassword" : MessageLookupByLibrary.simpleMessage("输入邮箱，我们会给您邮件中发验证码，以便重置密码"),
    "forgetpassword" : MessageLookupByLibrary.simpleMessage("忘记密码?"),
    "home" : MessageLookupByLibrary.simpleMessage("主页"),
    "invalidname" : m0,
    "isrequired" : m1,
    "login" : MessageLookupByLibrary.simpleMessage("登录"),
    "maxinput" : m2,
    "mininput" : m3,
    "password" : MessageLookupByLibrary.simpleMessage("密码"),
    "plsenteremail" : MessageLookupByLibrary.simpleMessage("请输入邮箱地址"),
    "program" : MessageLookupByLibrary.simpleMessage("学科"),
    "resetpassword" : MessageLookupByLibrary.simpleMessage("重置密码"),
    "role" : MessageLookupByLibrary.simpleMessage("角色"),
    "serverdown" : MessageLookupByLibrary.simpleMessage("失败！ 服务器未响应，请稍候再试"),
    "serverwrongcode" : m4,
    "student" : MessageLookupByLibrary.simpleMessage("学生"),
    "submit" : MessageLookupByLibrary.simpleMessage("提交"),
    "system" : MessageLookupByLibrary.simpleMessage("系统"),
    "systemtitle" : MessageLookupByLibrary.simpleMessage("睿智的笑"),
    "tablerole" : MessageLookupByLibrary.simpleMessage("表角色"),
    "tutor" : MessageLookupByLibrary.simpleMessage("老师"),
    "updatepassword" : MessageLookupByLibrary.simpleMessage("修改密码"),
    "verifycode" : MessageLookupByLibrary.simpleMessage("验证码"),
    "welcome" : MessageLookupByLibrary.simpleMessage("欢迎")
  };
}

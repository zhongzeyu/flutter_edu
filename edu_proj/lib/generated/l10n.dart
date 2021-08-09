// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `  <- `
  String get backbtn {
    return Intl.message(
      '  <- ',
      name: 'backbtn',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changepassword {
    return Intl.message(
      'Change Password',
      name: 'changepassword',
      desc: '',
      args: [],
    );
  }

  /// `characters`
  String get character {
    return Intl.message(
      'characters',
      name: 'character',
      desc: '',
      args: [],
    );
  }

  /// `Please check email for verify code`
  String get checkverifycode {
    return Intl.message(
      'Please check email for verify code',
      name: 'checkverifycode',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create new password`
  String get createnewpassword {
    return Intl.message(
      'Create new password',
      name: 'createnewpassword',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Employee`
  String get employee {
    return Intl.message(
      'Employee',
      name: 'employee',
      desc: '',
      args: [],
    );
  }

  /// `Entere your email address and we'll send you an email with code to reset your password. `
  String get eteremailtoresetpassword {
    return Intl.message(
      'Entere your email address and we\'ll send you an email with code to reset your password. ',
      name: 'eteremailtoresetpassword',
      desc: '',
      args: [],
    );
  }

  /// `Forget password?`
  String get forgetpassword {
    return Intl.message(
      'Forget password?',
      name: 'forgetpassword',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an valid {name}`
  String invalidname(Object name) {
    return Intl.message(
      'Please enter an valid $name',
      name: 'invalidname',
      desc: '',
      args: [name],
    );
  }

  /// `{name} is required`
  String isrequired(Object name) {
    return Intl.message(
      '$name is required',
      name: 'isrequired',
      desc: '',
      args: [name],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Please enter at least {number} {unit}`
  String mininput(Object number, Object unit) {
    return Intl.message(
      'Please enter at least $number $unit',
      name: 'mininput',
      desc: '',
      args: [number, unit],
    );
  }

  /// `Please enter less than {number} {unit}`
  String maxinput(Object number, Object unit) {
    return Intl.message(
      'Please enter less than $number $unit',
      name: 'maxinput',
      desc: '',
      args: [number, unit],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter email address`
  String get plsenteremail {
    return Intl.message(
      'Please enter email address',
      name: 'plsenteremail',
      desc: '',
      args: [],
    );
  }

  /// `Program`
  String get program {
    return Intl.message(
      'Program',
      name: 'program',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get resetpassword {
    return Intl.message(
      'Reset password',
      name: 'resetpassword',
      desc: '',
      args: [],
    );
  }

  /// `Role`
  String get role {
    return Intl.message(
      'Role',
      name: 'role',
      desc: '',
      args: [],
    );
  }

  /// `Failed! server is not response, please retry after a while`
  String get serverdown {
    return Intl.message(
      'Failed! server is not response, please retry after a while',
      name: 'serverdown',
      desc: '',
      args: [],
    );
  }

  /// `Failed, Http response code is not right, [{responseCode}], [{responsebody}]`
  String serverwrongcode(Object responseCode, Object responsebody) {
    return Intl.message(
      'Failed, Http response code is not right, [$responseCode], [$responsebody]',
      name: 'serverwrongcode',
      desc: '',
      args: [responseCode, responsebody],
    );
  }

  /// `Student`
  String get student {
    return Intl.message(
      'Student',
      name: 'student',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get system {
    return Intl.message(
      'System',
      name: 'system',
      desc: '',
      args: [],
    );
  }

  /// `Smile Smart`
  String get systemtitle {
    return Intl.message(
      'Smile Smart',
      name: 'systemtitle',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Table Role`
  String get tablerole {
    return Intl.message(
      'Table Role',
      name: 'tablerole',
      desc: '',
      args: [],
    );
  }

  /// `Tutor`
  String get tutor {
    return Intl.message(
      'Tutor',
      name: 'tutor',
      desc: '',
      args: [],
    );
  }

  /// `Update password`
  String get updatepassword {
    return Intl.message(
      'Update password',
      name: 'updatepassword',
      desc: '',
      args: [],
    );
  }

  /// `Verify Code`
  String get verifycode {
    return Intl.message(
      'Verify Code',
      name: 'verifycode',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}
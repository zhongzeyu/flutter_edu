import 'package:edu_proj/common/theme.dart';
//import 'package:edu_proj/generated/l10n.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<DataModel>(
      create: (context) => DataModel(),
    ),
  ], child: MyApp()));
}

/*class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  static _AppSetting setting = _AppSetting();

  @override
  void initState() {
    super.initState();
    setting.changeLocale = (Locale locale) {
      setState(() {
        setting._locale = locale;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) {
        return AppLocalizations.of(context).title;
      },
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        var result = supportedLocales
            .where((element) => element.languageCode == locale.languageCode);
        if (result.isNotEmpty) {
          return locale;
        }
        return Locale('zh');
      },
      locale: setting._locale,
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh'),
        const Locale('en'),
      ],
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  @override
  __HomePageState createState() => __HomePageState();
}

class __HomePageState extends State<_HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${AppLocalizations.of(context).title}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('中文'),
                onPressed: () {
                  MyAppState.setting.changeLocale(Locale('zh'));
                },
              ),
              ElevatedButton(
                child: Text('英文'),
                onPressed: () {
                  MyAppState.setting.changeLocale(Locale('en'));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppSetting {
  _AppSetting();

  Null Function(Locale locale) changeLocale;
  Locale _locale;
}*/

/*class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Hello World',
    },
    'zh': {
      'title': '你好',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }
}*/
class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

/*class _AppSetting {
  _AppSetting();

  Null Function(Locale locale) changeLocale;
  Locale _locale;
}*/

class MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  /*static _AppSetting setting = _AppSetting();
  @override
  void initState() {
    super.initState();
    setting.changeLocale = (Locale locale) {
      setState(() {
        setting._locale = locale;
      });
    };
  }*/

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '',
        theme: appTheme,
        home: MyHomePage(title: ''),
        /*localizationsDelegates: [
          S.delegate,
          //AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // 将 en设置为第一项, 没有适配语言时, 英语为首选项
        supportedLocales: [
          const Locale('en', ''),
          const Locale('zh'),
          ...S.delegate.supportedLocales
        ],
        locale: datamodel.locale,
        // 插件目前不完善手动处理简繁体
        localeResolutionCallback: (locale, supportLocales) {
          if (locale != null) {
            if (locale?.languageCode == 'zh') {
              // zh-CN：地区限制匹配规范，表示用在中国大陆区域的中文。
              // 包括各种大方言、小方言、繁体、简体等等都可以被匹配到。
              if (locale?.scriptCode == 'Hant') {
                // zh-Hant和zh-CHT相同相对应;
                return const Locale('zh', 'HK'); //繁体
              } else {
                // zh-Hans：语言限制匹配规范，表示简体中文
                return const Locale('zh', 'CN'); //简体
              }
            }
            return locale;
          }
          return Locale('en');
        },*/
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return datamodel.firstWidget(context);
    });
  }
}

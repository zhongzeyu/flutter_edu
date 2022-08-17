import 'package:edu_proj/common/app_theme.dart';
import 'package:edu_proj/models/DataModel.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<DataModel>(
      create: (context) => DataModel(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        //darkTheme: AppTheme.light(),
        home: MyHomePage(title: ''),
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

  final dynamic title;

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

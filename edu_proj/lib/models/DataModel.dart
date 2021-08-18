import 'dart:collection';
import 'dart:convert';
//import 'dart:html';
import 'package:crypto/crypto.dart';
import 'package:edu_proj/business/businessConfig.dart';
import 'package:edu_proj/config/MyConfig.dart';
import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/generated/l10n.dart';
import 'package:edu_proj/screens/MyMain.dart';
import 'package:edu_proj/screens/firstPage.dart';
import 'package:edu_proj/screens/mainPage.dart';
import 'package:edu_proj/screens/myDetail.dart';
//import 'package:edu_proj/screens/myWait.dart';
import 'package:edu_proj/utils/AES.dart';
//import 'package:edu_proj/utils/ShowToastUtils.dart';
import 'package:edu_proj/widgets/myIcon.dart';
import 'package:edu_proj/widgets/MyForm.dart';
//import 'package:edu_proj/widgets/MyTable.dart';
import 'package:edu_proj/widgets/myButton.dart';
import 'package:edu_proj/widgets/myLabel.dart';
import 'package:edu_proj/widgets/myPic.dart';
import 'package:edu_proj/widgets/picsAndButtons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class DataModel extends ChangeNotifier {
  //String _email;
  String _token = '';
  String _myId = '';
  String _sessionkey = '';
  int _zzyprime = 91473769;
  int _zzydhbase = 2;
  int _arandomsession = new Random().nextInt(1000);
  int _requestCnt = 0;
  String _globalCompanyid = '';
  final int _defaultBackGroundColor = 4294967295; //4280391411;
  Map _systemParams = {'systemTitle': 'systemtitle'};
  int _lastBackGroundColor = 4280391411;
  final int _requestCntMax = 10;
  String _firstFormName = '';
  http.Client httpClient = http.Client();
  Locale _locale = const Locale('en', '');
  final List<int> _colorList = [
    4282679983,
    4291930500,
    4288255123, //Color(0xFF5D825E),
    4293112728,
    4294278273,
    4289572269
  ];
  Locale get locale => _locale;
  Widget _firstPage;
  Map<String, Map<String, dynamic>> _formLists = {};
  Map<int, Color> _bdBackColorList = {};
  Map<String, Map<String, dynamic>> _tableList = {};
  List<dynamic> _tabList = [];
  //Widget _tabWidget;
  Map<String, dynamic> _actionLists = {};
  Map<String, dynamic> _menuLists = {};
  Map<String, dynamic> _screenLists = {};

  Queue _requestList = new Queue();

  //String get email => _email;
  String get token => _token;
  Map<String, Map<String, dynamic>> get formLists => _formLists;
  Map<String, dynamic> get actionLists => _actionLists;
  Map<String, dynamic> get menuLists => _menuLists;
  Map<String, dynamic> get screenLists => _screenLists;

  Map<String, Map<String, dynamic>> get tableList => _tableList;
  List<dynamic> get tabList => _tabList;
  //Widget get tabWidget => _tabWidget;
  int _tabIndex = 0;
  Map get systemParams => _systemParams;
  //dynamic _tabParent;
  int get tabIndex => _tabIndex;
  setTabIndex(index) {
    _tabIndex = index;
  }

  getTabByIndex(int index) {
    return GestureDetector(
      onTap: () {
        _tabIndex = index;
        notifyListeners();
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getSCurrent(_tabList[index]['label']),
                  style: TextStyle(
                      fontWeight: index == _tabIndex
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: index == _tabIndex ? Colors.black : Colors.grey)),
              Container(
                margin: EdgeInsets.only(top: 20 / 4),
                height: 2,
                width: 30,
                color: index == _tabIndex ? Colors.black : Colors.transparent,
              ),
            ],
          )),
    );
  }

  TabController _tabController;

  DataModel() {
    init();
  }
  /*setTabParent(parent) {
    _tabParent = parent;
  }*/

  init() {}
  /*initTabController(context) {

    _tabController = TabController(
        length: _tabList.length, vsync: _tabParent, initialIndex: 0);
    //_tabController.animateTo(0);
    //_tabController.animateTo(length - 1);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {}
    });
    _tabWidget = Scaffold(
      appBar: AppBar(
        title: getTabBar(),
        backgroundColor: Colors.white,
      ),
      body: getTabBarView(context),
    );
  }*/

  addandsentRequest(action, data, context) {
    try {
      _requestList.add({'action': action, 'data': data});
      sendRequestList(context);
    } catch (e) {
      throw e;
    }
  }

  addTab(data, context) {
    //int i = 0;
    _tabList.forEach((element) {
      if (data['label'] == element['label']) {
        //_tabIndex = i;
        showTab(data['label'], context);
        notifyListeners();
        return;
      }
      //i++;
    });
    //_tabIndex = i;
    _tabList.add({
      'label': data['label'],
      'type': data['type'],
      'actionid': data['actionid']
    });
    _tabIndex = _tabList.length - 1;
    //initTabController(context);
    /*_tabController = TabController(
        initialIndex: 1, length: _tabList.length, vsync: _tabParent);
    _tabController.animateTo(_tabList.length - 1);*/
    //getTabItems();
    //getTabItemBodys(context);
    notifyListeners();

    //wait(2);
    //_tabController.animateTo(_tabList.length - 1);
    //context.refresh();
    /*wait(1);
    showTab(data['label'], context);*/
  }

  addTable(data) {
    _tableList[data['actionid']] = data['body'][data['actionid']];
  }

  Future<void> alert(BuildContext context, String msg) async {
    /*return showDialog<void>(
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text(msg),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );*/
  }
  afterSubmit(context, _formName, result) {
    Map<String, dynamic> formDefine = _formLists[_formName];
    if (formDefine['btns'] != null) {
      List btnList = formDefine['btns'];
      for (int i = 0; i < btnList.length; i++) {
        Map bi = btnList[i];
        result.add(
          SizedBox(
            height: 10,
          ),
        );

        result.add(
          InkWell(
            child: Text(
              getSCurrent(bi['label']),
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              this.sendRequestOne(bi['action'], [], context);
            },
          ),
        );
      }
    }
  }

  beforeSubmit(context, _formName, result) {
    /*if (_formName == 'login') {
      result.add(
        SizedBox(
          height: 10,
        ),
      );

      result.add(
        InkWell(
          child: Text(
            getSCurrent('forgetpassword'),
            style: TextStyle(color: Colors.black),
          ),
          onTap: () {
            forgetpassword(context);
          },
        ),
      );
    }*/
  }

  changePassword(context, data) async {
    if (data != null &&
        data.length > 0 &&
        data[0]['lastaction'] == 'finishme') {
      await finishme(context);
    }
    await openDetailForm('changepassword', context);
  }

  clear() {
    //_email = null;
    setFormValue('login', 'email', '');
    setFormValue('login', 'password', '');
    //_formLists['login']['items']['email']['defaultValue'] = '';

    //_formLists['login']['items']['email']['txtEditingController']..text = '';
    //_formLists['login']['items']['password']['txtEditingController']..text = '';
    _token = '';
    _myId = '';
  }

  decryptByDES(ciphertext) {
    var key = _sessionkey;
    var result = '';
    if (key == '') {
      result = ciphertext;
    } else {
      result = AESUtil.decrypting(ciphertext, key);
    }
    return result;
  }

  encryptByDES(datalist) {
    var key = _sessionkey;
    var json = jsonEncode(datalist); //.toString();
    var message = json;
    //datalist.toString(); //jsonEncode(json);
    print('====message is:' + message);
    var result = '';
    //var iv = '12345678';
    if (key == '') {
      result = 'noecrypted' + message;
    } else {
      result = 'sidb' +
          AESUtil.encrypting(key, 'kjsdkfjsijfkaejkjgkadjfskfjdsakf') +
          'sessionidend' +
          AESUtil.encrypting(message, key);
    }
    return Uri.encodeComponent(result);
  }

  enterUserCode(context) {
    openDetailForm('verifycode', context);
  }

  finishme(context) async {
    Navigator.pop(context);
  }

  Widget firstWidget(context) {
    if (_sessionkey == '') {
      _requestCnt = 0;
      resetSessionKey(context);
      //sendRequestList(context);
      //return MyWait();
      return MainPage();
    }

    if (_token == '' || _myId == '') {
      if (_firstFormName == 'firstPage') {
        return _firstPage;
      }
    }
    return MyMain();
  }

  forgetpassword(context) {
    var data = getFormValue('login', 'email', 'txtEditingController');
    if (data != null && data.length > 0) {
      this.sendRequestOne('forgetpassword', data, context);
    } else {
      showMsg(context, getSCurrent('plsenteremail'));
    }
  }

  formSubmit(BuildContext context, formid) {
    try {
      Map<dynamic, dynamic> obj = _formLists[formid]['items'];
      var changed = false;
      var data = {};
      data[MyConfig.FORMID.name] = formid;
      obj.entries.forEach((MapEntry<dynamic, dynamic> element) {
        //var key = element.entries.first.key;
        var objI = element.value;
        var type = objI['type'];
        if (type == MyConfig.TABLEID.name) {
          data[MyConfig.TABLEID.name] = objI['value'];
        } else if (objI['dbid'] != null && objI['dbid'] != '') {
          var value = objI['value'];
          data[objI['dbid']] = value;
          if (objI['hash'] != null && objI['hash']) {
            data[objI['dbid']] = hash(value);
          }
          if (type == MyConfig.DATE.name) {
            //data[objI['dbid']] = value.format(MyConfig.DATEFORMAT.name);
            data[objI['dbid']] =
                DateFormat(MyConfig.DATEFORMAT.name).format(value);
          }
          var oldValue = '';
          if (objI['oldvalue'] != null) {
            oldValue = objI['oldvalue'];
          }
          if (data[objI['dbid']] != oldValue) {
            changed = true;
          }
        }
      });
      if (changed) {
        //console.log(data);
        if (formid == 'changepassword' || formid == 'resetpassword') {
          var password =
              getFormValue(formid, 'password', 'txtEditingController');
          var password1 =
              getFormValue(formid, 'password1', 'txtEditingController');

          if (password1 != password) {
            showMsg(context, 'Password not match. Please check.');
            return;
          }
          /*data['email'] =
              getFormValue('login', 'email', 'txtEditingController');*/
        }
        /*if (formid == 'verifycode') {
          data['email'] =
              getFormValue(formid, 'email', 'txtEditingController');
          //Navigator.pop(context);
        }*/
        //primary key need be transfer
        obj.entries.forEach((MapEntry<dynamic, dynamic> element) {
          //var key = element.entries.first.key;
          var objI = element.value;
          if (objI[MyConfig.TABLEID.name] != '' &&
              objI['isPrimary'] &&
              data[objI[MyConfig.TABLEID.name]] == null) {
            data[objI[MyConfig.TABLEID.name]] = objI['defaultValue'];
          }
        });
        //send request;
        sendRequestFormChange(data, context); //refresh Form

        return;
      }
      alert(context, 'No change');
    } catch (e) {
      print('======exception is ' + e);
      //throw e;
      showMsg(context, e);
    }
  }

  fromBdckcolor(iColor) {
    Color result = _bdBackColorList[iColor];
    if (result != null) {
      return result;
    }
    if (getGrayLevel(iColor) > 0.5) {
      result = Colors.black;
    } else {
      result = Colors.white;
    }
    _bdBackColorList[iColor] = result;
    return result;
  }

  static Color fromInt(String strColor) {
    int intColor = int.parse(strColor);
    //print('=== intColor is $intColor');
    return Color(intColor);
  }

  getActionIcons(_param, context) {
    List<Widget> result = getLocalComponentsList(context);
    if (_param['actions'] != null) {
      for (int i = 0; i < _param['actions'].length; i++) {
        dynamic pi = _param['actions'][i];
        if (pi['type'] == 'icon') {
          result.add(MyIcon(pi));
          /*icon: Icon(IconData(pi['value'], fontFamily: 'MaterialIcons')),
            onPressed: () {
              sendRequestOne(pi['action'], '', context);
            },
          ));*/
        }
      }
    }
    return result;
  }

  getButtons(param) {
    List<dynamic> list = param['btns'];
    List<Widget> result = [];
    list.forEach((element) {
      result.add(MyButton(element));
    });
    return Column(children: result);
  }

  getCard(List data, context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
          clipBehavior: Clip.hardEdge,
          color: Color(_colorList[data[index]['colorIndex']]),
          elevation: 10.0,
          child: Column(
            children: [
              ListTile(
                title: getCardTitle(data[index]),
              ),
              Divider(),
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: getCardButtons(context, data[index]),
              )
            ],
          ),
        );
      },
    );

    /*List<Widget> cards = [];
    data.forEach((element) {
      element = Map.of(element);
      cards.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Expanded(
          //child:
          GestureDetector(
            onTap: () {
              print("Container clicked");
              processTap(context, element);
            },
            child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  //背景圆角方块
                  color: Color(_colorList[element['colorIndex']]),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 0.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: Offset(
                        2.0, // Move to right 10  horizontally
                        2.0, // Move to bottom 10 Vertically
                      ),
                    )
                  ],

                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(_colorList[element['colorIndex']]),
                      Colors.black
                    ],
                  ),
                ),
                child: getCardBody(element)),
          ),
          //),
        ],
      ));
    });
    double cardWidth = MediaQuery.of(context).size.width / 3.3;
    double cardHeight = MediaQuery.of(context).size.height / 3.6;
    double ratio = cardWidth / cardHeight * 2;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //两列

            //mainAxisSpacing: 0,
            //crossAxisSpacing: 10,
            //childAspectRatio: 0.75,
            childAspectRatio: ratio,
          ),
          itemBuilder: (context, index) => cards[index], //调用卡片组件并传参
        ),
      ),
    );*/
  }

  getCardButtons(context, data) {
    List<Widget> list = [];
    if (data['type'] == 'process') {
      List detail = data['detail'];
      detail.forEach((element) {
        list.add(TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              primary: fromBdckcolor(data['colorIndex']),
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              element['colorIndex'] = data['colorIndex'];
              processTap(context, element);
            },
            child: Text(getSCurrent(element['label']))));
      });
    }

    return list;
  }

  getCardTitle(data) {
    if (data['type'] == 'process')
      return getTxtImage(
          data['label'], _colorList[data['colorIndex']], 24, 0, 2.0);
  }

  getDetailWidget(param) {
    List<Widget> result = [];

    if (param == null) {
      return result;
    }
    result.add(SizedBox(height: gDefaultPaddin));
    //title
    Widget title = getWidgetTitle(param);
    if (title != null) {
      result.add(Center(child: getWidgetTitle(param)));
    }

    //add body
    Widget body = getWidgetBody(param);
    if (body != null) {
      result.add(SizedBox(height: gDefaultPaddin));
      result.add(SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(gDefaultPaddin),
          child: body,
        ),
      ));
    }

    //add  bottomImages
    List<Widget> bottom = [];
    if (param['bottomImgs'] != null) {
      List bottomImages = param['bottomImgs'];

      for (int i = 0; i < bottomImages.length; i++) {
        bottom.add(MyPic(bottomImages[i]));
      }
    }
    result.add(Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end, children: bottom)));
    return Column(children: result);
    /*if (param['type'] == 'form')
      return MyForm(param);
    else if (param['type'] == 'tableid') return MyTable(param);*/
  }

  getFirstPage(name) {
    Widget result;
    if (_screenLists[name]['type'] == 'PicsAndButtons') {
      result = new PicsAndButtons(_screenLists[name]);
    } else if (_screenLists[name]['type'] == 'Login') {
      //result = Login(_screenLists[_name]);
    }
    return result;
  }

  getFormDefineImage(formValue) {
    return getTxtImage(
        formValue['title']['label'],
        _lastBackGroundColor,
        formValue['title']['fontSize'],
        formValue['title']['height'],
        formValue['title']['letterSpacing']);
  }

  getFormValue(formid, dbid, valueid) {
    Map<String, dynamic> formDetail = _formLists[formid];
    if (valueid == 'txtEditingController') {
      return formDetail['items'][dbid][valueid].value.text;
    }
    return formDetail['items'][dbid][valueid];
  }

  getGrayLevel(int intColor) {
    //int intColor = int.parse(strColor);
    bool isOdd = true;
    double result = 0;
    List<double> rateList = [0.114, 0.587, 0.299];
    int j = 0;
    int tmp = 0;
    for (int i = 0; i < 6; i++) {
      int mod = intColor % 16;
      intColor = intColor ~/ 16;
      if (isOdd) {
        tmp = mod;
      } else {
        tmp += mod * 16;
        result += tmp * rateList[j++];
      }
      isOdd = !isOdd;
    }
    //print("result for " + strColor + "is :" + (result / 255).toString());
    return result / 255;
  }

  getIconsByName(iconname) {
    if (iconname == 'menu') {
      return Icons.menu;
    } else if (iconname == 'logout') {
      return Icons.logout;
    } else if (iconname == 'manage_accounts') {
      return Icons.person;
    }
    return Icons.device_unknown;
  }

  getInputType(s) {
    if (s == 'visiblePassword') {
      return TextInputType.visiblePassword;
    } else if (s == 'emailAddress') {
      return TextInputType.emailAddress;
    } else if (s == 'datetime') {
      return TextInputType.datetime;
    } else if (s == 'multiline') {
      return TextInputType.multiline;
    } else if (s == 'name') {
      return TextInputType.name;
    } else if (s == 'number') {
      return TextInputType.number;
    } else if (s == 'phone') {
      return TextInputType.phone;
    } else if (s == 'streetAddress') {
      return TextInputType.streetAddress;
    } else if (s == 'url') {
      return TextInputType.url;
    } else if (s == 'values') {
      return TextInputType.values;
    } else if (s == 'name') {
      return TextInputType.name;
    }

    return TextInputType.text;
  }

  getLocalComponents(context) {
    return Row(children: getLocalComponentsList(context));
  }

  getLocalComponentsList(context) {
    ThemeData themeData = Theme.of(context);
    int valueColor = themeData.backgroundColor.value;
    return [
      Icon(Icons.public_outlined),
      (_locale.languageCode == 'en')
          ? TextButton(
              child: Text('中文',
                  style: TextStyle(color: fromBdckcolor(valueColor))),
              onPressed: () {
                setLocale(Locale('zh'));
              },
            )
          : TextButton(
              child: Text('EN',
                  style: TextStyle(color: fromBdckcolor(valueColor))),
              onPressed: () {
                setLocale(Locale('en'));
              },
            )
    ];
  }

  getMenuItems(String menuName, context) {
    List<Widget> items = [];

    /*for (int i = 0; i < _menuLists[menuName].length; i++) {
      items.add(Text(getSCurrent(_menuLists[menuName][i]['label'])));
    }*/
    _menuLists[menuName].forEach((element) {
      //items.add(Text(getSCurrent(map['label'])));
      items.add(ListTile(
        leading: Icon(getIconsByName(element['icon'])),
        title: Text(getSCurrent(element[
            'label'])), //MyLabel({'label': map['label'] + '', 'fontSize': 20.0}),
        onTap: () {
          onTap(context, element);
        },
        //onTap: datamodel.onTap(context, map),
      ));
    });
    return items;
  }

  getMod(source, exponent, divider) {
    var rtn = 1;
    for (var i = 0; i < exponent; i++) {
      rtn *= source;
      rtn = rtn % divider;
    }
    return rtn;
  }

  getParamTypeValue(param) {
    param[param['type']] = param['value'];

    return param;
  }

  int _picIndex = 0;
  getPics(param) {
    List<dynamic> list = param['pics'];
    if (_picIndex >= list.length) {
      _picIndex = 0;
    }

    List<Widget> result = [];
    result.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      MyPic(list[_picIndex]),
      SizedBox(width: gDefaultPaddin),
      MyLabel(list[_picIndex]),
    ]));
    List<Widget> dotList = [];
    for (int i = 0; i < list.length; i++) {
      dotList.add(Material(
        child: InkWell(
            onTap: () {
              _picIndex = i;
              notifyListeners();
            },
            child: Image.asset(
                '/images/' + ((i == _picIndex) ? 'bright' : 'dark') + 'dot.png',
                package: packageName)),
      ));
    }
    result.add(
        Row(mainAxisAlignment: MainAxisAlignment.center, children: dotList));
    return result;
  }

  getSCurrent(dynamic source) {
    List<dynamic> s;
    try {
      s = source;
    } catch (e) {
      s = [source];
    }
    try {
      if (s[0] == 'backbtn') {
        return S.current.backbtn;
      } else if (s[0] == 'changepassword') {
        return S.current.changepassword;
      } else if (s[0] == 'character') {
        return S.current.character;
      } else if (s[0] == 'checkverifycode') {
        return S.current.checkverifycode;
      } else if (s[0] == 'createAccount') {
        return S.current.createAccount;
      } else if (s[0] == 'createnewpassword') {
        return S.current.createnewpassword;
      } else if (s[0] == 'email') {
        return S.current.email;
      } else if (s[0] == 'employee') {
        return S.current.employee;
      } else if (s[0] == 'eteremailtoresetpassword') {
        return S.current.eteremailtoresetpassword;
      } else if (s[0] == 'forgetpassword') {
        return S.current.forgetpassword;
      } else if (s[0] == 'home') {
        return S.current.home;
      } else if (s[0] == 'invalidname') {
        return S.current.invalidname(getSCurrent([s[1]]));
      } else if (s[0] == 'isrequired') {
        return S.current.isrequired(getSCurrent([s[1]]));
      } else if (s[0] == 'login') {
        return S.current.login;
      } else if (s[0] == 'mininput') {
        return S.current.mininput(s[1], s[2]);
      } else if (s[0] == 'maxinput') {
        return S.current.maxinput(s[1], s[2]);
      } else if (s[0] == 'password') {
        return S.current.password;
      } else if (s[0] == 'plsenteremail') {
        return S.current.plsenteremail;
      } else if (s[0] == 'program') {
        return S.current.program;
      } else if (s[0] == 'resetpassword') {
        return S.current.resetpassword;
      } else if (s[0] == 'role') {
        return S.current.role;
      } else if (s[0] == 'serverdown') {
        return S.current.serverdown;
      } else if (s[0] == 'serverwrongcode') {
        return S.current.serverwrongcode;
      } else if (s[0] == 'student') {
        return S.current.student;
      } else if (s[0] == 'submit') {
        return S.current.submit;
      } else if (s[0] == 'system') {
        return S.current.system;
      } else if (s[0] == 'systemtitle') {
        return S.current.systemtitle;
      } else if (s[0] == 'tutor') {
        return S.current.tutor;
      } else if (s[0] == 'updatepassword') {
        return S.current.updatepassword;
      } else if (s[0] == 'verifycode') {
        return S.current.verifycode;
      } else if (s[0] == 'welcome') {
        return S.current.welcome;
      }
    } catch (e) {}

    return source;
  }

  getTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: getTabItems(),
    );
  }

  getTabBarView(context) {
    return TabBarView(
        //必须配置
        controller: _tabController,
        children: getTabItemBodys(context));
  }

  getTabBody(element, context) {
    dynamic data = _tabList[_tabIndex];
    if (data['type'] == 'card') {
      return getCard(data['body'], context);
    }
    return Text('not available');
  }

  getTabItems() {
    List<Widget> items = [];
    _tabList.forEach((element) {
      items.add(Tab(
        text: getSCurrent(element['label']),
      ));
      /*items.add(Text(
         getSCurrent(element['label']), style: TextStyle(color: Colors.black, fontSize: 22),
      ));*/
    });
    return items;
  }

  getTabItemBodys(context) {
    List<Widget> items = [];
    _tabList.forEach((element) {
      items.add(getTabBody(element, context));
    });
    return items;
  }

  getTxtImage(label, color, fontSize, height, letterSpacing) {
    return Text(
      getSCurrent(label),
      style: TextStyle(
        color: fromBdckcolor(color),
        //color: Colors.white,
        fontSize: fontSize,
        height: height,

        //fontFamily: ,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
              color: Color(color),
              offset: Offset.fromDirection(3),
              blurRadius: 5.0)
        ],
      ),
    );
  }

  getWidgetBody(param) {
    if (param['type'] == 'form') {
      return getWidgetForm(param);
    }
    return Column(
      children: [
        MyLabel({'label': 'welcome', 'fontSize': 20.0})
      ],
    );
  }

  getWidgetForm(param) {
    String formID = param['formdetail']['formName'];

    setFormListOne(formID, param);

    return MyForm(formID);
  }

  getWidgetTitle(param) {
    Widget title;
    param['title'] = getParamTypeValue(param['title']);
    if (param['title']['type'] == 'label') {
      title = MyLabel(param['title']);
    } else if (param['title']['type'] == 'icon') {
      title = MyIcon(param['title']);
    } else if (param['title']['type'] == 'img') {
      title = MyPic(param['title']);
      //MyImg(getParamTypeValue(param['title']));
    }
    return title;
  }

  String hash(str) {
    var bytes1 = utf8.encode(str); // data being hashed
    var digest1 = sha256.convert(bytes1); // Hashing Process
    return digest1.toString();
  }

  logOff() {
    clear();

    notifyListeners();
  }

  onTap(context, Map map) {
    try {
      if (map['type'] == 'action') {
        if (map['actionid'] == 'logout') {
          logOff();
        } else if (map['actionid'] == 'changepassword') {
          changePassword(context, null);
        } else if (map['actionid'] == 'role') {}
      } else if (map['type'] == 'table') {
        var tableid = map['actionid'];
        _lastBackGroundColor = _defaultBackGroundColor;

        showTable(tableid, context);
      }
    } catch (e) {
      showMsg(context, e);
    }
    if (map['label'] == "Test") {
      //showTab("role", context);
    }
    print('=====typed ' + map['label']);
  }

  openDetailForm(formname, context) {
    Map param = {
      'backgroundColor': _formLists[formname]['backgroundColor'],
      'color': _formLists[formname]['color'],
      'name': formname,
      'type': 'form'
    };
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyDetail(param)));
  }

  processRequest(dataRequest, context) async {
    final headers = {
      'contentType':
          'text/html,application/xhtml+xml,application/xml,application/x-www-form-urlencoded',
      'accept-language': 'en-US,en'
    };

    var url = MyConfig.URL.name + 'smilesmart';
    http.Response response;
    try {
      response =
          // ignore: return_of_invalid_type_from_catch_error
          await httpClient
              .post(url, headers: headers, body: dataRequest)
              .catchError((error) {
        //ShowToast.warning(error.toString());
        throw (error);
      });

      if (response.statusCode != 200) {
        throw Exception(S.current
            .serverwrongcode(response.statusCode, response.body.toString()));
      }
      print('==== response: ' + response.body);
      List data = jsonDecode(response.body);

      //print(data.entries.first.key);
      //print(data.entries.first.value);

      data.forEach((element) async {
        //print(key);
        var action = '';
        List actionData;
        element.forEach((key, value) {
          if (key == 'action') {
            action = value;
          } else if (key == 'data') {
            actionData = value;
          }
        });
        if (action == 'changepassword') {
          await changePassword(context, actionData);
        } else if (action == 'finishme') {
          await finishme(context);
        } else if (action == 'processTab') {
          await processTab(actionData, context);
        } else if (action == 'removeAllScreens') {
          await removeAllScreens(context);
        } else if (action == 'resetpassword') {
          await resetPassword(context, actionData);
        } else if (action == 'showScreenPage') {
          await showScreenPage(actionData, context);
          /*} else if (action == 'setFormList') {
          await setFormList(actionData);*/
        } else if (action == 'setMyAction') {
          await setMyAction(actionData);
        } else if (action == 'setMyInfo') {
          await setMyInfo(actionData[0], context);
        } else if (action == 'setMyMenu') {
          await setMyMenu(actionData);
        } else if (action == 'setMyTab') {
          await setMyTab(actionData);
        } else if (action == 'setInitForm') {
          await setInitForm(actionData);
        } else if (action == 'setSessionkey') {
          await setSessionkey(actionData[0]['key']);
        } else if (action == 'setTableList') {
          await setTableList(actionData);
        } else if (action == 'showErr') {
          actionData[0] = Map.of(actionData[0]);
          showMsg(context, actionData[0]['errMsg']);
          //throw actionData[0]['errMsg'];
        } else if (action == 'showTable') {
          await showTable(actionData[0]['tableid'], context);
        }
      });
    } catch (e) {
      throw e;
    }
  }

  processTab(List data, context) {
    data.forEach((data0) {
      data0 = Map.of(data0);
      if (data0['type'] == 'table') {
        addTable(data0);
      }
      addTab(data0, context);
    });

    //notifyListeners();
  }

  processTap(context, element) {
    _tabList.forEach((el) {
      if (el['label'] == element['label']) {
        showTab(el['actionid'], context);
        return;
      }
    });
    sendRequestOne('process', [element], context);
  }

  removeAllScreens(context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    notifyListeners();
  }

  requestListAddFirst(data) {
    if (requestListExists(data)) {
      return;
    }
    if (data != null) {
      _requestList.addFirst(data);
    }
  }

  requestListExists(item) {
    if (_requestList != null) {
      _requestList.forEach((element) {
        var value = element.value;
        var objIaction = value['action'];
        if (objIaction == item['action']) {
          var objIDataStr = value['data'].toString();
          var dataStr = item['data'].toString();
          if (objIDataStr == dataStr) {
            //duplicated, return
            return true;
          }
        }
      });
    }

    return false;
  }

  requestListRemoveFirst() {
    return _requestList.removeFirst();
    /*if (index >= 0) {
      _requestList.removeWhere((key, value) => key == index);
    }*/
  }

  resetPassword(context, data) {
    if (data != null &&
        data.length > 0 &&
        data[0]['msg'] != null &&
        data[0]['msg'] == 'enterusercode') {
      enterUserCode(context);
    }
    //check password
  }

  resetSessionKey(context) async {
    try {
      _sessionkey = '';
      await Future.delayed(Duration(seconds: 2)); //等1秒
      _requestCnt++;
      if (_requestCnt > _requestCntMax) {
        _requestCnt = 0;
        throw Exception(getSCurrent('serverdown'));
      }
      sendRequestList(context);
    } catch (e) {
      throw e;
    }
  }

  retrieveTableFromDB(tableid, context) {
    try {
      sendRequestOne(
          'getTableData',
          {
            "tableid": tableid,
            "email": getFormValue('login', 'email', 'value'),
            "company": _globalCompanyid
          },
          context);
    } catch (e) {
      throw e;
    }
  }

  sendRequestFormChange(data, context) {
    try {
      sendRequestOne('formchange', [data], context);
    } catch (e) {
      throw e;
    }
  }

  sendRequestList(context) async {
    try {
      var secretekey = _sessionkey;
      if (secretekey == '') {
        //hold for 1 sec
        wait(1);
        var param = getMod(_zzydhbase, _arandomsession, _zzyprime);
        _requestList.addFirst({
          'action': 'getsessionkey',
          'data': [
            {'key': param}
          ]
        });
      }
      if (_requestList.isEmpty) {
        return;
      }
      if (_requestList.length < 1) {
        return;
      }
      Map requestFirst = requestListRemoveFirst();
      if (_token != '') {
        requestFirst['token'] = _token;
        requestFirst['companyid'] = _globalCompanyid;
      }
      var dataRequest = encryptByDES(requestFirst);
      await processRequest(dataRequest, context);
    } catch (e) {
      showMsg(context, e);
      //throw e;
      //print('=====exception is ' + e);
    } finally {
      // await sendRequestList(context);
    }
    //downloadResponse(data);
  }

  sendRequestOne(action, data, context) {
    try {
      //check if duplicate
      if (requestListExists({'action': action, 'data': data})) {
        return;
      }

      addandsentRequest(action, data, context);
    } catch (e) {
      throw e;
    }
  }

  setFormList(actionData) {
    List<dynamic> thisList = actionData;
    for (int i = 0; i < thisList.length; i++) {
      Map<String, dynamic> thisListI = thisList[i];
      thisListI.entries.forEach((element) {
        String formID = element.key;
        setFormListOne(formID, element.value);
      });
    }
  }

  setFormListOne(formID, param) {
    var formDetail = param['formdetail'];
    var btns = param['btns'];
    Map<String, dynamic> formValue = Map.from(formDetail);

    //formValue['submit'] = getSCurrent(formValue['submit']);
    //String title = getSCurrent(formValue['title']['label']);

    formValue['backgroundColor'] = Color(_lastBackGroundColor);
    /*formValue['image'] = Text(
          getSCurrent(formValue['title']['label']),
          style: TextStyle(
            color: fromBdckcolor(_lastBackGroundColor),
            fontSize: formValue['title']['fontSize'],
            height: formValue['title']['height'],

            //fontFamily: ,
            letterSpacing: formValue['title']['letterSpacing'],
            fontWeight: FontWeight.bold,
            //background: new Paint()..color = Colors.yellow,
            //foreground: new Paint()..color = Colors.red,
            //decoration: TextDecoration.underline,
            //decorationStyle: TextDecorationStyle.dashed
            shadows: [
              Shadow(
                  color: Color(_lastBackGroundColor),
                  offset: Offset.fromDirection(3),
                  blurRadius: 5.0)
            ],
          ),
        );*/

    Map<String, dynamic> itemList = formValue['items'];
    itemList.entries.forEach((elementItemList) {
      Map<String, dynamic> valueItemList = elementItemList.value;
      //valueItemList['label'] = getSCurrent(valueItemList['label']);
      /*valueItemList['prefixIcon'] = Icon(
          IconData(valueItemList['prefixIcon'], fontFamily: 'MaterialIcons'));*/
      valueItemList['inputType'] = getInputType(valueItemList['inputType']);
      valueItemList['txtEditingController'] =
          TextEditingController(text: valueItemList['defaultValue']);
      valueItemList['value'] = '';
      valueItemList['oldvalue'] = '';
      valueItemList['textFontColor'] = fromBdckcolor(_lastBackGroundColor);

      valueItemList = Map.from(valueItemList);
    });
    formValue['items'] = Map.from(itemList);
    formValue['items'].forEach((key, value) {
      formValue['items'][key] = Map.of(value);
    });

    formValue['btns'] = btns;
    _formLists[formID] = formValue;
  }

  showScreenPage(actionData, context) {
    for (int i = 0; i < actionData.length; i++) {
      Map<String, dynamic> ai = actionData[i];
      String name;
      dynamic data;
      ai.entries.forEach((element) {
        if (element.key == 'name') {
          name = element.value;
        } else if (element.key == 'data') {
          data = element.value;
        }
      });

      if (name == 'firstPage') {
        _screenLists[name] = Map.of(data);
        _firstFormName = name;
        _firstPage = FirstPage(_firstFormName);
      } else if (name == 'detailPage') {
        //deailPage(_firstFormName);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MyDetail(Map.of(data))));
      }
    }
    notifyListeners();
  }

  setInitForm(actionData) {
    _firstFormName = actionData[0]['name'];
    notifyListeners();
  }

  setFormValue(formid, colId, value) {
    _formLists[formid]['items'][colId]['value'] = value;
    _formLists['login']['items'][colId]['txtEditingController']..text = value;
    //
  }

  setLocale(value) {
    _locale = value;
    S.load(_locale);

    notifyListeners();
  }

  setMyAction(data) {
    _actionLists['main'] = data;
  }

  setMyInfo(data, context) {
    //_myInfo = data;
    setFormValue('login', 'email', data['email']);
    //_formLists['login']['items']['email']['defaultValue'] = data['email'];
    _token = data['token'];
    _myId = data['email'];
    _globalCompanyid = data['companyid'];
    //notifyListeners();
  }

  setMyMenu(List data) {
    for (int i = 0; i < data.length; i++) {
      data[i] = Map.of(data[i]);
      //data[i]['widget'] = Text(getSCurrent('role'));
    }
    _menuLists['main'] = data;
  }

  getMenuListLabel() {
    return _menuLists['main'][0]['label'];
  }

  setMyTab(List data) {
    Map data0 = Map.of(data[0]);
    List<dynamic> data0body = data0['body'];
    int i = 0;
    List databodyNew = [];
    data0body.forEach((element) {
      element = Map.of(element);
      if (i == _colorList.length) {
        i = 0;
      }
      element['colorIndex'] = i;
      databodyNew.add(element);
      i++;
    });
    data0['body'] = databodyNew;
    data0['isselected'] = true;
    _tabList = [data0];
    notifyListeners();
  }

  setSessionkey(data) {
    int key = int.parse(data);
    String sessionkey = getMod(key, _arandomsession, _zzyprime).toString();
    _sessionkey = hash(sessionkey);
    //notifyListeners();
  }

  setTableList(List<dynamic> data) {
    data.forEach((element) {
      element.entries.forEach((element1) {
        addTable(element1);
      });
    });
  }

  showMsg(context, dynamic result) {
    /*Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);*/
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Text(
              result.toString(),
              style: TextStyle(fontSize: 15),
            ),
          );
        });
  }

  showTab(label, context) {
    int i = 0;
    _tabList.forEach((element) {
      if (element['label'] == label) {
        //_tabController.animateTo(i);
        _tabIndex = i;
        //DefaultTabController.of(context).animateTo(i);
        return;
        //_tabController.initialIndex = i;
      }
      i++;
    });
    _tabIndex = 0;
    //addTab();
    //notifyListeners();
  }

  showTable(String tableid, context) {
    if (_tableList[tableid] == null) {
      retrieveTableFromDB(tableid, context);
    } else {
      Map param = {'tableid': tableid, 'type': 'table'};
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyDetail(param)));
    }
  }

  wait(waitSeconds) async {
    await Future.delayed(Duration(seconds: waitSeconds));
  }
}

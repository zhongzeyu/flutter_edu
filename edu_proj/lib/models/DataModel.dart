// @dart=2.9
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
//import 'dart:io';
import 'package:crypto/crypto.dart';
//import 'package:dio/dio.dart';
import 'package:edu_proj/config/MyConfig.dart';
import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/screens/MyDynamicBody.dart';
//import 'package:edu_proj/screens/MyMain.dart';
import 'package:edu_proj/screens/firstPage.dart';
//import 'package:edu_proj/screens/mainPage.dart';
//import 'package:edu_proj/screens/myDetail.dart';
import 'package:edu_proj/screens/myDetailNew.dart';
import 'package:edu_proj/utils/AES.dart';
import 'package:edu_proj/widgets/myIcon.dart';
import 'package:edu_proj/widgets/MyForm.dart';
import 'package:edu_proj/widgets/myButton.dart';
import 'package:edu_proj/widgets/myItem.dart';
import 'package:edu_proj/widgets/myLabel.dart';
//import 'package:edu_proj/widgets/myPaginatedDataTable.dart';
import 'package:edu_proj/widgets/myPic.dart';
import 'package:edu_proj/widgets/myScreen.dart';
//import 'package:edu_proj/widgets/myTree.dart';
//import 'package:edu_proj/widgets/picsAndButtons.dart';
import 'package:edu_proj/widgets/radios.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_treeview/flutter_treeview.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
//import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/pdfScreen.dart';

class DataModel extends ChangeNotifier {
  //String _email;
  String _token = '';
  String _myId = '';
  String _sessionkey = '';
  String initRequest = ''; //'checkout';
  int _zzyprime = 91473769;
  int _zzydhbase = 2;
  int _arandomsession = new Random().nextInt(1000);
  int _requestCnt = 0;
  String _globalCompanyid = '';
  final int _defaultBackGroundColor = 4294967295; //4280391411;
  Map _systemParams = {gSystemTitle: gSystemTitle};
  int _lastBackGroundColor = 4280391411;
  final int _requestCntMax = 10;
  //String _firstFormName = '';
  http.Client httpClient = http.Client();
  //Locale _locale = const Locale('en', '');
  String _locale = 'en';
  /*final List<int> _colorList = [
    4282679983,
    4291930500,
    4288255123, //Color(0xFF5D825E),
    4293112728,
    4294278273,
    4289572269
  ];*/
  final List<int> _colorList = [
    Colors.cyan.value,
    Colors.amber.value,
    Colors.brown.value,
    Colors.orange.value,
    Colors.red.value,
    Colors.green.value,
    Colors.blue.value,
    Colors.purple.value,
    Colors.lime.value,
    Colors.indigo.value,
    Colors.pink.value,
    Colors.teal.value,
    Colors.yellow.value,
  ];
  //Locale get locale => _locale;
  String get locale => _locale;
  Widget _firstPage = Text('');
  Map<String, Map<String, dynamic>> _formLists = {};
  Map<int, Color> _bdBackColorList = {};
  Map<String, Map<String, dynamic>> _tableList = {};
  Map<String, dynamic> _tabList = {};
  //Widget _tabWidget;
  Map<String, dynamic> _actionLists = {};
  Map<String, dynamic> _menuLists = {};
  Map<String, dynamic> _screenLists = {};
  Map<String, String> _imgList = {
    gMain:
        'https://ipt.imgix.net/201444/x/0/?auto=format%2Ccompress&crop=faces%2Cedges%2Ccenter&bg=%23fff&fit=crop&q=35&h=944&dpr=1'
  };
  Map get imgList => _imgList;
  Map<String, dynamic> _i10nMap = {};
  Queue _requestList = new Queue();

  //String get email => _email;
  String get token => _token;
  Map<String, Map<String, dynamic>> get formLists => _formLists;
  Map<String, dynamic> get actionLists => _actionLists;
  Map<String, dynamic> get menuLists => _menuLists;
  Map<String, dynamic> get screenLists => _screenLists;

  Map<String, Map<String, dynamic>> get tableList => _tableList;
  Map<String, dynamic> get tabList => _tabList;
  //Widget get tabWidget => _tabWidget;
  //int _tabIndex = 0;
  Map get systemParams => _systemParams;
  Set _loadingTable = {};
  Size _sceenSize = new Size(800, 1000);
  Size get sceenSize => _sceenSize;
  setScreenSize(Size size) {
    _sceenSize = size;
  }
  //dynamic _tabParent;
  /*int get tabIndex => _tabIndex;
  setTabIndex(index) {
    _tabIndex = index;
  }*/

  //TabController _tabController;

  DataModel() {
    init();
  }
  /*setTabParent(parent) {
    _tabParent = parent;
  }*/

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _locale = (prefs.getString('locallan') ?? _locale);
  }
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
      _requestList.add({gAction: action, gData: data});
      sendRequestList(context);
    } catch (e) {
      throw e;
    }
  }

  addTab(data, context, tabName) {
    if (isNull(data[gLabel])) {
      return;
    }
    bool tabExists = showTab(data[gLabel], context, tabName);
    if (tabExists) {
      refreshTab(data, context, tabName);
      return;
    }
    addTabSub(data, tabName);
    /*_tabList[tabName][gData].add(
        {gLabel: data[gLabel], gType: data[gType], gActionid: data[gActionid]});
    _tabList[tabName][gTabIndex] = _tabList[tabName][gData].length - 1;*/
    myNotifyListeners();

    //wait(2);
    //_tabController.animateTo(_tabList.length - 1);
    //context.refresh();
    /*wait(1);
    showTab(data[gLabel], context);*/
  }

  addTabSub(data, tabName) {
    _tabList[tabName][gData].add(
        {gLabel: data[gLabel], gType: data[gType], gActionid: data[gActionid]});
    _tabList[tabName][gTabIndex] = _tabList[tabName][gData].length - 1;
  }

  addTable(data, context) {
    var isNew = false;
    if (_tableList[data[gActionid]] == null) {
      isNew = true;
    }
    _tableList[data[gActionid]] = Map.of(data[gBody][data[gActionid]]);
    List dataList = _tableList[data[gActionid]][gData];
    if (dataList != null && dataList.length > 0) {
      for (int i = 0; i < dataList.length; i++) {
        dataList[i] = Map.of(dataList[i]);
      }
    }
    List colList = _tableList[data[gActionid]][gColumns];
    if (colList != null && colList.length > 0) {
      for (int i = 0; i < colList.length; i++) {
        colList[i] = Map.of(colList[i]);
      }
    }
    _tableList[data[gActionid]][gAttr] =
        Map.of(_tableList[data[gActionid]][gAttr]);

    _tableList[data[gActionid]][gAscending] = true;
    _tableList[data[gActionid]][gSortColumnIndex] = 0;
    if (isNew && _tableList[data[gActionid]][gAttr][gOrderby] != null) {
      //auto sort by order by
      var orderbyList =
          (_tableList[data[gActionid]][gAttr][gOrderby] + '').split(',');
      for (var i = orderbyList.length - 1; i >= 0; i--) {
        var orderbyOne = orderbyList[i].split(' ');
        var ascending = true;
        if (orderbyOne.length > 1) {
          if (orderbyOne[1] != gAsc) {
            ascending = false;
          }
        }
        var columnIndex = 0;
        for (var i = 0; i < colList.length; i++) {
          if (colList[i][gId] == orderbyOne[0]) {
            break;
          }
          if (isHiddenColumn(colList, i)) {
            continue;
          }
          columnIndex++;
        }
        tableSort(data[gActionid], columnIndex, ascending, context);
        /*if (i == 0) {
          _tableList[data[gActionid]][gAscending] = ascending;
          _tableList[data[gActionid]][gSortColumnIndex] = columnIndex;
        }*/
        //if (i > 0) {
        //}
      }
    }

    _tableList[data[gActionid]][gTableID] = data[gActionid];
    initTableData(data[gActionid], context);
    Map param = {
      gType: gForm,
      gFormdetail: {
        gFormName: data[gActionid],
        gsBackgroundColor: 4280391411,
        gSubmit: gSubmit,
        gImgTitle: {
          gTitle: data[gLabel],
          gFontSize: 40.0,
          gHeight: 1.2,
          gLetterSpacing: 1.0
        },
        gHeight: 450.5,
        gTop: 130.0,
        gItems: {}
      },
      gActions: [
        {gType: gIcon, gValue: 58336, gAction: gMessenger}
      ],
      gBottomImgs: [],
      gTitle: {},
      gBtns: []
    };

    for (int i = 0; i < _tableList[data[gActionid]][gColumns].length; i++) {
      //for (int i = 0; i < 3; i++) {
      Map ti = Map.of(_tableList[data[gActionid]][gColumns][i]);
      param[gFormdetail][gItems][ti[gDbid]] = ti;
    }
    _formLists[data[gActionid]] = null;

    setFormListOne(data[gActionid], param[gFormdetail]);
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
    if (formDefine[gBtns] != null) {
      List btnList = formDefine[gBtns];
      for (int i = 0; i < btnList.length; i++) {
        Map bi = btnList[i];
        result.add(
          SizedBox(
            height: 10.0,
          ),
        );

        result.add(
          InkWell(
            child: Text(
              getSCurrent(bi[gLabel]),
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              this.sendRequestOne(bi[gAction], [], context);
            },
          ),
        );
      }
    }
  }

  beforeSubmit(context, _formName, result) {
    /*if (_formName == gLogin) {
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

  changePassword(context, data, backcolor) async {
    if (data != null && data.length > 0 && data[0][gLastaction] == gFinishme) {
      await finishme(context);
    }
    await openDetailForm(gChangepassword, context, backcolor);
  }

  clear(context) {
    //_email = null;
    setFormValue(gLogin, gEmail, '');
    setFormValue(gLogin, gPassword, '');
    //_formLists[gLogin][gItems][gEmail][gDefaultValue] = '';

    //_formLists[gLogin][gItems][gEmail][gTxtEditingController]..text = '';
    //_formLists[gLogin][gItems]['password'][gTxtEditingController]..text = '';
    _token = '';
    _myId = '';
    _tabList = {};

    //showScreenPageOne(gLogin, context, Colors.black.value);
    removeAllScreens(context);
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

  deleteTableOne(data, context) {
    Map rowData = data[gRow];
    var dataDelete = {};
    dataDelete[gFormid] = data[gTableID];
    //dataDelete[gId] = _tableList[data[gTableID]][gData][row][gId];
    dataDelete[gId] = rowData[gId];

    sendRequestOne('formchange', [dataDelete], context);
  }

  deleteTabOne(tabName, tabIndex) {
    _tabList[tabName][gData][tabIndex][gVisible] = false;
    _tabList[tabName][gTabIndex] = 0;
    myNotifyListeners();
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
      result = gNoecrypted + message;
    } else {
      result = gSidb +
          AESUtil.encrypting(key, 'kjsdkfjsijfkaejkjgkadjfskfjdsakf') +
          gSessionidend +
          AESUtil.encrypting(message, key);
    }
    return Uri.encodeComponent(result);
  }

  enterUserCode(context, backcolor) {
    openDetailForm(gVerifycode, context, backcolor);
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
      //return MainPage();
    }
    return _firstPage;
    /*if (_token == '' || _myId == '') {
      if (_firstFormName == gFirstPage) {
        return _firstPage;
      }
    }
    return MyMain();*/
  }

  forgetpassword(context) {
    var data = getFormValue(gLogin, gEmail, gTxtEditingController);
    if (data != null && data.length > 0) {
      this.sendRequestOne(gForgetpassword, data, context);
    } else {
      showMsg(context, getSCurrent(gPlsenteremail), null);
    }
  }

  formSubmit(BuildContext context, formid) {
    try {
      Map<dynamic, dynamic> obj = _formLists[formid][gItems];
      var changed = false;
      var data = {};
      data[gFormid] = formid;
      data[gId] = (obj[gId] != null) ? obj[gId][gValue] : '';
      data[gOptLock] = (obj[gOptLock] != null) ? obj[gOptLock][gValue] : '';
      obj.entries.forEach((MapEntry<dynamic, dynamic> element) {
        //var key = element.entries.first.key;
        var objI = element.value;
        var type = objI[gType];
        if (type == gId) {
          data[gId] = objI[gValue];
        } else if (objI[gType] == gLabel) {
        } else if (objI[gDbid] != null && objI[gDbid] != '') {
          var value = objI[gValue];
          //data[objI[gDbid]] = value;
          if (objI[gHash] != null && objI[gHash]) {
            value = hash(value);
          }
          if (type == gDate) {
            value = value.format(gDateformat);
            //data[objI[gDbid]] =
            //  DateFormat(gDateformat).format(value);
          } else if (type == gDatetime) {
            value = toUTCTime(value);
          }
          var oldValue = '';
          if (objI[gOldvalue] != null) {
            oldValue = objI[gOldvalue];
          }
          if (objI[gId] != '' && objI[gIsPrimary] != null && objI[gIsPrimary]) {
            data[objI[gDbid]] = oldValue;
          }
          if (value == null) {
            value = '';
          }
          if (value != oldValue) {
            changed = true;
            data[objI[gDbid]] = value;
          } else if (data[gId] == null || data[gId] == '') {
            data[objI[gDbid]] = value;
          }
        }
      });
      if (changed) {
        //console.log(data);
        if (formid == gChangepassword || formid == gResetpassword) {
          var password = getFormValue(formid, gPassword, gTxtEditingController);
          var password1 =
              getFormValue(formid, gPassword1, gTxtEditingController);

          if (password1 != password) {
            showMsg(context, getSCurrent(gPasswordnotmatch), null);
            return;
          }
          //var loginemail = getFormValue(gLogin, gEmail, gTxtEditingController);
          data[gEmail] = _myId;
        }

        //set to default value if empty
        /*obj.entries.forEach((MapEntry<dynamic, dynamic> element) {
          //var key = element.entries.first.key;
          var objI = element.value;
          if (objI[gId] != '' &&
              //objI[gIsPrimary] != null &&
              //objI[gIsPrimary] &&
              (data[objI[gId]] == null || data[objI[gId]] == '')) {
            data[objI[gId]] = objI[gOldvalue] ?? objI[gDefaultValue];
          }
        });*/
        //send request;
        sendRequestFormChange(data, context); //refresh Form

        return;
      }
      alert(context, gNochange);
    } catch (e) {
      print('======exception is ' + e.toString());
      //throw e;
      showMsg(context, e, null);
    }
  }

  fromBdckcolor(iColor) {
    if (iColor == null) {
      return Colors.white;
    }
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

  getActions(List param, context, int backcolor) {
    List<Widget> result = getLocalComponentsList(context, backcolor);

    if (param != null && param.length > 0) {
      for (int i = 0; i < param.length; i++) {
        //dynamic pi = _param[gActions][i];
        result.add(getMyItem(param[i], context, backcolor));
        /*if (pi[gType] == gIcon) {
          result.add(MyIcon(pi));
          
        }*/
      }
    }
    return result;
  }

  getActionIcons(_param, context, backcolor) {
    List<Widget> result = getLocalComponentsList(context, backcolor);

    if (_param[gActions] != null) {
      for (int i = 0; i < _param[gActions].length; i++) {
        Map pi = Map.of(_param[gActions][i]);
        Widget wi = getMyItem(pi, context, backcolor);
        result.add(wi);
      }
    }
    return result;
  }

  getButtons(param) {
    List<dynamic> list = param[gBtns];
    List<Widget> result = [];
    list.forEach((element) {
      result.add(MyButton(element));
    });
    return Column(children: result);
  }

  getCard(List data, context, param0, backcolor) {
    List<Widget> items = [];
    data.forEach((element) {
      Widget testWidget =
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        getCardTitle(element, backcolor),
        SizedBox(height: 5.0),
        Wrap(
          spacing: 8.0, //gap between adjacent items
          runSpacing: 4.0, //gap between lines
          direction: Axis.horizontal,
          children: getCardButtons(context, element, param0),
        )
      ]);

      items.add(testWidget);
    });

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(title: item);
      },
    );
  }

  getCardButtons(context, data, param0) {
    List<Widget> list = [];

    if (data[gType] == gProcess) {
      List detail = data[gDetail];
      dynamic params = {gType: gTab, gName: param0};
      list = getButtonsList(context, detail, data[gColorIndex], params);
    }
    return list;
  }

  getButtonsList(context, detail, colorIndex, params) {
    List<Widget> list = [];

    int colorIndex = -1;
    if (isNull(detail)) {
      return list;
    }
    detail.forEach((element) {
      colorIndex += 1;
      if (colorIndex >= _colorList.length) {
        colorIndex = 0;
      }
      element.putIfAbsent(gColor, () => _colorList[colorIndex]);
      element.putIfAbsent(gWidth, () => 140.0);
      element.putIfAbsent(gName, () => params[gName] ?? '');
      element.putIfAbsent(gType, () => params[gType] ?? '');
      /*element[gColor] = _colorList[colorIndex];
      element[gWidth] = element[gWidth] ?? 140.0;
      //element[gContext] = context;
      element[gName] = element[gName] ?? params[gName] ?? '';
      element[gType] = element[gType] ?? params[gType] ?? '';*/

      list.add(MyButton(element));

      /*list.add(Container(
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.all(5.0),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(_colorList[colorIndex]),
          /*boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 32.0,
              offset: Offset(0, 8.toDouble()),
            ),
          ],*/
        ),
        child: InkWell(
          child: MyLabel({
            gLabel: getSCurrent(element[gLabel]),
          }, _colorList[colorIndex]),
          onTap: () {
            element[gColorIndex] = colorIndex;
            if (params[gType] == gTab) {
              processTap(context, element, params[gName]);
            } else if (params[gAction] == gTable) {
              if (element[gLabel] == gAddnew) {
                element[gTableID] = params[gValue];
                tableAddNew(element, context);
              } else if (element[gLabel] == gPdf) {
                element[gTableID] = params[gValue];
                toPdf(element, context);
              }
            }
          },
        ),
      )
          

          );*/
    });

    return list;
  }

  getCardTitle(data, backcolor) {
    /*if (data[gType] == gProcess)
      return getTxtImage(
          data[gLabel], _colorList[data[gColorIndex]], 15.0, 2.0, 2.0);*/
    return MyLabel({
      gLabel: data[gLabel],
    }, backcolor);
  }

  getDetailBottom(param, context) {
    //add  bottomImages
    List<Widget> bottom = [];
    if (param[gBottomImgs] != null) {
      List bottomImages = param[gBottomImgs];

      for (int i = 0; i < bottomImages.length; i++) {
        Widget wi = MyPic(bottomImages[i]);

        bottom.add(wi);
      }
    }

    return Row(children: bottom);
  }

  getTitle(param, context, backcolor) {
    String aLabel = param[gLabel];
    if (aLabel == null) {
      if (param[gData] != null) {
        aLabel = param[gData][gLabel] ?? param[gData][gName];
      }
    }
    if (aLabel == null) {
      aLabel = "";
    }

    return MyLabel({
      gLabel: aLabel,
    }, backcolor);
  }

  getDetailWidget(param, context, backcolor) {
    List<Widget> result = [];

    if (param == null) {
      return result;
    }
    result.add(SizedBox(height: gDefaultPaddin));
    //title
    //double otherHeights = 0;
    //Widget title = getWidgetTitle(param);
    if (param[gTitle] != null) {
      if (param[gTitle][gHeight] != null) {
        //otherHeights += param[gTitle][gHeight];
      }

      result.add(Center(child: getWidgetTitle(param, backcolor)));
    }
    /*//add  bottomImages
    List<Widget> bottom = [];
    if (param[gBottomImgs] != null) {
      List bottomImages = param[gBottomImgs];

      for (int i = 0; i < bottomImages.length; i++) {
        if (bottomImages[i][gHeight] != null) {
          otherHeights += bottomImages[i][gHeight];
        }
        Widget wi = MyPic(bottomImages[i]);

        bottom.add(wi);
      }
    }

    double bodyheight =
        _sceenSize.height - bottom.length * 20 - 125 - otherHeights;
    if (bodyheight < 20) {
      bodyheight = 20;
    }*/
    //add body
    Widget body = getWidgetBody(param, context, backcolor);
    if (body != null) {
      result.add(SizedBox(height: gDefaultPaddin));
      result.add(Container(
        //height: bodyheight,
        child: Padding(
          padding: const EdgeInsets.all(gDefaultPaddin),
          child: body,
        ),
      ));
    }

    /*result.add(Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end, children: bottom)));*/
    return Column(children: result);
  }

  getDropdownMenuItem(tableid, filterStr, context, backcolor) {
    dynamic tabledata = getTableByTableID(tableid, null, context);
    if (tabledata == null) {
      return null;
    }
    List<String> result = [];
    result.add('');
    List tabledataList = tabledata[gData];
    tabledataList.forEach((element) {
      String value = element[gLabel];
      result.add(value);
    });

    return result.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: MyLabel({
          gLabel: value,
        }, backcolor),
      );
    }).toList();
  }

  getDynamicWidgets(List param, context, backcolor) {
    List<Widget> widgetList = [];
    param.forEach((element) {
      String type = element[gType];
      if (type == gTab) {
        widgetList.add(
          Container(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tabList[element[gData]][gData].length,
                itemBuilder: (context, index) =>
                    getTabByIndex(index, element[gData]),
              ),
            ),
          ),
        );
        double bodyheight = _sceenSize.height - 125.0;
        if (bodyheight < 20.0) {
          bodyheight = 20.0;
        }
        widgetList.add(
          SizedBox(
            height: bodyheight,
            child: getTabBody(element[gData], context, backcolor),
          ),
        );
      } else if (type == gLabel) {
        Widget widget = MyLabel({
          gLabel: element[gLabel],
          gFontSize: element[gFontSize],
          gColor: element[gColor]
        }, backcolor);
        if (element[gAlign] == gCenter) {
          widget = Center(child: widget);
        }

        widgetList.add(SizedBox(height: element[gHeight], child: widget));
      } else if (type == gButton) {
        Widget widget = MyButton({
          gLabel: element[gLabel],
          gFontSize: element[gFontSize],
          gColor: element[gColor]
        });
        widgetList.add(SizedBox(height: element[gHeight], child: widget));
        /*objList.add({
          gType: gButton,
          gHeight: 80.0,
          gAlign: gCenter,
          gLabel: gCharge,
          gFontSize: 40.0,
          gColor: Colors.white,
          gBackgroundColor: Colors.green
        });*/
      }
    });
    return widgetList;
  }

  getFormDefineImage(formValue) {
    return getTxtImage(
        formValue[gTitle][gLabel],
        _lastBackGroundColor,
        formValue[gTitle][gFontSize],
        formValue[gTitle][gHeight],
        formValue[gTitle][gLetterSpacing]);
  }

  getFormValue(formid, dbid, valueid) {
    Map<String, dynamic> formDetail = _formLists[formid];
    if (valueid == gTxtEditingController) {
      return formDetail[gItems][dbid][valueid].value.text;
    }
    return formDetail[gItems][dbid][valueid];
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
    /*if (iconname == gMenu) {
      return Icons.menu;
    } else if (iconname == gLogout) {
      return Icons.logout;
    } else if (iconname == gManageAccounts) {
      return Icons.person;
    }*/
    //return Icons.device_unknown;
    return IconData(iconname, fontFamily: 'MaterialIcons');
  }

  setForm(formName, context) {
    if (_formLists[formName] != null) {
      return;
    }
    try {
      sendRequestOne(
          gGetForm,
          {gFormid: formName, gCompany: _globalCompanyid, gEmail: _myId},
          context);
    } catch (e) {
      throw e;
    }
  }

  setImage(imgName, context) {
    if (_imgList[imgName] != null) {
      return;
    }
    try {
      sendRequestOne(gGetImageLink,
          {gImgID: imgName, gCompany: _globalCompanyid}, context);
    } catch (e) {
      throw e;
    }
  }

  getInputType(s) {
    if (s == gVisiblePassword) {
      return TextInputType.visiblePassword;
    } else if (s == gEmailAddress) {
      return TextInputType.emailAddress;
    } else if (s == gDatetime) {
      return TextInputType.datetime;
    } else if (s == gLabel) {
      return;
    } else if (s == gMultiline) {
      return TextInputType.multiline;
    } else if (s == gName) {
      return TextInputType.name;
    } else if (s == gNumber) {
      return TextInputType.number;
    } else if (s == gPhone) {
      return TextInputType.phone;
    } else if (s == gStreetAddress) {
      return TextInputType.streetAddress;
    } else if (s == gUrl) {
      return TextInputType.url;
    } else if (s == gValues) {
      return TextInputType.values;
    }

    return TextInputType.text;
  }

  getLocalComponents(context, aColor) {
    return Row(children: getLocalComponentsList(context, aColor));
  }

  getLocalComponentsList(context, valueColor) {
    return [
      Icon(Icons.public_outlined),
      //(_locale.languageCode == 'en')
      (_locale == 'en')
          ? TextButton(
              child: Text('中文',
                  style: TextStyle(color: fromBdckcolor(valueColor))),
              //style: TextStyle(color: Colors.white)),
              onPressed: () {
                //setLocale(Locale('zh'));
                setLocale('zh');
              },
            )
          : TextButton(
              child: Text('EN',
                  style: TextStyle(color: fromBdckcolor(valueColor))),
              //style: TextStyle(color: Colors.white)),
              onPressed: () {
                //setLocale(Locale('en'));
                setLocale('en');
              },
            ),
      isNull(_myId)
          ? Text("")
          : MyIcon({
              gValue: 0xf199,
              gLabel: gLogout,
              gAction: gLocalAction,
            })
    ];
  }

  getMenuItems(String menuName, context, backcolor) {
    List<Widget> items = [];

    /*for (int i = 0; i < _menuLists[menuName].length; i++) {
      items.add(Text(getSCurrent(_menuLists[menuName][i][gLabel])));
    }*/
    if (_menuLists[menuName] == null) {
      return items;
    }
    _menuLists[menuName].forEach((element) {
      //items.add(Text(getSCurrent(map[gLabel])));
      if (element[gType] == gDivider) {
        items.add(Divider());
      } else {
        items.add(ListTile(
          leading: Icon(getIconsByName(element[gIcon])),
          title: Text(getSCurrent(element[
              gLabel])), //MyLabel({gLabel: map[gLabel] + '', gFontSize: 20.0}),
          onTap: () {
            onTap(context, element, backcolor);
          },
          //onTap: datamodel.onTap(context, map),
        ));
      }
    });
    return items;
  }

  getMenuListLabel() {
    return _menuLists[gMain][0][gLabel];
  }

  getMod(source, exponent, divider) {
    num rtn = 1;
    for (var i = 0; i < exponent; i++) {
      rtn *= source;
      rtn = rtn % divider;
    }
    return rtn;
  }

  getMyBody(name) {
    if (name == gMain) {
      if (initRequest == '') {
        List objList = [];
        objList.add({gType: gTab, gData: name});
        //return MyDynamicBody(objList);

        //return MyTab(gMain);
      }
    }
    //return businessMyBody(name);
    return null;
  }

  getParamTypeValue(param) {
    if (param == null) {
      param = {gType: gTitle};
    }
    param[param[gType]] = param[gValue];

    return param;
  }

  int _picIndex = 0;
  getPics(param, backcolor) {
    List<dynamic> list = param[gPics];
    if (_picIndex >= list.length) {
      _picIndex = 0;
    }

    List<Widget> result = [];
    result.add(Expanded(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        MyPic(list[_picIndex]),
        SizedBox(width: gDefaultPaddin),
        MyLabel(list[_picIndex], backcolor),
      ]),
    ));
    List<Widget> dotList = [];
    for (int i = 0; i < list.length; i++) {
      dotList.add(Material(
        child: InkWell(
          onTap: () {
            _picIndex = i;
            myNotifyListeners();
          },
          child: MyPic(
              {gImg: _imgList[((i == _picIndex) ? 'bright' : 'dark') + 'dot']}),
          /*Image.asset(
                '/images/' + ((i == _picIndex) ? 'bright' : 'dark') + 'dot.png',
                package: packageName)*/
        ),
      ));
    }
    result.add(
        Row(mainAxisAlignment: MainAxisAlignment.center, children: dotList));
    return result;
  }

  getRadios(param, context, _backcolor) {
    List list = param;
    /*if (_picIndex >= list.length) {
      _picIndex = 0;
    }*/

    List<Widget> result = [];
    for (int i = 0; i < list.length; i++) {
      result.add(getMyItem(list[i], context, _backcolor));
    }

    /*
    result.add(getMyItem(list[_picIndex], context));
    List<Widget> dotList = [];
    for (int i = 0; i < list.length; i++) {
      dotList.add(SizedBox(width: 20));
      dotList.add(Material(
        child: Container(
          width: 24.0,
          height: 24.0,
          margin: EdgeInsets.all(5.0),
          padding: EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFF356C95)),
            //color: Colors.transparent,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: (i == _picIndex) ? Colors.yellow : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
          //color: Colors.transparent,
          //margin: EdgeInsets.all(15.0),
          /*child: getMyItem({
            gType: gImg,
            gValue: ((i == _picIndex) ? 'bright' : 'dark') + 'dot'
          }, context),*/
        ),
      ));
    }
    result.add(
        Row(mainAxisAlignment: MainAxisAlignment.center, children: dotList));*/
    return result;
  }

  getRowsPerPage(tableInfo) {
    if (tableInfo[gRowsPerPage] == null) {
      tableInfo[gRowsPerPage] = 15;
    }
    return tableInfo[gRowsPerPage];
  }

  setRowsPerPage(tableInfo, cnt) {
    tableInfo[gRowsPerPage] = cnt;
    myNotifyListeners();
  }

  getScreenItem(Map mItemDetail, context, int backcolor) {
    Widget result;

    mItemDetail.forEach((key, value) {
      if (key != gItems && key != gItem) {
        return null;
      }
      Map valueMap = Map.of(jsonDecode(value));
      if (key == gItems) {
        //return result;
        //"{"radios":[{"type":"img","value": "image0","label": "Earn Instant Cashback","fontSize": 20.0,"height": 30.0}, {"type":"img","value": "image1","label": "Build Credit with ease","fontSize": 20.0,"height": 30.0}, {"type":"img","value":"image2","label": "Welcome","fontSize": 20.0,"height": 30.0}]}"

        valueMap.forEach((key1, value1) {
          if (key1 == gRadios) {
            List listValue1 = value1;
            List listValueNew = [];

            listValue1.forEach((data0) {
              listValueNew.add(Map.of(data0));
            });

            result = Radios(listValueNew, backcolor);
          }
        });
      } else if (key == gItem) {
        result = getMyItem(valueMap, context, backcolor);
      }
    });
    return result;
  }

  getScreenItems(param, context, int backcolor) {
    List<Widget> result = [];
    result.add(SizedBox(height: 4.5));
    //Map map = Map.of(param[gItems]);
    Map map = Map.of(param);
    map.forEach((key, value) {
      Map mapItem = Map.of(value);
      Widget itemWidget = getScreenItem(mapItem, context, backcolor);
      if (itemWidget != null) {
        //result.add(SizedBox(height: 0.5));
        result.add(itemWidget);
      }
    });
    return result;
    /*return [
      //Expanded(child: PicsAndLabels(param)),
      SizedBox(height: 120),
      MyLabel(getParamTypeValue(param[gTitle])),
      SizedBox(height: 150),
      getButtons(Map.of(param)),
      SizedBox(height: gDefaultPaddin),
    ];*/
  }

  getScreenItemsList(List param, context, backcolor) {
    List<Widget> result = [];
    //Map map = Map.of(param[gItems]);
    for (int i = 0; i < param.length; i++) {
      Map pi = param[i];
      Widget wi = getMyItem(pi, context, backcolor);
      result.add(wi);
    }
    return result;
  }

  getMyItem(valueMap, context, backcolor) {
    if (valueMap[gType] == gImg) {
      dynamic imageValue = _imgList[valueMap[gValue]];
      if (imageValue == null) {
        setImage(valueMap[gValue], context);
      }

      //valueMap[gValue] = _imgList[valueMap[gValue]] ?? _imgList[gNotavailable];
    } else if (valueMap[gType] == gForm) {
      dynamic form = _formLists[valueMap[gValue]];
      if (form == null) {
        setForm(valueMap[gValue], context);
        //getTableByTableID(valueMap[gValue], null, context);
      }

      //valueMap[gValue] = _imgList[valueMap[gValue]] ?? _imgList[gNotavailable];
    }
    Widget result = MyItem(valueMap, backcolor);
    return result;
  }

  getSCurrent(dynamic sourceOriginal) {
    return getSCurrentLan(sourceOriginal, _locale);
  }

  getSCurrentLan(dynamic sourceOriginal, lancode) {
    String source0 = sourceOriginal + "";
    String sourceLocase = source0.toLowerCase();
    String source = sourceLocase;
    String sourceChck = source;
    if (sourceChck.indexOf("{") > 0) {
      sourceChck = sourceChck.substring(0, sourceChck.indexOf("{"));
    }
    if (_i10nMap[sourceChck] != null) {
      String result = _i10nMap[sourceChck][lancode];
      if (result != null) {
        while ((result.indexOf('}') > 0 && result.indexOf('{') >= 0)) {
          String result0 = result.substring(0, result.indexOf('{'));

          String resultMid = "";
          if (source.indexOf('{') > -1 &&
              source.indexOf('}') > -1 &&
              source.indexOf('}') > source.indexOf('{')) {
            resultMid =
                source.substring(source.indexOf('{') + 1, source.indexOf('}'));
          }

          String result1 = result.substring(result.indexOf('}') + 1);

          result = result0 + getSCurrent(resultMid) + result1;
          source = source.substring(source.indexOf('}') + 1);
        }

        if (sourceLocase == result.toLowerCase()) {
          return source0;
        } else if (sourceLocase != source0 && lancode == 'en') {
          //upper case
          return result.substring(0, 1).toUpperCase() + result.substring(1);
        }
        return result;
      }
    } else if (source.indexOf(" ") > -1) {
      String s0 = source0.substring(0, source.indexOf(" "));
      String s1 = source0.substring(source.indexOf(" ") + 1);
      String s0Result = getSCurrent(s0);
      String s1Result = getSCurrent(s1);
      String delimiter = ' ';
      if (lancode == 'zh') {
        if (s0 != s0Result && s1 != s1Result) {
          delimiter = '';
        }
      }

      return s0Result + delimiter + s1Result;
    }
    return source0;
  }

  getTab(tabname, context) {
    if (_tabList[tabname] != null) {
      return _tabList[tabname];
    }
    try {
      sendRequestOne(gGetTab,
          {gId: tabname, gCompany: _globalCompanyid, gEmail: _myId}, context);
    } catch (e) {
      throw e;
    }
  }

  getTabBody(tabname, context, backcolor) {
    if (_tabList[tabname] == null) {
      return Text(gNotavailable);
    }
    dynamic data = _tabList[tabname][gData][_tabList[tabname][gTabIndex]];
    if (!(data[gVisible] ?? true)) {
      return null;
    }
    if (data[gType] == gCard) {
      return getCard(data[gBody], context, tabname, backcolor);
    } else if (data[gType].toString().endsWith(gTable)) {
      //String tableName = data[gActionid];
      data[gTabName] = tabname;
      return getTableBody(data, context, backcolor);
      /*return Column(
        children: [
          Expanded(
            child: MyPaginatedDataTable({gName: tableName}),
          ),
        ],
      );*/
    } else if (data[gType] == gTabletree) {
      //String tableName = data[gActionid];
      setTreeNode(data, context);
      return getTreeBody(data, context, backcolor);
    }

    return Text(data[gType] + ' will be available soon');
  }

  getTabIndex(label, context, tabName) {
    for (int i = 0; i < _tabList[tabName][gData].length; i++) {
      if (_tabList[tabName][gData][i][gLabel] == label) {
        return i;
      }
    }
    return -1;
  }

  getTabByIndex(int index, tabName) {
    List<Widget> titleWidgets = [];
    var dataThis = _tabList[tabName][gData][index];
    if (!(dataThis[gVisible] ?? true)) {
      return null;
    }
    titleWidgets.add(Text(getSCurrent(dataThis[gLabel]),
        style: TextStyle(
            fontSize: 24.0,
            fontWeight: index == _tabList[tabName][gTabIndex]
                ? FontWeight.bold
                : FontWeight.normal,
            color: index == _tabList[tabName][gTabIndex]
                ? Colors.white
                : Colors.black)));
    if ((dataThis[gCanRefresh] ?? "true") != "false") {
      titleWidgets.add(MyIcon({
        gValue: 0xf2f7,
        gLabel: gRefresh,
        gColor: Colors.green,
        gAction: gLocalAction,
        gTabIndex: index,
        gTabName: tabName
      }));
    }
    if ((dataThis[gCanClose] ?? "true") != "false") {
      titleWidgets.add(MyIcon({
        gValue: 63467,
        gLabel: gRemove,
        gColor: Colors.green,
        gAction: gLocalAction,
        gTabIndex: index,
        gTabName: tabName
      }));
    }

    return GestureDetector(
      onTap: () {
        _tabList[tabName][gTabIndex] = index;
        //_tabIndex = index;
        myNotifyListeners();
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: titleWidgets,
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0 / 4),
                height: 2.0,
                width: 30.0,
                color: index == _tabList[tabName][gTabIndex]
                    ? Colors.black
                    : Colors.transparent,
              ),
            ],
          )),
    );
  }

  getTableByIndex(int index, tableid) {
    dynamic tableData = _tableList[tableid][gData][index];
    return tableData;
  }

  getTableByTableID(tableid, where, context) {
    dynamic tableData = _tableList[tableid] ?? null;
    if (tableData == null) {
      getTableFromDB(tableid, where, context);
    }
    if (where ?? null == null) {
      return tableData;
    }
    return getTableDataFromWhere(tableData, where);
  }

  getTableDataFromWhere(tableData, where) {
    //filter the table data by where condition
  }
  getTableFromDB(tableid, where, context) {
    Map element = {
      gLabel: '',
      gType: gTable,
      gActionid: tableid,
      gWhere: "",
      gColorIndex: 0
    };
    sendRequestOne(gProcess, [element], context);
  }

  getTableItemByName(tableInfo, itemName, value) {
    MapEntry item = MapEntry(itemName, {
      gWidth: 150.0,
      gType: itemName,
      gLabel: itemName,
      gFocus: false,
      gValue: value,
      gInputType: getInputType(itemName),
      gTxtEditingController: TextEditingController(text: value)
    });

    return item;
  }

  getTreeNodesFromTable(tableName, context, level) {
    /*List<Node> nodes = [];
    if (tableName == null || _tableList[tableName] == null) {
      return nodes;
    }
    Map table = _tableList[tableName];
    if (table[gData] == null) {
      return nodes;
    }

    List tableData = table[gData];
    dynamic icon = Icons.folder;
    dynamic color = Colors.black;
    if (level == 1) {
      icon = Icons.input;
      color = Colors.red;
    } else if (level == 2) {
      icon = Icons.insert_drive_file;
    }

    tableData.forEach((element) {
      Node aNode = Node(
        label: getSCurrent(element[gLabel]),
        key: element[gDbname],
        icon: icon,
        iconColor: color,
        children:
            getTreeNodesFromTable(element[gDetail] ?? null, context, level + 1),
      );
      nodes.add(aNode);
    });
    return nodes;

    */
  }

  getTreeBody(data, context, backcolor) {
    return Column(
      children: [
        Expanded(child: MyLabel({gLabel: gWelcome, gFontSize: 20.0}, backcolor)

            //MyTree({gData: data, gAction: gLocalAction, gContext: context}),
            ),
      ],
    );
  }

  getTableBody(data, context, backcolor) {
    return MyScreen(getTableBodyParam(data, context), backcolor);
  }

  getTableBodyParam(data, context) {
    //_tableList[tableName][gKey] = UniqueKey();
    String tableName = data[gActionid] ?? data[gTableID];
    //String tableName = _param[gData][gActionid] ?? _param[gData][gTableID];

    Map tableInfo = _tableList[tableName];
    //List tableData = tableInfo[gData];
    //List columns = tableInfo[gColumns];

    Map param = {};
    int index = 0;
    param[index++] = {
      gItem: jsonEncode({
        gType: gSearch,
        gAction: gLocalAction,
        gTableID: tableName,
        gLabel: gSearch,
      })
    };
    List detail = [];

    if (tableInfo[gAttr][gCanEdit]) {
      detail.add({gLabel: gAddnew, gTableID: tableName, gWidth: 100});
    }
    detail.add({gLabel: gPdf, gTableID: tableName, gWidth: 60});
    detail.add({gLabel: gExcel, gTableID: tableName, gWidth: 60});
    param[index++] = {
      gItem: jsonEncode(
          {gType: gBtns, gAction: gTable, gValue: tableName, gItems: detail})
    };

    param[index++] = {
      gItem: jsonEncode({gType: gTableEditor, gName: tableName})
    };
/*return Column(
        children: [
          Expanded(
            child: MyPaginatedDataTable({gName: tableName}),
          ),
        ],
      );*/
    return param;
    //return MyPaginatedDataTable({gData: data});
    /*return Column(
      children: [
        Expanded(
          child: MyPaginatedDataTable({gData: data}),
        ),
      ],
    );*/
  }

  /*getTabItems() {
    List<Widget> items = [];
    _tabList.forEach((element) {
      items.add(Tab(
        text: getSCurrent(element[gLabel]),
      ));
    });
    return items;
  }

  getTabItemBodys(context) {
    List<Widget> items = [];
    _tabList.forEach((element) {
      items.add(getTabBody(element, context));
    });
    return items;
  }*/
  //getTableValue(tableId, row, colid) {
  getTableValue(row, colid) {
    //var table = _tableList[tableId];

    //var result = table[gData][row][colid];
    var result = row[colid];

    return result;
  }

  getTableValueAttr(tableId, attrName) {
    var table = _tableList[tableId];

    var result = table[gAttr][attrName];

    return result;
  }

  getTableKeyword(tableId, dataid, context) {
    var table = _tableList[tableId] ?? null;
    if (table == null) {
      retrieveTableFromDB(tableId, context);

      return dataid;
    }
    var dataRow = getTableIDMap(table)[dataid];
    if (dataRow == null) {
      return dataid;
    }
    return getTableValueKeyFromTable(table, dataRow);
  }

  getTableIDMap(table) {
    if (table != null && table[gDataIDMap] != null) {
      return table[gDataIDMap];
    }
    Map dataIDMap = {};
    for (int i = 0; i < table[gData].length; i++) {
      var dataRow = table[gData][i];
      dataIDMap[dataRow[gId]] = dataRow;
    }
    table[gDataIDMap] = dataIDMap;

    return dataIDMap;
  }

  getTableCellValueFromTable(tableName, colIndex, rowIndex, context) {
    List data = tableList[tableName][gData];
    List columns = tableList[tableName][gColumns];
    return getTableCellValueFromData(
        data, columns, colIndex, rowIndex, context);
  }

  getTableCellValueFromData(data, columns, colIndex, rowIndex, context) {
    var dataRow = data[rowIndex];
    return getTableCellValueFromDataRow(dataRow, columns, colIndex, context);
  }

  getTableCellValueFromDataRow(dataRow, columns, colIndex, context) {
    String colName = columns[colIndex][gId];
    var result = dataRow[colName];
    if (isNull(result)) {
      return result;
    }
    String inputType = columns[colIndex][gInputType];

    if (inputType == gDatetime) {
      return toLocalTime(result);
    }
    String droplist = columns[colIndex][gDroplist];
    if (!isNull(droplist)) {
      //getTableValueKeyFromColumns(columns, dataRow)
      return getTableKeyword(droplist, result, context);
    }
    return result;
  }

  getTableRowShowValue(item, colList, context) {
    return getTableRowShowValueFilter(item, colList, context, null);
  }

  getTableRowShowValueFilter(item, colList, context, filterValue) {
    return getTableRowShowValueFilterMapOrList(
        item, colList, context, filterValue, true);
  }

  getTableRowShowValueFilterMapOrList(
      item, colList, context, filterValue, mapOrList) {
    String filterValueLower = filterValue.toString().toLowerCase();
    Map result = {};
    List resultList = [];

    if (colList == null || colList.length < 1) {
      return item;
    }
    bool filterValueExists = false;
    if (isNull(filterValue)) {
      filterValueExists = true;
    }
    for (int i = 0; i < colList.length; i++) {
      var ci = colList[i];
      var colIndex = i;
      if (!isNull(item[ci[gId]])) {
        var oneValue =
            getTableCellValueFromDataRow(item, colList, colIndex, context) ??
                '';
        result[ci[gId]] = oneValue;
        if (!isHiddenColumn(colList, i)) {
          resultList.add(oneValue);
        }
        if (!filterValueExists) {
          if (!isHiddenColumn(colList, i)) {
            if (!isNull(result[ci[gId]]) &&
                result[ci[gId]]
                    .toString()
                    .toLowerCase()
                    .contains(filterValueLower)) {
              filterValueExists = true;
            }
          }
        }
      }
    }
    if (!filterValueExists) {
      return null;
    }
    if (mapOrList) {
      return result;
    }
    return resultList;
  }

  getTableRowShowValueByTablename(item, tablename, context) {
    Map tableInfo = _tableList[tablename];
    List colList = tableInfo[gColumns];
    return getTableRowShowValue(item, colList, context);
  }

  getTableValueKey(tableid, dataRow) {
    var table = _tableList[tableid];
    return getTableValueKeyFromTable(table, dataRow);
  }

  getTableValueKeyFromTable(table, dataRow) {
    //var data = table[gData][row];
    List columns = table[gColumns];
    return getTableValueKeyFromColumns(columns, dataRow);
  }

  getTableValueKeyFromColumns(columns, dataRow) {
    var result = "";
    var sep = "";
    if (dataRow == null) {
      result = gAddnew;
      return result;
    }
    columns.forEach((element) {
      if ((element[gIsKeyword] ?? false)) {
        var value = dataRow[element[gId]];
        if (!isNull(value)) {
          result += sep + dataRow[element[gId]];
          sep = ",";
        }
      }
    });
    return result;
  }

  getTableValuePrimary(tableId, data) {
    var table = _tableList[tableId];

    //var data = table[gData][row];
    List columns = table[gColumns];
    var result = "";
    var sep = "";
    columns.forEach((element) {
      if ((element[gIsPrimary] ?? false)) {
        result += sep + data[element[gId]];
        sep = ",";
      }
    });
    return result;
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

  getWidgetBody(param, context, backcolor) {
    if (param[gType] == gForm) {
      return getWidgetForm(param, backcolor);
    } else if (param[gType].toString().endsWith(gTable)) {
      return getTableBody(param, context, backcolor);
    } else if (param[gType] == gScreen) {
      return MyScreen(param, backcolor);
    }
    return Column(
      children: [
        MyLabel({gLabel: gWelcome, gFontSize: 20.0}, backcolor)
      ],
    );
  }

  getWidgetForm(param, backcolor) {
    String formID = param[gFormdetail][gFormName];

    setFormListOne(formID, param);
    /*int index = -1;
    if (param[gIndex] != null) {
      index = param[gIndex];
    }*/
    return MyForm(formID, backcolor);
  }

  getWidgetTitle(param, backcolor) {
    Widget title;
    param[gTitle] = getParamTypeValue(param[gTitle]);
    if (param[gTitle][gType] == gLabel) {
      title = MyLabel(param[gTitle], backcolor);
    } else if (param[gTitle][gType] == gIcon) {
      title = MyIcon(param[gTitle]);
    } else if (param[gTitle][gType] == gImg) {
      title = MyPic(param[gTitle]);

      //MyImg(getParamTypeValue(param[gTitle]));
    } else {
      title = MyLabel({gLabel: param[gTitle][gTitle]}, backcolor);
    }
    return title;
  }

  String hash(str) {
    var bytes1 = utf8.encode(str); // data being hashed
    var digest1 = sha256.convert(bytes1); // Hashing Process
    return digest1.toString();
  }

  isHiddenColumn(columns, i) {
    if (columns[i][gInputType] == gHidden) {
      return true;
    }
    return false;
  }

  /*initPaginateDataTable(tableName, actionBtnCnts, tabledata, columns){

    
    Map tableInfo = _tableList[tableName];
     PaginatedDataTable pageBody = PaginatedDataTable(
        //header: MyLabel(data),
        initialFirstRowIndex: 0,
        rowsPerPage: 5,
        availableRowsPerPage: [5, 10, 20, 50],
        onPageChanged: (e) {},
        onRowsPerPageChanged: (int v) {
          //widget.onRowsPerPageChanged?.call(v ?? 10);
        },
        columns: columns,
        columnSpacing: 30,
        horizontalMargin: 5,
        source: tabledata,
        showCheckboxColumn: true,
        sortAscending: tableInfo[gAscending],
        sortColumnIndex: tableInfo[gSortColumnIndex] + actionBtnCnts,
      );
  
  }*/
  isNull(aValue) {
    if (aValue == null || aValue == '' || aValue == gNull) {
      return true;
    }
    return false;
  }

  toLocalTime(atime) {
    try {
      //return DateTime.fromMillisecondsSinceEpoch(int.parse('1639181163816'))
      //  .toLocal();
      DateTime dt =
          DateTime.fromMillisecondsSinceEpoch(int.parse(atime)).toLocal();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
      return formattedDate;
      //return DateTime.fromMillisecondsSinceEpoch(int.parse(atime)).toLocal();
      /*DateTime _nowDate = DateTime.now();
      return DateTime.fromMillisecondsSinceEpoch(
              _nowDate.millisecondsSinceEpoch)
          .toLocal();*/

    } catch (e) {
      return "";
    }
  }

  toUTCTime(adate) {
    try {
      return DateTime.parse(adate).millisecondsSinceEpoch;
      //return DateTime.parse('2021-12-10 16:06:03').millisecondsSinceEpoch;

    } catch (e) {
      DateTime _nowDate = DateTime.now();
      return _nowDate.millisecondsSinceEpoch;
    }
  }

  initTableData(tableid, context) {
    /*Map tableInfo = _tableList[tableid];
    List tableData = tableInfo[gData];
    List colList = tableInfo[gColumns];
    if (colList != null && colList.length > 0) {
      for (int i = 0; i < colList.length; i++) {
        var ci = colList[i];
        var colIndex = i;
        for (Map item in tableData) {
          if (item[ci[gId]] != null && item[ci[gId]] != '') {
            item[ci[gId]] =
                getTableCellValueFromDataRow(item, colList, colIndex, context);
          }
        }
      }
    }*/
  }

  localAction(requestFirst, context) {
    Map data;
    try {
      data = requestFirst[gData];
    } catch (e) {
      MapEntry me = requestFirst[gData];
      data = me.value;
    }

    if (data[gLabel] != null &&
        data[gLabel] == gEdit &&
        data[gTableID] != null) {
      //var tableId = data[gTableID];
      //int index = data[gRow];
      showFormEdit(data, context);
      showTableForm(data, context, null);
    } else if (data[gLabel] != null &&
        data[gLabel] == gAddnew &&
        data[gTableID] != null) {
      tableAddNew(data, context);
    } else if (data[gLabel] != null &&
        data[gLabel] == gPdf &&
        data[gTableID] != null) {
      toPdf(data, context);
    } else if (data[gLabel] != null &&
        data[gLabel] == gExcel &&
        data[gTableID] != null) {
      toExcel(data, context);
    } else if (data[gLabel] != null &&
        data[gLabel] == gDelete &&
        data[gTableID] != null) {
      var tableId = data[gTableID];
      Map rowData = data[gRow];
      var keyValue = getTableValueKey(tableId, rowData);
      data[gLabel] = gSureDelete;
      showAlertDialog(context, gAlert,
          gRemove + " [" + keyValue + "], areyousure ?", requestFirst);
      //);

      return;
    } else if (data[gLabel] != null &&
        data[gLabel] == gSureDelete &&
        data[gTableID] != null) {
      deleteTableOne(data, context);
      /*int row = data[gRow];
      //popup confirm dialog
      //show delete confirm dialog, and send delete request.
      var dataDelete = {};
      dataDelete[gFormid] = data[gTableID];
      dataDelete[gId] = _tableList[data[gTableID]][gData][row][gId];
      sendRequestOne('formchange', [dataDelete], context);*/
    } else if (data[gLabel] != null &&
        data[gLabel] == gDetail &&
        data[gTableID] != null) {
      var tableId = data[gTableID];
      Map rowData = Map.of(data[gRow]);
      var primaryValue = getTableValueKey(tableId, rowData);
      var transpass = '';
      if (data[gTranspass] != null) {
        transpass = data[gTranspass];
      }
      //{gAction: gProcess,gData:[{gLabel:"",gType:gTable,gActionid:"Zzyimage","colorIndex":0}],"token":"89345dd3-f653-48a3-b7c1-b2d4af8728c1","companyid":"smilesmart"}
      Map element = {
        gLabel: gDetail +
            " for " +
            getTableValueAttr(tableId, gLabel) +
            " [ " +
            primaryValue +
            " ]",
        gType: gTable,
        gActionid: getTableValueAttr(tableId, gDetail),
        gWhere: gParentid + "='" + getTableValue(rowData, gId) + "'",
        gColorIndex: 0,
        gTranspass: transpass
      };
      sendRequestOne(gProcess, [element], context);
      //show delete confirm dialog, and send delete request.
      //open detail
      //sendRequestOne('formchange', [dataDelete], context);
    } else if (data[gLabel] != null &&
        data[gLabel] == gRemove &&
        data[gTabIndex] != null &&
        data[gTabName] != null) {
      //remove tab
      deleteTabOne(data[gTabName], data[gTabIndex]);
    } else if (data[gLabel] != null &&
        data[gLabel] == gRefresh &&
        data[gTabIndex] != null &&
        data[gTabName] != null) {
      sendRequestOne(
          gProcess,
          [
            {
              gLabel: _tabList[data[gTabName]][gData][data[gTabIndex]][gLabel],
              gType: _tabList[data[gTabName]][gData][data[gTabIndex]][gType],
              gActionid: _tabList[data[gTabName]][gData][data[gTabIndex]]
                  [gActionid],
              gColorIndex: 0
            }
          ],
          context);
    } else if (data[gLabel] != null &&
        data[gLabel] == gTreeExpand &&
        data[gValue] != null &&
        data[gMove] != null) {
      //bool expanded = data[gMove];
      //String key = data[gValue];
    } else if (data[gLabel] != null &&
        data[gLabel] == gTreeSelected &&
        data[gValue] != null) {
      if (data[gData] != null && data[gData][gType] != null) {
        if (data[gData][gType] == gTabletree) {
          String tableid = data[gValue] ?? '';
          if (tableid != '') {
            //show table
            Map element = {
              gLabel: data[gTreeLabel],
              gType: gTable,
              gActionid: tableid,
              gWhere: "",
              gColorIndex: 0
            };
            sendRequestOne(gProcess, [element], context);
          }
        }
      }
    } else if (data[gLabel] != null &&
        data[gLabel] == gSearch &&
        data[gTableID] != null) {
      searchTable(data, context);
    } else if (data[gLabel] != null && data[gLabel] == gLogout) {
      logOff(context);
    } else if (data[gAction] == gTextLink) {
      businessFunc(data[gAction1], context);

      //forgetpassword(context);
    }
  }

  businessFunc(funcName, context) {
    if (funcName == "forgetpassword") {
      forgetpassword(context);
    }
  }

  logOff(context) {
    clear(context);

    myNotifyListeners();
  }

  onTap(context, Map map, backcolor) {
    try {
      if (map[gType] == gAction) {
        if (map[gActionid] == gLogout) {
          logOff(context);
        } else if (map[gActionid] == gChangepassword) {
          changePassword(context, null, backcolor);
        } else if (map[gActionid] == gRole) {}
      } else if (map[gType].toString().endsWith(gTable)) {
        var tableid = map[gActionid];
        _lastBackGroundColor = _defaultBackGroundColor;

        showTable(tableid, context, map[gLabel] ?? "", "", backcolor);
      }
    } catch (e) {
      showMsg(context, e, null);
    }
    if (map[gLabel] == "Test") {
      //showTab("role", context);
    }
    print('=====typed ' + map[gLabel]);
  }

  openDetailForm(formname, context, backcolor) {
    Map param = {
      gsBackgroundColor: _formLists[formname][gsBackgroundColor],
      gColor: _formLists[formname][gColor],
      gName: formname,
      gType: gForm
    };
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyDetailNew(param, backcolor)));
  }

  processRequest(dataRequest, context) async {
    final headers = {
      'contentType':
          'text/html,application/xhtml+xml,application/xml,application/x-www-form-urlencoded',
      'accept-language': 'en-US,en'
    };

    //dynamic url = MyConfig.URL.name + 'smilesmart';
    Uri uri = new Uri.http(MyConfig.URL.name, MyConfig.PROJ.name);
    http.Response response;
    try {
      response =
          // ignore: return_of_invalid_type_from_catch_error
          await httpClient
              .post(uri, headers: headers, body: dataRequest)
              .catchError((error) {
        //ShowToast.warning(error.toString());
        throw (error);
      });

      if (response.statusCode != 200) {
        throw Exception(getSCurrent(
            "serverwrongcode(${response.statusCode}, ${response.body.toString()})"));
      }
      Utf8Decoder decode = new Utf8Decoder();
      List data = jsonDecode(decode.convert(response.bodyBytes));
      print('==== response: ' + jsonEncode(data));
      /*Utf8Decoder decode = new Utf8Decoder();
      List data = jsonDecode(decode.convert(response.bodyBytes));*/
      //List data = jsonDecode(response.body);

      //print(data.entries.first.key);
      //print(data.entries.first.value);

      data.forEach((element) async {
        //print(key);
        var action = '';
        List actionData = [];
        element.forEach((key, value) {
          if (key == gAction) {
            action = value;
          } else if (key == gData) {
            actionData = value;
          }
        });
        if (action == gChangepassword) {
          await changePassword(context, actionData, null);
        } else if (action == gFinishme) {
          await finishme(context);
        } else if (action == gProcessTab) {
          await processTab(actionData, context);
        } else if (action == gProcessTableSave) {
          await processTableSave(actionData, context);
        } else if (action == gRemoveAllScreens) {
          await removeAllScreens(context);
        } else if (action == 'removeLastScreens') {
          await removeLastScreens(context);
        } else if (action == gResetpassword) {
          await resetPassword(context, actionData);
        } else if (action == gSetImgList) {
          await setImgList(actionData);
        } else if (action == 'setMyAction') {
          await setMyAction(actionData);
        } else if (action == gSetMyInfo) {
          await setMyInfo(actionData[0], context);
        } else if (action == gSetMyMenu) {
          await setMyMenu(actionData);
        } else if (action == gSetMyTab) {
          await setMyTab(actionData);
        } else if (action == gSetI10n) {
          await setI10n(actionData);
        } else if (action == 'setInitForm') {
          await setInitForm(actionData);
        } else if (action == gSetSessionkey) {
          await setSessionkey(actionData[0]['key']);
        } else if (action == gSetTableList) {
          await setTableList(actionData, context);
        } else if (action == gShowErr) {
          actionData[0] = Map.of(actionData[0]);
          showMsg(context, actionData[0]['errMsg'], null);
          //throw actionData[0]['errMsg'];
        } else if (action == gShowExcel) {
          await showPDF(actionData, context);
        } else if (action == gShowpdf) {
          await showPDF(actionData, context);
        } else if (action == gShowScreenPage) {
          await showScreenPage(actionData, context, Colors.black.value);
        } else if (action == gSetFormList) {
          await setFormList(actionData);
        } else if (action == gShowTable) {
          await showTable(actionData[0][gTableID], context,
              actionData[0][gLabel] ?? "", "", null);
        }
      });
    } catch (e) {
      throw e;
    }
  }

  processTab(List data, context) {
    data.forEach((data0) {
      data0 = Map.of(data0);
      if (data0[gType].toString().endsWith(gTable) ||
          data0[gType] == gTabletree) {
        addTable(data0, context);
        if (data0[gWhere] != null && data0[gWhere].indexOf("=") > 0) {
          showTable(data0[gActionid], context, data0[gLabel], data0[gTranspass],
              null);
          return;
        }
      }
      addTab(data0, context, data0[gParam0]);
    });

    myNotifyListeners();
  }

  processTableSave(List data, context) {
    data.forEach((data0) {
      data0 = Map.of(data0);
      saveTableOne(data0, context);
    });

    //myNotifyListeners();
  }

  processTap(context, element, tabName) {
    _tabList[tabName][gData].forEach((el) {
      if (el[gLabel] == element[gLabel]) {
        showTab(el[gLabel], context, tabName);
        return;
      }
    });
    sendRequestOne(gProcess, [element], context);
  }

  refreshTab(data, context, tabName) {
    int tabIndex = getTabIndex(data[gLabel], context, tabName);
    if (tabIndex > -1) {
      _tabList[tabName][gData][tabIndex] = {
        gLabel: data[gLabel],
        gType: data[gType],
        gActionid: data[gActionid]
      };
    } else {
      addTabSub(data, tabName);
    }
    myNotifyListeners();
  }

  removeAllScreens(context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    myNotifyListeners();
  }

  removeLastScreens(context) {
    Navigator.of(context).pop();

    myNotifyListeners();
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
    bool rtn = false;
    if (_requestList != null) {
      _requestList.forEach((element) {
        var value = element.value;
        var objIaction = value[gAction];
        if (objIaction == item[gAction]) {
          var objIDataStr = value[gData].toString();
          var dataStr = item[gData].toString();
          if (objIDataStr == dataStr) {
            //duplicated, return
            // ignore: void_checks
            rtn = true;
          }
        }
      });
    }

    return rtn;
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
        data[0][gMsg] != null &&
        data[0][gMsg] == gEnterusercode) {
      enterUserCode(context, null);
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
        throw Exception(getSCurrent(gServerdown));
      }
      sendRequestList(context);
    } catch (e) {
      throw e;
    }
  }

  retrieveTableFromDB(tableid, context) {
    if (_loadingTable.contains(tableid)) {
      return;
    }
    _loadingTable.add(tableid);
    try {
      sendRequestOne(
          gProcess,
          [
            {
              "label": gNull,
              "type": "table",
              "actionid": tableid,
              "colorIndex": 0
            }
          ],
          context);

      /*sendRequestOne(
          gGetTableData,
          {
            gTableID: tableid,
            gEmail: _myId, //getFormValue(gLogin, gEmail, gValue),
            gCompany: _globalCompanyid
          },
          context);*/
    } catch (e) {
      throw e;
    }
  }

  saveTableOne(data0, context) {
    //formid = data0[gFormid];
    List tableData = tableList[data0[gTableID]][gData];
    if (data0[gActionid] == gTableAdd) {
      //tableData.insert(0, Map.of(data0[gBody]));
      finishme(context);
      saveTableOneAt0(tableData, data0, context);
      tableList[data0[gTableID]][gKey] = UniqueKey();
      //if table have detail, popup the detail page
      Map tableAttr = tableList[data0[gTableID]][gAttr];
      var detail = tableAttr[gDetail];
      if (detail != null && detail.length > 0) {
        var param = {
          gLabel: gDetail,
          gAction: gLocalAction,
          gTableID: data0[gTableID],
          gRow: (Map.of(data0))[gBody],
          gTranspass: gPopupnew
        };

        sendRequestOne(param[gAction], param, context);
      }
    } else if (data0[gActionid] == gTableUpdate) {
      finishme(context);
      var updateID = data0[gBody][gId];
      tableData.removeWhere((element) => element[gId] == updateID);
      //tableData.insert(0, Map.of(data0[gBody]));
      saveTableOneAt0(tableData, data0, context);
    } else if (data0[gActionid] == gTableDelete) {
      var deletedID = data0[gBody][gId];
      tableData.removeWhere((element) => element[gId] == deletedID);
    }

    myNotifyListeners();
  }

  saveTableOneAt0(tableData, data0, context) {
    tableData.insert(0, Map.of(data0[gBody]));
  }

  searchTable(data, context) {
    var tableId = data[gTableID];
    var searchTxt = data[gSearch];
    _tableList[tableId][gSearch] = searchTxt;
    myNotifyListeners();
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
        if (initRequest == '') {
          wait(1);
          var param = getMod(_zzydhbase, _arandomsession, _zzyprime);
          _requestList.addFirst({
            gAction: gGetsessionkey,
            gData: [
              {gKey: param}
            ]
          });
        } else {
          //no need session key

          /*_requestList.addFirst({
            gAction: initRequest,
            gData: [
            ]
          });*/
          myBusiness(initRequest, context);
          //set i10t

        }
      }
      if (_requestList.isEmpty) {
        return;
      }
      if (_requestList.length < 1) {
        return;
      }
      Map requestFirst = requestListRemoveFirst();
      if (requestFirst[gAction] != null &&
          requestFirst[gAction] == gLocalAction) {
        localAction(requestFirst, context);
        return;
      }
      if (_token != '') {
        requestFirst[gToken] = _token;
        requestFirst[gCompanyid] = _globalCompanyid;
      }
      var dataRequest = encryptByDES(requestFirst);
      await processRequest(dataRequest, context);
    } catch (e) {
      showMsg(context, e, null);
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
      if (requestListExists({gAction: action, gData: data})) {
        return;
      }

      addandsentRequest(action, data, context);
    } catch (e) {
      throw e;
    }
  }

  setDropdownMenuItem(_param, newValue, context, _formName) {
    setFormValue(_formName, _param[gId], newValue);

    myNotifyListeners();
  }

  setFormList(actionData) {
    List<dynamic> thisList = actionData;
    for (int i = 0; i < thisList.length; i++) {
      Map<String, dynamic> thisListI = thisList[i];
      var formID = thisListI[gFormName];
      setFormListOne(formID, thisListI);
    }
    myNotifyListeners();
  }

  //setFormListOne(formID, param) {
  setFormListOne(formID, formDetail) async {
    if (_formLists[formID] != null) {
      return;
    }
    //var formDetail = param[gFormdetail];
    // var btns = param[gBtns];
    Map<String, dynamic> formValue = Map.from(formDetail);

    Map<dynamic, dynamic> itemList = formValue[gItems];
    itemList.entries.forEach((elementItemList) {
      Map<dynamic, dynamic> valueItemList = elementItemList.value;

      valueItemList[gInputType] = getInputType(valueItemList[gInputType]);
      valueItemList[gTxtEditingController] =
          TextEditingController(text: valueItemList[gDefaultValue]);
      valueItemList[gValue] = '';

      valueItemList[gOldvalue] = '';
      valueItemList[gTextFontColor] = fromBdckcolor(_lastBackGroundColor);

      valueItemList = Map.from(valueItemList);
    });
    formValue[gItems] = Map.from(itemList);
    formValue[gItems].forEach((key, value) {
      formValue[gItems][key] = Map.of(value);
    });

    _formLists[formID] = formValue;
    if (formID == gLogin) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setFormValue(gLogin, gEmail, prefs.getString('myid') ?? '');
    }
    //print(jsonEncode(_formLists[formID]));
  }

  showAlertDialog(BuildContext context, title, msg, requestFirst) {
    int backcolor = Colors.black.value;
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: MyLabel({gLabel: gCancel}, backcolor),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: MyLabel({gLabel: gContinue}, backcolor),
      onPressed: () {
        localAction(requestFirst, context);
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: MyLabel({gLabel: title}, backcolor),
      content: MyLabel({gLabel: msg}, backcolor),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showPDF(actionData, context) async {
    String filename = '';
    String subject = '';
    for (int i = 0; i < actionData.length; i++) {
      Map<String, dynamic> ai = Map.of(actionData[i]);
      filename = ai[gFilename];
      subject = ai[gSubject];
    }
    if (filename == '') {
      return;
    }

    //download file
    try {
      await downloadFile(filename, context, true, subject);
    } catch (e) {
      showMsg(context, e, null);
      //throw e;
      //print('=====exception is ' + e);
    } finally {
      // await sendRequestList(context);
    }

    //sendRequestOne(gFiledownload, {gFilename: filename}, context);
  }

  Future downloadFile(filename, context, needRemove, subject) async {
    String filePath = '';

    try {
      String myUrl = 'http://' +
          MyConfig.URL.name +
          '/' +
          MyConfig.DOWNLOAD.name +
          '?filename=$filename&needRemove=$needRemove';

      //Uri uri = new Uri.http(MyConfig.URL.name,MyConfig.DOWNLOAD.name + '?filename=$filename' + filename);
      Response response = (await httpClient.get(Uri.parse(myUrl)));
      //var response = await request;
      if (response.statusCode == 200) {
        var bytes = response.bodyBytes;
        //await consolidateHttpClientResponseBytes(response);
        //Directory dir = await getApplicationDocumentsDirectory();
        Directory dir = await getTemporaryDirectory();
        String tempPath = dir.path;
        //showMsg(context, tempPath);

        filePath = '$tempPath/$filename';
        File file = File(filePath);
        await file.writeAsBytes(bytes);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PDFScreen({gPath: filePath, gSubject: subject}),
          ),
        );
      } else {
        showMsg(context, 'Error code: ' + response.statusCode.toString(), null);
      }
    } catch (ex) {
      showMsg(context, ex.toString(), null);
    }
    //print('======== filePath is $filePath');
  }

  showScreenPage(actionData, context, backcolor) {
    for (int i = 0; i < actionData.length; i++) {
      Map<String, dynamic> ai = actionData[i];
      String name = '';
      String type = '';
      dynamic data;
      ai.entries.forEach((element) {
        if (element.key == gName) {
          name = element.value;
        } else if (element.key == gType) {
          type = element.value;
        } else if (element.key == gItems) {
          data = element.value;
        }
      });
      _screenLists[name] = Map.of(data);
      if (type == gScreen) {
        if (name == gFirstPage) {
          //_firstFormName = name;

          _firstPage = FirstPage();
        } else {
          //MyScreen aScreen = MyScreen(_screenLists[name]);
          //Map param = {gLabel: name, gScreen: aScreen};
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyDetailNew(_screenLists[name], backcolor)));
        }
      } else {
        showScreenPageOne(name, context, backcolor);
      }
    }
    myNotifyListeners();
  }

  showScreenPageOne(name, context, backcolor) {
    MyScreen aScreen = MyScreen(_screenLists[name], backcolor);
    Map param = {gLabel: name, gScreen: aScreen};
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyDetailNew(param, backcolor)));
  }

  newForm(data, context) {
    var tableName = data[gActionid] ?? data[gTableID];
    Map<String, dynamic> formDefine = _formLists[tableName];
    Map<dynamic, dynamic> items = formDefine[gItems];
    items.entries.forEach((item) {
      item.value[gOldvalue] = null;

      item.value[gValue] = item.value[gDefaultValue];
      item.value[gTxtEditingController]..text = item.value[gDefaultValue];
    });
  }

  showFormEdit(data, context) {
    var tableName = data[gActionid] ?? data[gTableID];
    Map<String, dynamic> formDefine = _formLists[tableName];
    Map<dynamic, dynamic> items = formDefine[gItems];
    dynamic dataRow = data[gRow];
    items.entries.forEach((item) {
      item.value[gOldvalue] =
          (dataRow == null) ? null : dataRow[item.value[gId]];

      item.value[gValue] = item.value[gOldvalue];
      item.value[gTxtEditingController]
        ..text = (dataRow == null) ? null : dataRow[item.value[gId]].toString();
    });
  }

  showTableForm(data, context, backcolor) {
    //int index = data[gRow] ?? -1;
    var tableName = data[gActionid] ?? data[gTableID];

    //Map ti = getTableRowShowValueByTablename(data[gRow], tableName, context);
    //Map dataRow = data[gRow];

    /*List actionData = [
      {
        gName: gDetailPage,
        gItems: {
          gType: gForm,
          gFormdetail: Map.of(formdetail),
          gActions: [],
          gBottomImgs: [],
          gTitle: formdetail[gImgTitle], // {gType: gLabel, gValue: tableName},
          gBtns: [],
          //gData: dataRow
        },
      }
    ];*/
    var keyValue = getTableValueKey(tableName, data[gRow]);
    List actionData = [
      {
        gName: tableName,
        gType: gScreen,
        gItems: {
          0: {
            gItem:
                jsonEncode({gType: gLabel, gValue: keyValue, gFontSize: 24.0})
          },
          1: {
            gItem: jsonEncode({gType: gForm, gValue: tableName})
          }
        },
      }
    ];

    showScreenPage(actionData, context, backcolor);
  }

  setI10n(actionData) {
    for (int i = 0; i < actionData.length; i++) {
      Map<String, dynamic> ai = Map.of(actionData[i]);
      ai.entries.forEach((element) {
        Map mValue = Map.of(element.value);
        _i10nMap[element.key] = mValue;
      });
    }
    myNotifyListeners();
  }

  setInitForm(actionData) {
    //_firstFormName = actionData[0][gName];
    myNotifyListeners();
  }

  setFormDefaultValue(formid, colId, value) {
    _formLists[formid][gItems][colId][gDefaultValue] = value;
  }

  setFormFocus(formid, colId) {
    Map<dynamic, dynamic> items = _formLists[formid][gItems];

    if (colId != null) {
      items.entries.forEach((item) {
        if (item.value[gId] == colId) {
          item.value[gFocus] = true;
        } else {
          item.value[gFocus] = false;
        }
      });
    } else {
      bool haveFocus = false;
      items.entries.forEach((item) {
        if (item.value[gFocus] ?? false) {
          haveFocus = true;
        }
      });
      if (haveFocus) {
        return;
      }
      //first value null get focus
      items.entries.forEach((item) {
        bool isValueNull = isNull(item.value[gValue]);
        var txtValue = item.value[gTxtEditingController].value.text;
        bool isTxtNull = isNull(txtValue);
        if (isValueNull && isTxtNull) {
          item.value[gFocus] = true;
          return;
        }
      });
    }
  }

  setFormValue(formid, colId, value) {
    _formLists[formid][gItems][colId][gValue] = value;
    _formLists[formid][gItems][colId][gTxtEditingController]..text = value;
    //
  }

  setLocale(value) async {
    _locale = value;
    //S.load(_locale);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('locallan', value);
    myNotifyListeners();
  }

  setImgList(data) {
    for (int i = 0; i < data.length; i++) {
      Map dataMap = Map.of(data[i]);
      dataMap.entries.forEach((element) {
        _imgList[element.key] = element.value;
      });
    }
    myNotifyListeners();
  }

  /*debounce(fn, [int t = 30]) {
    Timer _debounce;
    return () {
      if (_debounce?.isActive ?? false) {
        _debounce.cancel();
      }
      _debounce = Timer(Duration(milliseconds: t), () {
        fn();
      });
    };
  }*/
  final _debouncer = Debouncer(milliseconds: 300);
  myNotifyListeners() {
    _debouncer.run(() => notifyListeners());
  }

  setMyAction(data) {
    _actionLists[gMain] = data;
  }

  setMyInfo(data, context) async {
    //_myInfo = data;
    setFormValue(gLogin, gEmail, data[gEmail]);
    //_formLists[gLogin][gItems][gEmail][gDefaultValue] = data[gEmail];
    _token = data[gToken];
    _myId = data[gEmail];

    _globalCompanyid = data[gCompanyid];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('myid', _myId);
    //myNotifyListeners();
  }

  setMyMenu(List data) {
    for (int i = 0; i < data.length; i++) {
      data[i] = Map.of(data[i]);
      //data[i]['widget'] = Text(getSCurrent('role'));
    }
    _menuLists[gMain] = data;
  }

  setMyTab(List data) {
    int i = 0;

    data.forEach((element) {
      List databodyNew = [];
      Map data0 = Map.of(element);
      dynamic tabname = data0[gTabid];
      _tabList[tabname] = {};
      _tabList[tabname][gData] = [];
      List<dynamic> data0body = data0[gBody];
      data0body.forEach((element) {
        element = Map.of(element);
        if (i == _colorList.length) {
          i = 0;
        }
        element[gColorIndex] = i;
        databodyNew.add(element);
        i++;
      });
      data0[gBody] = databodyNew;
      data0[gIsselected] = true;
      _tabList[tabname][gData].add(data0);
      _tabList[tabname][gTabIndex] = 0;
      //_tabList[tabname][gController] = ItemScrollController();
      //_tabList[tabname][gControllerListener] = ItemPositionsListener.create();
    });

    myNotifyListeners();
  }

  setSessionkey(data) {
    int key = int.parse(data);
    String sessionkey = getMod(key, _arandomsession, _zzyprime).toString();
    _sessionkey = hash(sessionkey);
    //myNotifyListeners();
  }

  setTableList(List<dynamic> data, context) {
    data.forEach((element) {
      element.entries.forEach((element1) {
        addTable(element1, context);
      });
    });
  }

  setTreeNode(data, context) {
    /*List<Node> nodes = [];
    if (data[gType] == gTabletree) {
      String tableName = data[gActionid];
      nodes = getTreeNodesFromTable(tableName, context, 0);
    }
    data[gNode] = nodes;*/
  }

  showMsg(context, dynamic result, backcolor) {
    /*Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);*/
    showModalBottomSheet(
        context: context,
        builder: (context) {
          final double _screenHeight = MediaQuery.of(context).size.height;
          var _screenPadding = MediaQuery.of(context).viewPadding;
          final double _scrollHeight =
              (_screenHeight - _screenPadding.top - kToolbarHeight) * 0.7;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    constraints: BoxConstraints(maxHeight: _scrollHeight),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Text(
                        result.toString(),
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ),
                  Divider(),
//取消按钮
                  //添加个点击事件
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: MyLabel({
                        gLabel: gClose,
                      }, backcolor),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  showTab(label, context, tabName) {
    for (int i = 0; i < _tabList[tabName][gData].length; i++) {
      if (_tabList[tabName][gData][i][gLabel] == label) {
        _tabList[tabName][gData][i][gVisible] = true;
        if (_tabList[tabName][gTabIndex] != i) {
          _tabList[tabName][gTabIndex] = i;
          myNotifyListeners();
          _tabList[tabName][gController].scrollTo(
              index: i,
              duration: Duration(seconds: 2),
              curve: Curves.easeInOutCubic);
          _tabList[tabName][gController].jumpTo(index: i);

          myNotifyListeners();
        }
        return true;
      }
    }
    _tabList[tabName][gTabIndex] = 0;
    return false;
  }

  showTable(String tableid, context, title, transpass, backcolor) {
    if (_tableList[tableid] == null) {
      retrieveTableFromDB(tableid, context);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyDetailNew(
                  getTableBodyParam({gTableID: tableid}, context), backcolor)));
      if (strSubexists(transpass, gPopupnew)) {
        Map param = {
          gTableID: tableid,
          gType: gTable,
          gLabel: title,
          gTranspass: transpass
        };
        //trigger add new
        newForm(param, context);
        showTableForm(param, context, backcolor);
      }
    }
  }

  strSubexists(str, sub) {
    var result = false;
    if (str != null && sub != null) {
      return str.indexOf(sub) > -1;
    }
    return result;
  }

  tableAddNew(data, context) {
    data[gRow] = newForm(data, context);
    showTableForm(data, context, null);
  }

  toExcel(data, context) {
    toFile(data, context, 'excel');
  }

  toPdf(data, context) {
    toFile(data, context, 'pdf');
  }

  toFile(data, context, label) {
    String tableName = data[gTableID];
    List header = [];
    List body = [];

    Map tableInfo = _tableList[tableName];

    //tableInfo.[gData].length;
    List tableData = tableInfo[gData];
    List columns = tableInfo[gColumns];
    String subject = tableInfo[gAttr][gLabel] ?? '';

    for (int i = 0; i < columns.length; i++) {
      if (isHiddenColumn(columns, i)) {
        continue;
      }

      header.add(getSCurrentLan(columns[i][gLabel], 'en'));
    }

    String searchValue = tableInfo[gSearch] ?? '';
    List newData = [];

    for (int i = 0; i < tableData.length; i++) {
      Map dataRow = tableData[i];
      //get updated value
      List ti = getTableRowShowValueFilterMapOrList(
          dataRow, columns, context, searchValue, false);
      if (ti != null) {
        body.add(ti);
      }
      /*bool searchTxtExists = false;
        for (MapEntry element in ti.entries) {
          var elementKey = element.key;

          if (searchValue == '' ||
              (element.value ?? '').indexOf(searchValue) > -1) {
            searchTxtExists = true;
            break;
          }
        }
        if (searchTxtExists) {
          newData.add(ti);
        }*/
    }

    tableInfo[gDataSearch] = newData;
    //header
    //body
    //request
    var filename = _token ?? "atmpfile";
    if (filename.indexOf("-") > 0) {
      filename = filename.substring(0, filename.indexOf("-"));
    }
    sendRequestOne(
        label,
        {
          gHeader: header,
          gBody: body,
          gFilename: label + filename,
          gSubject: subject
        },
        context);
  }

  tableSort(tableName, columnIndex, ascending, context) {
    List data = tableList[tableName][gData];
    if (data == null || data.length < 2) {
      return;
    }
    int dataColumnIndex = 0;
    List columns = tableList[tableName][gColumns];
    for (int i = 0; i < columns.length; i++) {
      if (isHiddenColumn(columns, i)) {
        continue;
      }
      if (columnIndex == dataColumnIndex) {
        dataColumnIndex = i;
        break;
      }
      dataColumnIndex++;
    }
    data.sort((a, b) =>
        tableSortCompare(a, b, columns, dataColumnIndex, ascending, context));

    tableList[tableName][gAscending] = ascending;
    tableList[tableName][gSortColumnIndex] = columnIndex;
  }

  tableSortCompare(a, b, columns, colindex, ascending, context) {
    String inputType = columns[colindex][gInputType];
    if (ascending) {
      if (inputType == gDatetime) {
        return getTableCellValueFromDataRow(a, columns, colindex, context) -
            getTableCellValueFromDataRow(b, columns, colindex, context);
      } else {
        //data.sort((a, b) => a[colName].compareTo(b[colName]));
        return getTableCellValueFromDataRow(a, columns, colindex, context)
            .compareTo(
                getTableCellValueFromDataRow(b, columns, colindex, context));
      }
    } else {
      if (inputType == gDatetime) {
        return getTableCellValueFromDataRow(b, columns, colindex, context) -
            getTableCellValueFromDataRow(a, columns, colindex, context);
      } else {
        //data.sort((a, b) => a[colName].compareTo(b[colName]));
        return getTableCellValueFromDataRow(b, columns, colindex, context)
            .compareTo(
                getTableCellValueFromDataRow(a, columns, colindex, context));
      }
    }
  }

  wait(waitSeconds) async {
    await Future.delayed(Duration(seconds: waitSeconds));
  }

  myBusiness(initRequest, context) {
    if (initRequest == 'checkout') {
      //1 set i10n
      {
        var actionData = [
          {
            "parent": {gEn: "parent", gZh: "ç¶ç±»"}
          },
          {
            "serverwrongcode": {
              gEn:
                  "failed, Http response code is not right, [{responseCode}], [{responsebody}]",
              gZh:
                  "å¤±è´¥ï¼ æå¡å¨è¿åéè¯¯ä¿¡æ¯, [{responseCode}], [{responsebody}]"
            }
          },
          {
            "program": {gEn: "program", "zh": "é¡¹ç®"}
          },
          {
            "employee": {"en": "employee", "zh": "åå·¥"}
          },
          {
            "type": {"en": "type", "zh": "ç±»å"}
          },
          {
            "checkverifycode": {
              "en": "please check email for verify code",
              "zh": "è¯·æ¥æ¶é®ä»¶æ¾å°éªè¯ç "
            }
          },
          {
            "character": {"en": "characters", "zh": "字符"}
          },
          {
            "charge": {"en": "charge", "zh": "结帐"}
          },
          {
            "companyid": {"en": "company", "zh": "公司"}
          },
          {
            "password": {"en": "password", "zh": "密码"}
          },
          {
            "action": {"en": "action", "zh": "动作"}
          },
          {
            "create": {"en": "create", "zh": "创建"}
          },
          {
            "enter": {"en": "enter", "zh": "输入"}
          },
          {
            "welcome": {"en": "welcome", "zh": "欢迎"}
          },
          {
            "new": {"en": "new", "zh": "新"}
          },
          {
            "isrequired": {"en": "{name} is required", "zh": "{name}必填"}
          },
          {
            "systemtitle": {"en": "Checkout", "zh": "结帐"}
          },
          {
            "entryid": {"en": "enter by", "zh": "输入"}
          },
          {
            "tutor": {"en": "tutor", "zh": "老师"}
          },
          {
            "forget": {"en": "forget", "zh": "忘记"}
          },
          {
            "dictionary": {"en": "dictionary", "zh": "字典"}
          },
          {
            "system": {"en": "system", "zh": "系统"}
          },
          {
            "name": {"en": "name", "zh": "名称"}
          },
          {
            "invalidname": {
              "en": "pleaseÂ enterÂ anÂ validÂ {name}",
              "zh": "è¯·è¾å¥åæ³ç{name}"
            }
          },
          {
            "reset": {"en": "reset", "zh": "éç½®"}
          },
          {
            "detail": {"en": "detail", "zh": "æç»"}
          },
          {
            "maxinput": {
              "en": "please enter less than {number} {unit}",
              "zh": "è¯·è¾å¥å°äº{number}ä¸ª{unit}"
            }
          },
          {
            "desc": {"en": "description", "zh": "æè¿°"}
          },
          {
            "code": {"en": "code", "zh": "ç "}
          },
          {
            "role": {"en": "Role", "zh": "è§è²"}
          },
          {
            "entrytime": {"en": "enter at", "zh": "å½å¥æ¶é´"}
          },
          {
            "submit": {"en": "submit", "zh": "æäº¤"}
          },
          {
            "student": {"en": "student", "zh": "å­¦ç"}
          },
          {
            "mininput": {
              "en": "please enter at least {number} {unit}",
              "zh": "è¯·è¾å¥è³å°{number}ä¸ª{unit}"
            }
          },
          {
            "update": {"en": "update", "zh": "ä¿®æ¹"}
          },
          {
            "industry": {"en": "industry", "zh": "è¡ä¸"}
          },
          {
            "login": {"en": "login", "zh": "ç»å½"}
          },
          {
            "delete": {"en": "delete", "zh": "å é¤"}
          },
          {
            "eteremailtoresetpassword": {
              "en":
                  "enter your email address and we'll send you an email with code to reset your password.",
              "zh":
                  "è¾å¥é®ç®±ï¼æä»¬ä¼ç»æ¨é®ä»¶ä¸­åéªè¯ç ï¼ä»¥ä¾¿éç½®å¯ç "
            }
          },
          {
            "not": {"en": "not", "zh": "ä¸"}
          },
          {
            "serverdown": {
              "en":
                  "failed! server is not response, please retry after a while",
              "zh": "å¤±è´¥ï¼ æå¡å¨æªååºï¼è¯·ç¨ååè¯"
            }
          },
          {
            "backbtn": {"en": "  <- ", "zh": "  <- "}
          },
          {
            "beef": {"en": "beef", "zh": "牛肉"}
          },
          {
            "verify": {"en": "verify", "zh": "éªè¯ç "}
          },
          {
            "company": {"en": "company", "zh": "å¬å¸"}
          },
          {
            "nochange": {"en": "no change", "zh": "æªä¿®æ¹"}
          },
          {
            "noodle": {"en": "noodle", "zh": "面"}
          },
          {
            "email": {"en": "email", "zh": "çµå­é®ä»¶"}
          },
          {
            "table": {"en": "table", "zh": "è¡¨"}
          },
          {
            "change": {"en": "change", "zh": "ä¿®æ¹"}
          },
          {
            "match": {"en": "match", "zh": "å¹é"}
          },
          {
            "addnew": {"en": "add new", "zh": "æ°å¢"}
          },
          {
            "home": {"en": "home", "zh": "ä¸»é¡µ"}
          },
          {
            "pls": {"en": "Please", "zh": "è¯·"}
          },
          {
            "account": {"en": "account", "zh": "å¸å·"}
          }
        ];
        setI10n(actionData);
      }
      {
        setSessionkey("77680759");
      }
      {
        Map param = {
          "type": "form",
          "formdetail": {
            "formName": "login",
            "backgroundColor": 4280391411,
            "submit": "Login",
            "imgTitle": {
              "title": "Welcome",
              "fontSize": 40.0,
              "height": 1.2,
              "letterSpacing": 1.0
            },
            "height": 450.5,
            "top": 130.0,
            "items": {
              "email": {
                "id": "email",
                "dbid": "email",
                "type": "email",
                "label": "Email",
                "defaultValue": "",
                "placeHolder": "xxx@xxxxx.xxx",
                "required": true,
                "minLength": 8,
                "length": 40,
                "hash": false,
                "unit": "characters",
                "prefixIcon": 59123,
                "inputType": "emailAddress",
                "isHidden": false,
                "fontSize": null,
                "letterSpacing": null,
                "isPrimary": false
              },
              "password": {
                "id": "password",
                "dbid": "password",
                "type": "password",
                "label": "Password",
                "defaultValue": "",
                "placeHolder": "",
                "required": true,
                "minLength": 8,
                "length": 20,
                "hash": true,
                "unit": "characters",
                "prefixIcon": 59459,
                "inputType": "visiblePassword",
                "isHidden": false,
                "fontSize": null,
                "letterSpacing": null,
                "isPrimary": false
              }
            }
          }
        };
        getWidgetForm(param, null);
      }
      {
        dynamic data = {
          "id": "996a925f-5ce8-4d08-9ef6-2f3169d21491",
          "zzyoptlock": "619",
          "username": "Linus",
          "firstname": "Zhong",
          "usercode": "1220",
          "email": "none",
          "token": "none",
          "cell": "null",
          "parentid": "null",
          "url": "null",
          "roleid": "-1",
          "password": "",
          "companyid": "IOTPay",
          "entryid": "996a925f-5ce8-4d08-9ef6-2f3169d21491",
          "entrytime": "1623459619673"
        };
        setMyInfo(data, context);
      }

      {
        List actiondata = [
          {
            "label": "Role",
            "icon": 0xf1ac,
            "type": "table",
            "actionid": "Zzyrole"
          },
          {
            "label": "Menu",
            "icon": 0xf1c4,
            "type": "table",
            "actionid": "Zzymenu"
          },
          {
            "label": "Test",
            "icon": 0xf2dd,
            "type": "action",
            "actionid": "test"
          },
          {
            "label": "Change Password",
            "icon": 0xf33f,
            "type": "action",
            "actionid": "changepassword"
          }
        ];
        setMyMenu(actiondata);
      }
      {
        List actionData = [
          {
            gLabel: "Shopping Cart",
            gIcon: 0xf37f,
            gType: gAction,
            gActionid: "businessShowShoppingCart"
          }
        ];
        setMyAction(actionData);
      }

      {
        Map items = businessCheckoutGetItems();
        Map category = businessCheckoutGetCategory();
        List data = [];
        category.forEach((key, value) {
          List itemList = value[gItems];
          List bodyList = [];
          itemList.forEach((element) {
            Map itemOne = items[element];
            bodyList.add({
              gLabel: itemOne[gLabel],
              gType: gProcess,
              gActionid: 'businessChckoutAddOneToShoppingCart',
              gDetail: [
                {gLabel: itemOne[gPrice], gType: gMoney, gActionid: element}
              ]
            });
          });
          data.add({gLabel: value[gLabel], gType: gCard, gBody: bodyList});
        });

        setMyTab(data);
      }
      {
        removeAllScreens(context);
      }
    }
  }

  businessCheckoutGetItems() {
    return {
      'item0': {
        gLabel: "Beef Noodle",
        gPrice: "15.00",
      },
      'item1': {
        gLabel: "House special stir Fried sliced",
        gPrice: "12.10",
      },
      'item2': {
        gLabel: "Red curry over Noodle",
        gPrice: "13.00",
      },
      'item3': {
        gLabel: "Taipei Riverway Seafood Thisk so...",
        gPrice: "14.00",
      },
      'item4': {
        gLabel: "White Rice",
        gPrice: "1.00",
      },
      'item5': {
        gLabel: "Brown Rice",
        gPrice: "1.50",
      },
      'item6': {
        gLabel: "Eight Treasure Rice",
        gPrice: "2.50",
      },
      'item7': {
        gLabel: "Stirred Rice",
        gPrice: "5.50",
      },
      'item8': {
        gLabel: "Red Tea",
        gPrice: "5.50",
      },
      'item9': {
        gLabel: "Green Tea",
        gPrice: "4.50",
      },
      'item10': {
        gLabel: "Rose Tea",
        gPrice: "10.50",
      },
      'item11': {
        gLabel: "Regular Coffee",
        gPrice: "1.50",
      },
      'item12': {
        gLabel: "Carpocino",
        gPrice: "2.50",
      },
      'item13': {
        gLabel: "Cat poop",
        gPrice: "12.50",
      },
      'item14': {
        gLabel: "Apple juice",
        "price": "2.50",
      },
      'item15': {
        gLabel: "Beer",
        gPrice: "4.50",
      },
    };
  }

  businessCheckoutGetCategory() {
    return {
      'cate0': {
        gLabel: "Noodle",
        gItems: ['item0', 'item1', 'item2', 'item3']
      },
      'cate1': {
        gLabel: "Rice",
        gItems: ['item4', 'item5', 'item6', 'item7']
      },
      'cate2': {
        gLabel: "Tea",
        gItems: ['item8', 'item9', 'item10']
      },
      'cate3': {
        gLabel: "Coffee",
        gItems: ['item11', 'item12', 'item13']
      },
      'cate4': {
        gLabel: "Uncategorized",
        gItems: ['item14', 'item15']
      },
    };
  }

  businessGetOrderSum() {
    return '20.00';
  }

  businessMyBody(name) {
    if (name == gMain) {
      List objList = [];
      objList.add({
        gType: gLabel,
        gHeight: 80.0,
        gAlign: gCenter,
        gLabel: '\$ ' + businessGetOrderSum(),
        gFontSize: 40.0,
        //gColor: Colors.red
      });
      objList.add({
        gType: gButton,
        gHeight: 80.0,
        gAlign: gCenter,
        gLabel: gCharge,
        gFontSize: 40.0,
        gColor: Colors.white,
        gBackgroundColor: Colors.green
      });

      objList.add({gType: gTab, gData: name});
      return MyDynamicBody(objList);
    }
    return null;
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

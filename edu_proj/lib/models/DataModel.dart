import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
//import 'dart:io';
import 'package:crypto/crypto.dart';
//import 'package:dio/dio.dart';
import 'package:edu_proj/config/MyConfig.dart';
import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/screens/firstPage.dart';
//import 'package:edu_proj/screens/mainPage.dart';
//import 'package:edu_proj/screens/myDetail.dart';
import 'package:edu_proj/screens/myDetail.dart';
import 'package:edu_proj/utils/AES.dart';
import 'package:edu_proj/widgets/myIcon.dart';
//import 'package:edu_proj/widgets/MyForm.dart';
import 'package:edu_proj/widgets/myButton.dart';
import 'package:edu_proj/widgets/myItem.dart';
import 'package:edu_proj/widgets/myLabel.dart';
//import 'package:edu_proj/widgets/myPaginatedDataTable.dart';
import 'package:edu_proj/widgets/myPic.dart';
import 'package:edu_proj/widgets/myPopup.dart';
import 'package:edu_proj/widgets/myScreen.dart';
//import 'package:edu_proj/widgets/myTree.dart';
//import 'package:edu_proj/widgets/picsAndButtons.dart';
import 'package:edu_proj/widgets/radios.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
//import 'package:flutter_treeview/flutter_treeview.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/myListPicker.dart';
import '../widgets/myPinCode.dart';
import '../widgets/pdfScreen.dart';
import '../widgets/textfieldWidget.dart';

/*
某数据项流程
1 初始化 
  表:放在某行数据中
  form:如果没有同名表，放在value中
       否则，什么也不放，从同名表中取

2 新增
  表： 放在modify中
3 修改
  表： 放在modify中
  form:放在modify中，如果有同名表，id为真值，否则 -1
4 展示：
 表： 优先从modify中拿
 form:优先从modify中拿
5 保存
 如果有同名表，提交表存
 否则提交formchange

 modify中存两套数据： 
   合法数据
   非法数据

*/
class DataModel extends ChangeNotifier {
  //dynamic _email;
  dynamic _token = '';
  dynamic _myId = '';
  dynamic _myDBId = '';
  dynamic _sessionkey = '';
  dynamic initRequest = ''; //'checkout';
  int _zzyprime = 91473769;
  int _zzydhbase = 2;
  int _arandomsession = new Random().nextInt(1000);
  int _requestCnt = 0;
  dynamic _globalCompanyid = '';
  final int _defaultBackGroundColor = 4294967295; //4280391411;
  Map _systemParams = {gSystemTitle: gSystemTitle};
  int _lastBackGroundColor = 4280391411;
  final int _requestCntMax = 10;
  //dynamic _firstFormName = '';
  http.Client httpClient = http.Client();
  //Locale _locale = const Locale('en', '');
  dynamic _locale = 'en';
  final _debouncer = Debouncer(milliseconds: 50, action: () {});

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
  Color warningColor = Colors.red;
  double _defaultFontSize = 15.0;
  double get defaultFontSize => _defaultFontSize;
  /*final List<int> _colorList = [
    Colors.green.value,
  ];*/
  //Locale get locale => _locale;
  dynamic get locale => _locale;
  Widget _firstPage = Text('');
  Map<dynamic, Map<dynamic, dynamic>> _formLists = {};
  Map<int, Color> _bdBackColorList = {};
  Map<dynamic, Map<dynamic, dynamic>> _tableList = {};
  Map<dynamic, dynamic> _tabList = {};
  //Widget _tabWidget;
  Map<dynamic, dynamic> _actionLists = {};
  Map<dynamic, dynamic> _menuLists = {};
  Map<dynamic, dynamic> _screenLists = {};
  Map<dynamic, dynamic> _imgList = {
    gMain: 'http://' +
        MyConfig.URL.name +
        '/images/main.jpg' //'https://ipt.imgix.net/201444/x/0/?auto=format%2Ccompress&crop=faces%2Cedges%2Ccenter&bg=%23fff&fit=crop&q=35&h=944&dpr=1'
  };

  Map<dynamic, Image> _imgCache = {};

  Map<dynamic, dynamic> _monthMap = {
    '01': 'Jan',
    '02': 'Feb',
    '03': 'Mar',
    '04': 'Apr',
    '05': 'May',
    '06': 'Jun',
    '07': 'Jul',
    '08': 'Aug',
    '09': 'Sep',
    '10': 'Oct',
    '11': 'Nov',
    '12': 'Dec',
  };
  Map<dynamic, dynamic> _dpList = {};

  Map<dynamic, dynamic> _whereList = {};
  //Route _lastRoute;
  //'https://ipt.imgix.net/201444/x/0/?auto=format%2Ccompress&crop=faces%2Cedges%2Ccenter&bg=%23fff&fit=crop&q=35&h=944&dpr=1'
  Map get imgList => _imgList;
  Map get imgCache => _imgCache;
  Map<dynamic, dynamic> _i10nMap = {};
  Queue? _requestList = new Queue();
  Queue _requestListRunning = new Queue();
  Map _itemSubList = {};
  Map _dpListDefaultIndex = {};
  Map _dpListSearch = {};
  OverlayEntry? overlayEntry;
  Map<dynamic, dynamic> _mFocusNode = {gType: null};
  Map<dynamic, List<Widget>> _actionBtnMap = {};

  //dynamic get email => _email;
  dynamic get token => _token;

  //Route get lastRoute => _lastRoute;

  Map<dynamic, Map<dynamic, dynamic>> get formLists => _formLists;
  Map<dynamic, dynamic> get actionLists => _actionLists;
  Map<dynamic, dynamic> get menuLists => _menuLists;
  Map<dynamic, dynamic> get screenLists => _screenLists;

  Map<dynamic, Map<dynamic, dynamic>> get tableList => _tableList;
  Map<dynamic, dynamic> get tabList => _tabList;
  Map<dynamic, dynamic> get dpList => _dpList;
  Map<dynamic, dynamic> get whereList => _whereList;
  Map get dpListDefaultIndex => _dpListDefaultIndex;
  Map get dpListSearch => _dpListSearch;
  Map<dynamic, dynamic> get mFocusNode => _mFocusNode;
  //Widget get tabWidget => _tabWidget;
  //int _tabIndex = 0;
  bool isProcessing = false;
  Map get systemParams => _systemParams;
  Set _loadingTable = {};
  Size _sceenSize = new Size(800, 1000);
  Size get sceenSize => _sceenSize;
  Map get itemSubList => _itemSubList;
  int _myDetailID = 0;
  int _myDetailIDCurrent = 0;
  int get myDetailIDCurrent => _myDetailIDCurrent;
  //dynamic _tabParent;
  /*int get tabIndex => _tabIndex;
  setTabIndex(index) {
    _tabIndex = index;
  }*/

  //TabController _tabController;

  /*DataModel() {
    init();
    print('===== _mFocusNode:' + _mFocusNode.toString());
  }*/
  /*setTabParent(parent) {
    _tabParent = parent;
  }*/

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _locale = (prefs.getString('locallan') ?? _locale);
  }

  addActionButton(name, param, context) {
    List<Widget> alist = _actionBtnMap[name]!;
    if (alist.length < 1) {
      alist = [];
      _actionBtnMap[name] = alist;
    }
    List<Widget> btnList = _actionBtnMap[name]!;

    btnList.add(FloatingActionButton.small(
      tooltip: getSCurrent(param[gLabel]),
      backgroundColor: Colors.blue,
      hoverColor: Colors.orange,
      splashColor: Colors.purple,
      onPressed: () {
        sendRequestOne(gLocalAction, param, param[gContext] ?? context);
      },
      child: Icon(
          IconData(
            param[gIcon],
            fontFamily: 'MaterialIcons',
          ),
          color: param[gColor] ?? Colors.white),
    ));
  }

  addNewCheck(actionData, context) {
    //update current new form info
    Map param = actionData[0]['param'];

    Map data = actionData[0][gData];
    if (param[gType] == gTable) {
      dynamic name = param[gName];
      dynamic id = param[gId];
      data.forEach((key, value) {
        if (key != gId) {
          dynamic item = getTableCol(name, key);
          if (item != null) {
            textChange(value, item, context, gTable, name, id);
          }
        }
      });
      myNotifyListeners();
    }
  }

  addTab(data, context, tabName) {
    if (isNull(data[gLabel]) || data[gLabel] == gDroplist) {
      return;
    }
    bool tabExists = showTab(data[gLabel], context, tabName);
    if (tabExists) {
      refreshTab(data, context, tabName);
      return;
    }
    addTabSub(data, tabName);
    changeTabPos(tabName, data[gLabel]);
    myNotifyListeners();
  }

  addTable(data, context) {
    clearMFocusNode(context);
    if (data[gBody] != null && data[gBody][gZzylog] != null) {
      addZzylog(Map.of(data[gBody][gZzylog]), context);
      return;
    }
    var isNew = false;
    var name = data[gActionid];
    if (_tableList[name] == null ||
        _tableList[name]![gAttr][gLogmerge] != 'Y') {
      isNew = true;
    }
    if (isNew) {
      _tableList[name] = Map.of(data[gBody][name]);

      List dataList = _tableList[name]![gData];
      if (dataList.length > 0) {
        for (int i = 0; i < dataList.length; i++) {
          dataList[i] = Map.of(dataList[i]);
          /*if (_dpList.containsKey(name)) {
            dpListInsert(name, dataList[i], context);
          }*/
        }
      }
      List colList = _tableList[name]![gColumns];
      if (colList.length > 0) {
        for (int i = 0; i < colList.length; i++) {
          colList[i] = Map.of(colList[i]);
        }
      }

      _tableList[name]![gAttr] = Map.of(_tableList[name]![gAttr]);

      _tableList[name]![gAscending] = true;
      _tableList[name]![gSortColumnIndex] = 0;
      if (_tableList[name]![gAttr]![gOrderby] != null) {
        //auto sort by order by
        var orderbyList = (_tableList[name]![gAttr]![gOrderby] + '').split(',');
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
          tableSort(name, columnIndex, ascending, context);
        }
      }
    }

    _tableList[name]![gTableID] = name;

    Map param = {
      gType: gForm,
      gFormdetail: {
        gFormName: name,
        gsBackgroundColor: 4280391411,
        gSubmit: gSubmit,
        gImgTitle: {
          gTitle: data[gLabel],
          gFontSize: _defaultFontSize + 10.0,
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

    for (int i = 0; i < _tableList[name]![gColumns].length; i++) {
      //for (int i = 0; i < 3; i++) {
      Map ti = Map.of(_tableList[name]![gColumns][i]);
      param[gFormdetail][gItems][ti[gDbid]] = ti;
    }
    _formLists[name] = {};

    setFormListOne(name, param[gFormdetail]);
    if (data[gLabel] == gDroplist) {
      //add to droplist
      List tableData = _tableList[name]![gData];
      if (tableData.length > 0) {
        tableData.forEach((element) {
          dpListInsert(name, element, context);
        });
      }
    }
    afterTableAdded(name, context);
  }

  addTabSub(data, tabName) {
    _tabList[tabName][gData].add(
        {gLabel: data[gLabel], gType: data[gType], gActionid: data[gActionid]});
    _tabList[tabName][gTabIndex] = _tabList[tabName][gData].length - 1;
  }

  addToList(List sizeList, aValue) {
    int listLength = sizeList.length;
    List maxList = sizeList[listLength - 1].toString().split('~');
    List minList = sizeList[0].toString().split('~');
    int iMax = maxList.length > 1 ? getInt(maxList[1]) : getInt(maxList[0]);
    int iMin = getInt(minList[0]);

    List resultList = [];
    List aValueList = aValue.toString().split('~');
    int iLeft = getInt(aValueList[0]);
    int iRight = getInt(aValueList[1]);
    int iMiddle = ((iLeft + iRight) / 2).round();
    /*if (iMin <= iLeft - 1) {
      if (iMin == iLeft - 1) {
        resultList.add(iMin.toString());
      } else {
        resultList.add(iMin.toString() + '~' + (iLeft - 1).toString());
      }
    }*/
    addToListSub(resultList, iMin, iLeft - 1);

    resultList.add(iLeft.toString());

    //resultList.add((iLeft + 1).toString() + '~' + (iMiddle - 1).toString());
    addToListSub(resultList, iLeft + 1, iMiddle - 1);

    resultList.add(iMiddle.toString());
    //resultList.add((iMiddle + 1).toString() + '~' + (iRight - 1).toString());
    addToListSub(resultList, iMiddle + 1, iRight - 1);
    resultList.add(iRight.toString());
    //resultList.add((iRight + 1).toString() + '~' + (iMax).toString());
    addToListSub(resultList, iRight + 1, iMax);

    return resultList;
  }

  addToListSub(List resultList, a, b) {
    if (a <= b) {
      if (a == b) {
        resultList.add(a.toString());
      } else {
        resultList.add(a.toString() + '~' + b.toString());
      }
    }
  }

  addValidCheckWidget(param, context) {
    getItemIcon(param, context);
    //获得焦点时显示图标
    //print('====== param is ' + param.toString());
    List<Widget> result = [];
    if (param[gTypeOwner] == gForm) {
      result.add(MyLabel({
        gLabel: getSCurrent(param[gItem][gLabel]) + gCommaStr,
        gNeedi10n: false
      }, param[gBackgroundColor]));
      result.add(SizedBox(width: 10.0));
    }
    if (param[gTypeOwner] == gForm) {
      result.add(Expanded(child: param[gWidget]));
    } else {
      result.add(param[gWidget]);
    }
    if (param[gItem][gSuffixIcon] != null) {
      result.add(param[gItem][gSuffixIcon]);
    } else if (param[gTypeOwner] == gForm) {
      result.add(SizedBox(width: 50.0));
    }
    int widgetLength = result.length;
    if (!isNull(param[gAlert]) && param[gTypeOwner] != gForm) {
      widgetLength++;
    }
    if (widgetLength < 2) {
      return param[gWidget];
    }
    param[gWidget] = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: result);
    if (!isNull(param[gAlert]) &&
        (param[gTypeOwner] == gForm || param[gIsLabel])) {
      param[gWidget] = Column(children: [
        param[gWidget],
        MyLabel({
          gLabel: param[gAlert],
          gFontSize: _defaultFontSize,
          gColorLabel: Colors.red
        }, -1)
      ]);
    }
    return param[gWidget];
  }

  addZzylog(data, context) {
    //merget data
    var timestamp = data[gTimestamp];
    if (data[gUpdate] != null) {
      List list = data[gUpdate];
      list.forEach((element) {
        Map aMap = Map.of(element);
        var tablename = aMap.entries.first.key;
        Map rowData = Map.of(aMap.entries.first.value);
        var tableInfo = _tableList[tablename];
        List tableData = tableInfo![gData];
        tableInfo[gTimestamp] = timestamp;
        tableData.forEach((element1) {
          if (element1[gId] == rowData[gId]) {
            element1 = rowData;
          }
        });

        //update the table row
      });
    }
    if (data[gNew] != null) {
      List list = data[gNew];
      list.forEach((element) {
        Map aMap = Map.of(element);
        var tablename = aMap.entries.first.key;
        Map rowData = Map.of(aMap.entries.first.value);
        var tableInfo = _tableList[tablename];
        List tableData = tableInfo![gData];
        tableInfo[gTimestamp] = timestamp;
        bool findRow = false;
        tableData.forEach((element1) {
          if (element1[gId] == rowData[gId]) {
            element1 = rowData;
            findRow = true;
          }
        });
        if (!findRow) {
          tableInsert(tablename, rowData, context);
        }
      });
    }
    if (data[gDelete] != null) {
      List list = data[gDelete];
      list.forEach((element) {
        Map aMap = Map.of(element);
        var tablename = aMap.entries.first.key;
        Map rowData = Map.of(aMap.entries.first.value);
        var tableInfo = _tableList[tablename];
        //List tableData = tableInfo[gData];
        tableInfo![gTimestamp] = timestamp;
        //tableData.removeWhere((element1) => element1[gId] == rowData[gId]);
        tableRemove(tablename, rowData, context);
      });
    }
  }

  afterSubmit(context, _formName, result) {
    Map<dynamic, dynamic> formDefine = _formLists[_formName]!;
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

  afterTableAdded(tablename, context) {
    List tableData = _tableList[tablename]![gData];
    for (int i = 0; i < tableData.length; i++) {
      Map row = tableData[i];
      afterTableInsert(tablename, row, context);
    }
  }

  afterTableInsert(tablename, Map row, context) {
    if (tablename == gZzyi10nlist) {
      var sourceChck = row[gName];
      if (_i10nMap[sourceChck] == null) {
        _i10nMap[sourceChck] = {};
      }
      row.entries.forEach((element) {
        if (element.key.indexOf(gZzyi10nitemPrefix) == 0) {
          var langcode = element.key.substring(gZzyi10nitemPrefix.length);
          _i10nMap[sourceChck][langcode] = element.value;
        }
      });
    } else if (tablename.indexOf('Zzylog_') == 0) {
      setValue(tablename, 'changefrom', row[gId], row['changeto']);
      setValue(tablename, 'action', row[gId], row['colname']);
      row['changeto'] = '';
      row['colname'] = '';
    }
  }

  backContext(lastFocus, context, lastid) {
    _myDetailIDCurrent = lastid;
    setFocusNode(new Map<dynamic, dynamic>.of(lastFocus), context);
    print('============= back to ' +
        _myDetailIDCurrent.toString() +
        " , mFocusNode" +
        _mFocusNode.toString());
    finishme(context);
    myNotifyListeners();
  }

  Future<void> alert(BuildContext context, dynamic msg) async {
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

  beforeSubmit(context, _formName, result) {}

  buildDraggable(context, view) {
    return new Draggable(
      child: view,
      feedback: view,
      onDragStarted: () {},
      onDragEnd: (detail) {
        createDragTarget(offset: detail.offset, context: context, view: view);
      },
      childWhenDragging: Container(),
      ignoringFeedbackSemantics: false,
    );
  }

  businessFunc(funcName, context, data) {
    if (funcName == "forgetpassword") {
      forgetpassword(context);
    }
  }

  cancelTableModify(data, context) async {
    var tableName = data[gActionid] ?? data[gTableID];
    var id = data[gRow][gId];
    cancelTableModifyByType(tableName, id, context, gDataModified);
    cancelTableModifyByType(tableName, id, context, gDataModifiedInvalid);
    getTableFloatingBtns(tableName, context);
    myNotifyListeners();
  }

  cancelTableModifyByType(tableName, id, context, type) async {
    Map dataModified = _tableList[tableName]![type];
    if (!isNull(dataModified)) {
      dataModified.remove(id);
    }
  }

  changePassword(context, data, backcolor) async {
    if (data != null && data.length > 0 && data[0][gLastaction] == gFinishme) {
      await finishme(context);
    }
    await openDetailForm(gChangepassword, context, backcolor);
  }

  changeTabPos(tabName, tabLabel) {
    List tabData = _tabList[tabName][gData];
    int iLoc = 0;
    Map mLoc = {};
    for (int i = 0; i < tabData.length; i++) {
      Map el = tabData[i];
      if (el[gLabel] == tabLabel) {
        iLoc = i;
        mLoc = el;
      }
    }
    if (iLoc > 1) {
      while (iLoc > 1) {
        tabData[iLoc] = tabData[iLoc - 1];
        iLoc--;
      }
      tabData[iLoc] = mLoc;
    }

    _tabList[tabName][gTabIndex] = iLoc;
  }

  /*checkFormStatus(name, item, text) {
    bool oldStatus = _formLists[name][gStatus];
    bool newStatus = _formLists[name][gKey].currentState.validate();
    bool needRefresh = oldStatus != newStatus;
    _formLists[name][gStatus] = newStatus;
    if (needRefresh) {
      myNotifyListeners();
    }

    //print('========   checkFormStatus:' + _formLists[name][gStatus].toString());
  }*/

  clear(context) async {
    //print('  ================== clear');
    _token = '';
    _myId = '';
    _myDBId = '';
    _formLists = {};
    _tabList = {};
    _tableList = {};
    //Widget _tabWidget;
    _actionLists = {};
    _menuLists = {};
    _dpList = {};
    clearMFocusNode(context);

    removeAllScreens(context);
  }

  clearActionBtnMap(name) {
    _actionBtnMap[name] = [];
  }

  clearActionBtnMapAll() {
    _actionBtnMap = {};
  }

  clearMFocusNode(context) {
    setFocusNode({gType: null}, context);
    clearActionBtnMapAll();
  }

  clearTable(tablename) {
    dynamic tableInfo = _tableList[tablename];
    tableInfo![gDataSearch] = null;
    tableInfo![gTableMapPrefix] = null;
  }

  createDragTarget({offset, context, view}) {
    removeOverlay();

    overlayEntry = new OverlayEntry(builder: (context) {
      bool isLeft = true;
      if (offset.dx + 100 > MediaQuery.of(context).size.width / 2) {
        isLeft = false;
      }
      double maxY = MediaQuery.of(context).size.height - 100;

      return new Positioned(
          top: offset.dy < 50
              ? 50
              : offset.dy < maxY
                  ? offset.dy
                  : maxY,
          left: isLeft ? 0 : null,
          right: isLeft ? null : 0,
          child: DragTarget(
              onWillAccept: (data) {
                return true;
              },
              onAccept: (data) {},
              onLeave: (data) {},
              builder: (BuildContext context, List incoming, List rejected) {
                return buildDraggable(context, view);
              }));
    });
    Overlay.of(context).insert(overlayEntry!);
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

  Future<List> downloadAddress(searchTxt, context, haveNext) async {
    var searchType = "SearchTerm";
    List tmpListAddress = [];
    bool needFindUS = false;
    if (haveNext ?? false) {
      searchType = "LastId";
    } else {
      needFindUS = true;
    }
    List tmpListAddress1 =
        await downloadAddressDetail(searchType + "=" + searchTxt, context);
    if (tmpListAddress1.length > 0) {
      tmpListAddress1.forEach((element) {
        tmpListAddress.add(element);
      });
    }
    if (needFindUS) {
      List tmpListAddress2 = await downloadAddressDetail(
          searchType + "=" + searchTxt + "&Country=US", context);
      if (tmpListAddress2.length > 0) {
        tmpListAddress2.forEach((element) {
          tmpListAddress.add(element);
        });
      }
    }
    List<dynamic> result = [];
    //result.add('');
    for (int i = 0; i < tmpListAddress.length; i++) {
      dynamic element = tmpListAddress[i];
      if (element["Next"] == "Find") {
        List resultSub = await downloadAddress(element["Id"], context, true);
        resultSub.forEach((element1) {
          result.add(element1);
        });
      } else {
        var address = element["Text"] + " " + element["Description"];
        result.add(address);
      }
    }
    return result;
  }

  Future<List> downloadAddressDetail(param, context) async {
    List result = [];
    try {
      dynamic myUrl = MyConfig.URLAddress.name + param;
      //Uri uri = new Uri.http(MyConfig.URL.name,MyConfig.DOWNLOAD.name + '?filename=$filename' + filename);
      //waitDialog(context);
      Response response = (await httpClient.get(Uri.parse(myUrl)));
      //waitDialogClose(context);
      //var response = await request;
      if (response.statusCode == 200) {
        Utf8Decoder decode = new Utf8Decoder();
        Map data = Map.of(jsonDecode(decode.convert(response.bodyBytes)));
        if (data.isEmpty) {
          return result;
        }
        List itemList = data["Items"];
        if (itemList.length < 1) {
          return result;
        }
        itemList.forEach((element) {
          Map oneItem = Map.of(element);
          result.add(oneItem);
        });
      } else {
        showMsg(context, 'Error code: ' + response.statusCode.toString(), null);
      }
    } catch (ex) {
      showMsg(context, ex.toString(), null);
    }
    //result = getArrayMatch(result, param);
    return result;
    //print('======== filePath is $filePath');
  }

  Future downloadFile(filename, context, needRemove, subject) async {
    dynamic filePath = '';

    try {
      dynamic myUrl = 'http://' +
          MyConfig.URL.name +
          '/' +
          MyConfig.DOWNLOAD.name +
          '?filename=$filename&needRemove=$needRemove';

      //Uri uri = new Uri.http(MyConfig.URL.name,MyConfig.DOWNLOAD.name + '?filename=$filename' + filename);
      //waitDialog(context);
      Response response = (await httpClient.get(Uri.parse(myUrl)));
      //waitDialogClose(context);
      //var response = await request;
      if (response.statusCode == 200) {
        var bytes = response.bodyBytes;
        //await consolidateHttpClientResponseBytes(response);
        //Directory dir = await getApplicationDocumentsDirectory();
        Directory dir = await getTemporaryDirectory();
        dynamic tempPath = dir.path;

        filePath = '$tempPath/$filename';
        File file = File(filePath);
        await file.writeAsBytes(bytes);
        navigatorPush(context, PDFScreen({gPath: filePath, gSubject: subject}),
            'downloadFile');
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PDFScreen({gPath: filePath, gSubject: subject}),
          ),
        );*/
      } else {
        showMsg(context, 'Error code: ' + response.statusCode.toString(), null);
      }
    } catch (ex) {
      showMsg(context, ex.toString(), null);
    }
    //print('======== filePath is $filePath');
  }

  dpListInsert(tablename, element, context) {
    if (!_dpList.containsKey(tablename)) {
      List tmp = [''];
      _dpList[tablename] = tmp;
    }
    _dpList[tablename].add(element[gId]);

    _i10nMap[element[gId]] = {
      _locale: getTableKeyword(tablename, element[gId], context)
    };
    if (_dpList.containsKey(gZzyLanguageCode)) {
      List languagecodeList = _dpList[gZzyLanguageCode];
      languagecodeList.forEach((element1) {
        _i10nMap[element[gId]][element1] =
            getTableKeyword(tablename, element[gId], context);
      });
    }
  }

  dpListRemove(tablename, row, context) {
    _dpList[tablename].removeWhere((element1) => element1 == row[gId]);
    _i10nMap.removeWhere((key, value) => key == row[gId]);
  }

  encryptByDES(datalist) {
    var key = _sessionkey;
    var json = jsonEncode(datalist); //.toString();
    var message = json;
    print('==request is:' + message);
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
    print('============ finishme');
    Navigator.pop(context);

    /*if (Navigator == null || Navigator.canPop(context)) {
      print('============ canPop');
      clear(context);
    }*/
  }

  //Widget
  firstWidget(context) {
    if (_sessionkey == '') {
      _requestCnt = 0;
      resetSessionKey(context);
      //} else {
    }
    return _firstPage;
  }

  forgetpassword(context) {
    var email = getValue(gLogin, gEmail, null)[gValue];
    if (email != null && email.length > 0) {
      this.sendRequestOne(gForgetpassword, email, context);
    } else {
      showMsg(context, getSCurrent(gPlsenteremail), null);
    }
  }

  formSubmit(BuildContext context, formid) async {
    //unfocus all the item
    //setFormAllFocusFalse(formid);
    //try {
    //print('        ------------------    formSubmit 0');

    Map<dynamic, dynamic> obj = _formLists[formid]![gItems];
    var changed = false;
    var data = {};
    data[gFormid] = formid;
    data[gId] = (obj[gId] != null) ? obj[gId][gValue] : '';
    data[gOptLock] = '';
    if (obj[gOptLock] != null) {
      data[gOptLock] = obj[gOptLock][gValue] ?? '';
    }
    data[gOptLock] = (obj.containsKey(gOptLock)) ? obj[gOptLock][gValue] : '';
    //print('        ------------------    formSubmit 1');
    for (int i = 0; i < obj.entries.length; i++) {
      MapEntry<dynamic, dynamic> element = obj.entries.elementAt(i);

      /*}
    obj.entries.forEach((MapEntry<dynamic, dynamic> element) {*/
      //var key = element.entries.first.key;
      var item = element.value;
      var type = item[gType];
      if (type == gId) {
        data[gId] = item[gValue];
      } else if (item[gType] == gLabel) {
      } else if (item[gType] == gHidden) {
      } else if (item[gDbid] != null && item[gDbid] != '') {
        var value = getValue(formid, item[gId], data[gId])[gValue];

        var alert = isItemValueValidStr(item, value);
        if ((alert ?? '') != '') {
          showMsg(context, alert, null);
          setFocus(formid, item[gId], null, true, context);
          return;
        }

        //data[objI[gDbid]] = value;
        if (item[gHash] != null && item[gHash]) {
          value = hash(value);
        }
        if (type == gDate && !isNull(value)) {
          //value = value.format(gDateformat);
          //data[objI[gDbid]] =
          //  DateFormat(gDateformat).format(value);
        } else if (type == gDatetime) {
          value = toUTCTime(value);
        }
        var oldValue = getValueOriginal(formid, item[gId], data[gId]);
        if (isNull(oldValue)) {
          oldValue = '';
        }

        if (value == null) {
          value = '';
        }

        if (item[gId] != '' && item[gIsPrimary] != null && item[gIsPrimary]) {
          data[item[gDbid]] = oldValue;
        }
        if (value != oldValue) {
          changed = true;
          data[item[gDbid]] = value;
        } else if (isNull(data[gId])) {
          data[item[gDbid]] = value;
        }
      }
    }
    //print('        ------------------    formSubmit 2');
    if (changed) {
      //console.log(data);
      if (formid == gChangepassword || formid == gResetpassword) {
        var password = data[gPassword];
        var password1 = data[gPassword1];

        if (password1 != password) {
          showMsg(context, getSCurrent(gPasswordnotmatch), null);
          return;
        }
        _myId = getValue(formid, gEmail, null)[gValue];
        if (isNull(_myId)) {
          return;
        }
      }

      //set to default value if empty
      obj.entries.forEach((MapEntry<dynamic, dynamic> element) {
        //var key = element.entries.first.key;
        var objI = element.value;
        if (objI[gId] != '' &&
            //objI[gIsPrimary] != null &&
            //objI[gIsPrimary] &&
            (isNull(data[objI[gId]])) &&
            isNull(objI[gValue]) &&
            !isNull(objI[gDefaultValue])) {
          data[objI[gId]] = objI[gDefaultValue];
        }
      });
      //send request;
      //print('        ------------------    formSubmit 3');
      sendRequestFormChange(data, context); //refresh Form
      return;
    }
    alert(context, gNochange);
    /*} catch (e) {
      print('======exception is ' + e.toString());
      //throw e;
      showMsg(context, e, null);
    }*/
  }

  fromBdckcolor(iColor) {
    if (iColor == null) {
      return Color.fromARGB(255, 83, 48, 48);
    }
    Color? result = _bdBackColorList[iColor];
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

  Color fromInt(dynamic strColor) {
    int intColor = getInt(strColor);
    //print('=== intColor is $intColor');
    return Color(intColor);
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

  getActionButtons(param, myid) {
    if (_actionBtnMap.length < 1) {
      return;
    }
    if (param == null) {
      return null;
    }
    /*print('======runtimetype is ' + param.runtimeType.toString());
    if (param.runtimeType.toString() == '_Map<dynamic, dynamic>') {
      Map<dynamic, dynamic> itemsMap = param;
      itemsMap.entries.forEach((itemOne) {
        Map item = itemOne.value;
        var type = item[gType] ?? '';
        if (type == gForm || type == gTable) {
          var value = item[gValue] ?? '';
        }
      });
    }*/
    if (isNull(_mFocusNode[gType])) {
      return;
    }
    if (isNull(_mFocusNode[gName])) {
      return;
    }
    if (_actionBtnMap[_mFocusNode[gName]] == null) {
      return;
    }
    List<Widget> list = _actionBtnMap[_mFocusNode[gName]]!;
    if (list.length < 1) {
      return;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: list,
    );
  }

  getActions(List param, context, int backcolor) {
    List<Widget> result = getLocalComponentsList(context, backcolor);
    dynamic actions = getActionsBasic(param, context, backcolor);
    if (actions != null) {
      for (int i = 0; i < actions.length; i++) {
        result.add(actions[i]);
      }
    }
    return result;
  }

  getActionsBasic(List? param, context, int backcolor) {
    List<Widget> result = [];
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

  getArrayMatch(List list, var msg) {
    List msgList = msg.toString().toLowerCase().split(" ");
    Map temp = {};
    list.forEach((element) {
      temp.putIfAbsent(element,
          () => getStrDistance(element.toString().toLowerCase(), msgList));
    });
    Map mapKeys = getMapSortByValue(temp, true);
    List valueList = mapKeys.values.toList();
    Map mapNew = {};
    temp.forEach((key, value) {
      List mapNewValue = [];
      if (mapNew.containsKey(value)) {
        mapNewValue = mapNew[value];
      } else {
        mapNew[value] = mapNewValue;
      }
      mapNewValue.add(key);
    });
    List result = [];
    for (int i = 0; i < valueList.length; i++) {
      List mapNewValue = mapNew[valueList[i]];
      for (int j = 0; j < mapNewValue.length; j++) {
        result.add(mapNewValue[j]);
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

      list.add(MyButton(element));
    });

    return list;
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

  getCardTitle(data, backcolor) {
    return MyLabel({
      gLabel: data[gLabel],
    }, backcolor);
  }

  /*getDataWhere(List newData, aWhere) {
    List result = [];
    dynamic param = aWhere.split('=');
    dynamic value0 = param[1];
    dynamic value1 = value0;
    if (value0[0] == "'") {
      value1 = value1.substring(1, value1.length - 1);
    }
    newData.forEach((element) {
      if (element[param[0]] == value1 || element[param[0]] == value0) {
        result.add(element);
      }
    });
    return result;
  }*/

  getDatePicker(aDate, backcolor, context, formname, id, actions) {
    if (isNull(aDate)) {
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      aDate = formatter.format(now);
    }
    setDplistYear();
    List selectedIndex = [-1, -1, -1];
    List sList = [gYear, gMonth, gDay];
    for (int i = 0; i < sList.length; i++) {}
    List sListValue = aDate.split('-');
    if (sListValue.length < 2) {
      sListValue.add('');
    }
    if (sListValue.length < 3) {
      sListValue.add('');
    }
    for (int j = 0; j < sList.length; j++) {
      for (int i = 0; i < _dpList[sList[j]].length; i++) {
        if (_dpList[sList[j]][i].toString().indexOf(sListValue[j].toString()) >
            -1) {
          selectedIndex[j] = i;
          _dpListDefaultIndex[sList[j]] = i;
          break;
        }
      }
    }

    Map param = {
      gAction: gLocalAction,
      gAction1: gDroplist,
      gHeight: null,
      gSelectedList: selectedIndex,
      gData: sList,
      gWidth: [100.0, 80.0, 80.0],
      gFormName: formname,
      gId: id,
      gType: gDate
    };
    Widget result = MyListPicker(param, backcolor);
    return result;
  }

  getDatePickerItems(sizeList, sList, backcolor, selectedIndex, context,
      formname, id, typeOwner) {
    List<Widget> result = [];

    for (int i = 0; i < sizeList.length; i++) {
      List<Widget> subList = [];
      List list = _dpList[sList[i]];
      result.add(Text(''));
      for (int j = 0; j < list.length; j++) {
        bool isSelected = false;
        if (selectedIndex[i] > -1 && selectedIndex[i] == j) {
          isSelected = true;
        }
        subList.add(isSelected
            ? Text((i == 1) ? _monthMap[list[j]] : list[j])
            : InkWell(
                child: MyLabel({
                  gLabel: (list[j].indexOf('~') > 0)
                      ? ' * * * '
                      : (i == 1)
                          ? _monthMap[list[j]]
                          : list[j],
                  gIsBold: 'true'
                }, backcolor),
                onTap: () {
                  if (list[j].indexOf('~') > 0) {
                    _dpList[sList[i]] = addToList(list, list[j]);
                    myNotifyListeners();

                    return;
                  }
                  //var data = getFormValue(formname, id);
                  //var data = getValueOriginal(formname, id, null, gForm);
                  var data = getValue(formname, id, null)[gValue];
                  List dateList = [];
                  if (data != null && data.length > 0) {
                    dateList = data.split('-');
                  }
                  if (dateList.length < 1) {
                    dateList.add('');
                  }
                  if (dateList.length < 2) {
                    dateList.add('');
                  }
                  if (dateList.length < 3) {
                    dateList.add('');
                  }
                  dateList[i] = list[j];

                  if (dateList[2] == '31') {
                    if (dateList[1] == '02' ||
                        dateList[1] == '04' ||
                        dateList[1] == '06' ||
                        dateList[1] == '09' ||
                        dateList[1] == '11') {
                      dateList[2] = '';
                    }
                  } else if (dateList[2] == '30') {
                    if (dateList[1] == '02') {
                      dateList[2] = '';
                    }
                  } else if (dateList[2] == '29') {
                    if (dateList[1] == '02') {
                      if (dateList[0].length < 4) {
                        dateList[2] = '';
                      } else {
                        int iYear = getInt(dateList[0]);
                        if (iYear % 4 > 0) {
                          dateList[2] = '';
                        }
                      }
                    }
                  }
                  setValue(formname, id, null,
                      dateList[0] + '-' + dateList[1] + '-' + dateList[2]);
                  if (dateList[2] != '') {
                    //close the detail
                    //setFormValueShow(formname, id);
                    setFocusNext(formname, id, null, false, context);

                    myNotifyListeners();
                    return;
                  }

                  myNotifyListeners();
                },
              ));
      }
      result.add(Wrap(
          spacing: 10.0, //gap between adjacent items
          runSpacing: 20.0, //gap between lines
          direction: Axis.horizontal,
          children: subList));
    }

    return result;
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

  getDpDataSearch(dpid, isIcon, isLabel) {
    dynamic searchTxt = _dpListSearch[dpid] ?? '';
    List dataListOriginal = List.of(_dpList[dpid]);

    List dataList = [];
    if (isNull(searchTxt)) {
      dataList = dataListOriginal;
    } else {
      for (int j = 0; j < dataListOriginal.length; j++) {
        dynamic dj = dataListOriginal[j];
        var value = dj;
        if (isIcon) {
          value = getSCurrent(dj[gLabel]);
        } else if (!isLabel && dj != '') {
          var value0 = getSCurrent(dj);
          value = getSCurrent(value0);
        }
        if (dj == '' || value.toString().contains(searchTxt)) {
          dataList.add(dj);
        }
      }
    }
    return dataList;
  }

  getDPidfromItem(item) {
    if (item[gType] == gAddress) {
      return gDpAddress;
    } else if (item[gType] == gIcon) {
      return gDpIcon;
    }
    var droplist = item[gDroplist];
    if (droplist != null && droplist.indexOf("[") > 0) {
      return droplist.substring(0, droplist.indexOf("["));
    }

    return null;
  }

  getDPIndex(i, item) {
    var dpid = getDPidfromItem(item);
    bool isLabel = false;
    bool isIcon = false;
    if (item[gType] == gAddress) {
      isLabel = true;
    } else if (item[gType] == gIcon) {
      isIcon = true;
    }
    List data = getDpDataSearch(dpid, isIcon, isLabel);
    return data[i];
  }

  getDpListByKey(key, context, value) {
    List result = [];
    if (!_dpList.containsKey(key)) {
      if (key == gDpIcon) {
        setDplistIcon();
      }
    }

    if (_dpList.containsKey(key)) {
      result = _dpList[key] ?? [];
    }

    if (result.length < 1) {
      result.add(value);
    }

    return result;
  }

  getDPPicker(item, backcolor, context, formname, id, actions) {
    var dpid = getDPidfromItem(item);
    bool isLabel = false;
    bool isIcon = false;
    if (item[gType] == gAddress) {
      isLabel = true;
    } else if (item[gType] == gIcon) {
      isIcon = true;
    }
    List sList = getDpListByKey(dpid, context, item[gValue]);
    int selectedIndex = -1;

    var value =
        getValue(_mFocusNode[gName], _mFocusNode[gCol], _mFocusNode[gId]);
    _dpListDefaultIndex[dpid] = -1;
    for (int i = 0; i < sList.length; i++) {
      selectedIndex = 0;
      _dpListDefaultIndex[dpid] = 0;
      if (sList[i] == value) {
        selectedIndex = i;
        _dpListDefaultIndex[dpid] = i;
        break;
      }
    }
    bool isSearch = false;
    if (isIcon) {
      isSearch = true;
    }
    Map param = {
      gAction: gLocalAction,
      gAction1: gDroplist,
      gHeight: null,
      gSelectedList: [selectedIndex],
      gData: [dpid],
      gWidth: [null],
      gFormName: formname,
      gId: id,
      gType: gDate,
      gIsLabel: isLabel,
      gIsIcon: isIcon,
      gSearch: isSearch
    };
    Widget result = MyListPicker(param, backcolor);

    return result;
  }

  static String getFormatter(value, type) {
    if (type == gDate) {
      String nums = value.replaceAll(RegExp(r'[\D]'), '');
      String sSeg = '-';
      List listFormat = [];
      listFormat.add({
        'locFrom': 0,
        'locTo': 4,
        'type': 'i',
        'min': 1900,
        'max': 3000,
        'value:': ''
      });
      listFormat.add({
        'locFrom': 4,
        'locTo': 6,
        'type': 'm',
        'min': 1,
        'max': 12,
        'value:': ''
      });
      listFormat.add({
        'locFrom': 6,
        'locTo': 8,
        'type': 'd',
        'min': 1,
        'max': 31,
        'value:': ''
      });
      String result = '';

      if (nums.length < 5) {
        return nums;
      }
      if (nums.length == 5) {
        String lastChar = nums.characters.last;
        result = nums.substring(0, 4) + sSeg;
        if (int.parse(lastChar) > 1) {
          result = result + '0';
        }
        result = result + lastChar;
        return result;
      }
      if (nums.length == 6) {
        result = nums.substring(0, 4) + sSeg;
        int iValue = int.parse(nums.substring(4, 6));
        if (iValue > 12 || iValue < 1) {
          return nums.substring(0, 4);
        }
        result = result + nums.substring(4, 6);
        return result;
      }
      if (nums.length == 7) {
        String lastChar = nums.characters.last;
        result = nums.substring(0, 4) + sSeg + nums.substring(4, 6) + sSeg;
        if (int.parse(lastChar) > 3) {
          result = result + '0';
        }
        result = result + lastChar;
        return result;
      }
      if (nums.length > 7) {
        result = nums.substring(0, 4) + sSeg + nums.substring(4, 6);
        int iValue = int.parse(nums.substring(6, 8));
        if (iValue > 31 || iValue < 1) {
          return result;
        }
        if (iValue > 28) {
          int month = int.parse(nums.substring(4, 6));
          if (month == 2) {
            int year = int.parse(nums.substring(0, 4));
            if (year % 4 > 0) {
              return result;
            }
          }
          if (iValue == 31 &&
              (month == 4 || month == 6 || month == 9 || month == 11)) {
            return result;
          }
        }
        result = result + sSeg + nums.substring(6, 8);
        return result;
      }
      return nums;
    } else if (type == gPhone) {
      String nums = value.replaceAll(RegExp(r'[\D]'), '');
      String internationalPhoneFormatted = nums.length >= 1
          ? (nums.length > 0 ? '(' : '') +
              nums.substring(0, nums.length >= 3 ? 3 : null) +
              (nums.length > 3 ? ')' : '') +
              (nums.length > 3
                  ? nums.substring(3, nums.length >= 6 ? 6 : null) +
                      (nums.length > 6
                          ? '-' +
                              nums.substring(6, nums.length >= 10 ? 10 : null)
                          : '')
                  : '')
          : nums;
      return internationalPhoneFormatted;
    }
    return value;
  }

  getFormDefineImage(formValue) {
    return getTxtImage(
        formValue[gTitle][gLabel],
        _lastBackGroundColor,
        formValue[gTitle][gFontSize],
        formValue[gTitle][gHeight],
        formValue[gTitle][gLetterSpacing]);
  }

  getFormItem(name, colId) {
    Map<dynamic, dynamic> formDefine = _formLists[name]!;
    Map<dynamic, dynamic> items = formDefine[gItems];
    items.entries.forEach((itemOne) {
      dynamic item = itemOne.value;
      if (item[gId] == colId) {
        //result = item;
        return item;
      }
    });
    return {};
  }

  getFormOneItem(
      items, colname, dataRow, tableName, value, isModified, originalValue) {
    items.entries.forEach((itemOne) {
      if (itemOne.value[gId] == colname) {
        Map item = itemOne.value;
        //item[gShowDetail] = false;

        item[gValue] = value;
        return item;
      }
    });
    return null;
  }

  /* getFormValue(formid, dbid) {
    return getValueOriginal(formid, dbid, null, gForm);

  }*/

  getFocus(name, item) {
    var typeOwner = gForm;
    if (_tableList[name] != null) {
      typeOwner = gTable;
    }
    if ((_mFocusNode[gType] ?? '') == typeOwner &&
        (_mFocusNode[gName] ?? '') == name &&
        (_mFocusNode[gCol] ?? '') == item[gId]) {
      return true;
    }
    return false;
  }

  getGrayLevel(int intColor) {
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

  getImg(param, backColorValue) {
    if (param[gValue].toString().indexOf('http') >= 0) {
      return MyPic({gImg: param[gValue], gHeight: 32.0, gWidth: 32.0});
    } else {
      return MyIcon({
        gValue: param[gValue],
        gColor: (param[gColor] ?? fromBdckcolor(backColorValue))
      });
    }
  }

  getImgCompany() {
    var logo = getTableRowByID(gZzycompany, _globalCompanyid)[gLogo];
    return getImg({gValue: logo}, Colors.black.value);
  }

  getInputType(s) {
    if (isPopOpen() && (s ?? '') != gSearch) {
      return TextInputType.none;
    }
    if (s == gVisiblePassword) {
      return TextInputType.visiblePassword;
    } else if (s == gEmailAddress) {
      return TextInputType.emailAddress;
    } else if (s == gDatetime) {
      return TextInputType.datetime;
    } else if (s == gMultiline) {
      return TextInputType.multiline;
    } else if (s == gName) {
      return TextInputType.name;
    } else if (s == gNumber) {
      return TextInputType.number;
    } else if (s == gPhone) {
      return TextInputType.phone;
    } else if (s == gAddress) {
      return TextInputType.streetAddress;
    } else if (s == gUrl) {
      return TextInputType.url;
    } else if (s == gValues) {
      return TextInputType.values;
    }

    return TextInputType.text;
  }

  getInt(s) {
    //print('=========== getInst s is ' + s.toString());
    if (isNull(s.toString())) {
      return 0;
    }
    return int.parse(s.toString());
  }

  getItemFormatters(Map item) {
    if ((item[gType] ?? "") == gPhone) {
      return [InternationalPhoneFormatter()];
    } else if ((item[gType] ?? "") == gDate) {
      return [DateFormatter()];
    }
    return null;
  }

  getItemIcon(Map param, context) {
    //不合法(空或非法)，或非焦点,则不显示图标  -- 邮箱，电话，URL
    if (!param[gFocus]) {
      param[gItem][gSuffixIcon] = null;
      return;
    }
    if (isItemEmail(param[gItem])) {
      if (!isNull(param[gAlert]) || isNull(param[gValue])) {
        param[gItem][gSuffixIcon] = null;
        return;
      }
      if (param[gItem][gSuffixIcon] == null) {
        param[gItem][gSuffixIcon] = IconButton(
            icon: Icon(Icons.email_outlined
                //color: Theme.of(context).disabledColor,
                ),
            onPressed: () {
              sendEmailItem();
            });
      }
      return;
    }

    if (param[gItem][gType] == gPhone) {
      if (!isNull(param[gAlert]) || isNull(param[gValue])) {
        param[gItem][gSuffixIcon] = null;
        return;
      }
      if (param[gItem][gSuffixIcon] == null) {
        param[gItem][gSuffixIcon] = IconButton(
            icon: Icon(Icons.phone_outlined),
            onPressed: () {
              phonecallItem();
            });
      }
      return;
    }

    if (param[gItem][gType] == gUrl) {
      if (!isNull(param[gAlert]) || isNull(param[gValue])) {
        param[gItem][gSuffixIcon] = null;
        return;
      }
      if (param[gItem][gSuffixIcon] == null) {
        param[gItem][gSuffixIcon] = IconButton(
            icon: Icon(Icons.web_outlined),
            onPressed: () {
              loadUrlItem();
            });
      }
      return;
    }
    if (param[gItem][gType] == gIcon) {
      if (param[gItem][gSuffixIcon] == null) {
        var value = getValue(
            _mFocusNode[gName], _mFocusNode[gCol], _mFocusNode[gId])[gValue];
        param[gItem][gSuffixIcon] = Row(
          children: [
            IconButton(
                icon: Icon(Icons.image_search_outlined),
                onPressed: () {
                  showPopupItem(
                      param[gItem],
                      _mFocusNode[gTypeOwner],
                      _mFocusNode[gName],
                      value,
                      _mFocusNode[gId],
                      null,
                      context,
                      true);
                }),
            SizedBox(width: 5.0),
            IconButton(
                icon: Icon(Icons.file_upload_outlined),
                onPressed: () {
                  try {
                    loadFile(
                        _mFocusNode[gName], param[gItem], param[gId], context);
                  } catch (e) {
                    showMsg(context, e.toString(), null);
                  }
                }),
          ],
        );

        /*        result.insert(
      0,
      {gLabel: 'upload image', gValue: 0},
    );*/
      }
      return;
    }

    if (param[gItem][gType] == gDate) {
      var value = getValue(
          _mFocusNode[gName], _mFocusNode[gCol], _mFocusNode[gId])[gValue];
      showPopupItem(param[gItem], _mFocusNode[gTypeOwner], _mFocusNode[gName],
          value, _mFocusNode[gId], null, context, false);

      /*if (param[gItem][gSuffixIcon] == null) {
        param[gItem][gSuffixIcon] = IconButton(
            icon: Icon(Icons.date_range_outlined),
            onPressed: () {
              var value = getValue(_mFocusNode[gName], _mFocusNode[gCol],
                  _mFocusNode[gId])[gValue];
              showPopupItem(param[gItem], _mFocusNode[gTypeOwner],
                  _mFocusNode[gName], value, _mFocusNode[gId], null, context);
            });
      }*/
      return;
    }
    if (param[gItem][gType] == gAddress) {
      if (param[gItem][gSuffixIcon] == null) {
        param[gItem][gSuffixIcon] = IconButton(
            icon: Icon(Icons.place_outlined),
            onPressed: () {
              var value = getValue(_mFocusNode[gName], _mFocusNode[gCol],
                  _mFocusNode[gId])[gValue];
              if (isNull(value)) {
                return;
              }
              if ((value.toString()).length < 3) {
                return;
              }

              var dpid = gDpAddress;
              dpList[dpid] = [];
              //将焦点变为只读
              _mFocusNode[gIsLabel] = true;
              sendRequestOne(
                  gDroplist,
                  {
                    gType: gAddress,
                    //gType: gDroplist,
                    gValue: value,
                    gActionid: dpid,
                    gTypeOwner: _mFocusNode[gTypeOwner],
                    gName: _mFocusNode[gName],
                    gId: _mFocusNode[gId],
                    gCol: _mFocusNode[gCol]
                  },
                  context);

              /*showPopupItem(param[gItem], _mFocusNode[gTypeOwner],
                  _mFocusNode[gName], value, _mFocusNode[gId], null, context);*/
            });
      }
      return;
    }
//密码如果非焦点，不合法
    if (param[gItem][gType] == gPassword) {
      if (param[gItem][gSuffixIcon] == null) {
        param[gItem][gPasswordShow] = param[gItem][gPasswordShow] ?? true;

        param[gItem][gSuffixIcon] = IconButton(
            icon: Icon(
              param[gItem][gPasswordShow]
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Theme.of(context).disabledColor,
            ),
            onPressed: () {
              param[gItem][gPasswordShow] = !param[gItem][gPasswordShow];
              myNotifyListeners();
            });
        return;
      }
    }
    var droplist = param[gItem][gDroplist] ?? '';
    if (isNull(droplist)) {
      return;
    }
    if (param[gIsLabel] && isNullID(param[gId])) {
      return;
    }
    param[gItem][gSuffixIcon] = IconButton(
        icon: Icon((param[gItem][gType] == gSearch)
                ? Icons.content_paste_search_outlined
                : Icons.arrow_drop_down_circle_sharp

            //color: Theme.of(context).disabledColor,
            ),
        onPressed: () {
          _mFocusNode[gIsLabel] = true;
          var value = getValue(
              _mFocusNode[gName], _mFocusNode[gCol], _mFocusNode[gId])[gValue];
          showPopupItem(param[gItem], _mFocusNode[gTypeOwner],
              _mFocusNode[gName], value, _mFocusNode[gId], null, context, true);
        });
  }

  getItemSubWidget(
      Map item, typeOwner, name, context, id, backcolor, actions) async {
    backcolor = Colors.blue.value;

    //if (item[gType] == gDate && (item[gShowDetail] ?? false)) {
    if (item[gType] == gDate) {
      //item[gFocus] = true;
      Map param = {
        gId: id,
        gItem: item,
        gName: name,
        gRow: null,
        gTypeOwner: typeOwner
      };
      var value = getRowItemOneValue(param)[gValue];
      return getDatePicker(
          value ?? item[gValue], backcolor, context, name, item[gId], actions);
      //} else if (item[gDroplist] != '' && (item[gShowDetail] ?? false)) {
    } else if (item[gType] == gAddress ||
        item[gDroplist] != '' ||
        item[gType] == gIcon) {
      return getDPPicker(item, backcolor, context, name, item[gId], actions);
    }
    return SizedBox(
      height: 0.0,
    );
  }

  getLocalComponents(context, aColor) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: getLocalComponentsList(context, aColor));
  }

  getLocalComponentsList(context, valueColor) {
    return [
      isProcessing ? CircularProgressIndicator() : Icon(Icons.public_outlined),
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

  getMapSortByKey(Map map, bool isAsc) {
    final sortedKeys = SplayTreeMap.from(
        map,
        (keys1, keys2) => isAsc
            ? (keys1 ?? '').toString().compareTo((keys2 ?? '').toString())
            : (keys2 ?? '').toString().compareTo((keys1 ?? '').toString()));
    return sortedKeys;
  }

  getMapSortByValue(Map map, bool isAsc) {
    final sortedKeys = SplayTreeMap.from(
        map,
        (keys1, keys2) => isAsc
            ? map[keys1].compareTo(map[keys2])
            : map[keys2].compareTo(map[keys1]));
    return sortedKeys;
  }

  getMenuItems(dynamic menuName, context, backcolor) {
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

  getModifiedValueByType(name, colId, originalId, type, typeOwner) {
    Map dataModified;
    var id = isNull(originalId) ? gFakeId : originalId;
    if (typeOwner == gForm) {
      dataModified = _formLists[name]![type];
    } else {
      dataModified = _tableList[name]![type];
    }

    if (isNull(dataModified)) {
      return null;
    }
    Map value = {};
    if (dataModified.containsKey(id)) {
      value = dataModified[id];
    }
    if (isNull(value)) {
      return null;
    }
    if (value[colId] == null) {
      return null;
    }
    return value[colId];
  }

  getMyBody(name) {
    if (name == gMain) {
      if (initRequest == '') {
        List objList = [];
        objList.add({gType: gTab, gData: name});
      }
    }
    return null;
  }

  getMyItem(valueMap, context, backcolor) {
    if (valueMap[gType] == gImg) {
      dynamic imageValue = _imgList[valueMap[gValue]];
      if (imageValue == null) {
        setImage(valueMap[gValue], context);
      }
    } else if (valueMap[gType] == gForm) {
      dynamic form = _formLists[valueMap[gValue]];
      if (form == null) {
        setForm(valueMap[gValue], context);
      }
    }
    Widget result = MyItem(valueMap, backcolor);
    return result;
  }

  getParamTypeValue(param) {
    if (param == null) {
      param = {gType: gTitle};
    }
    param[param[gType]] = param[gValue];

    return param;
  }

  getPicker(_param, i, labelColor, backcolor) {
    dynamic dpid = _param[gData][i];
    //print('----dpid is ' + dpid.toString());
    bool isIcon = false;
    if (_param[gIsIcon] ?? false) {
      isIcon = true;
    }
    bool isLabel = false;
    if (_param[gIsLabel] ?? false) {
      isLabel = true;
    }

    //print('----searchTxt is ' + searchTxt.toString());

    List dataList = getDpDataSearch(dpid, isIcon, isLabel);
    return CupertinoPicker(
      scrollController:
          FixedExtentScrollController(initialItem: _param[gSelectedList][i]),
      //diameterRatio: 1.5,
      //offAxisFraction: 0.2, //轴偏离系数
      //useMagnifier: false, //使用放大镜
      //magnification: 1.5, //当前选中item放大倍数
      itemExtent: 40.0, //行高
      onSelectedItemChanged: (value) {
        dpListDefaultIndex[_param[gData][i]] = value;
        /*_param[gRow] = i;
              _param[gIndex] = value;
              _param[gSelectedList][i] = value;
              datamodel.sendRequestOne(
                  _param[gAction], _param, this._param[gContext] ?? context);*/
      },
      //children: datamodel.dpList[param[gData][i]].map((data) {
      children: (dataList).map((data) {
        return isLabel
            ? Text(data,
                style: TextStyle(
                  fontWeight: (isNull(_param[gIsBold]))
                      ? _param[gFontWeight]
                      : FontWeight.bold, //FontWeight.bold,
                  fontSize: _param[gFontSize],
                  color: labelColor,
                  //backgroundColor: Colors.transparent
                ))
            : isIcon
                ? Row(children: [
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(child: MyLabel({gLabel: data[gLabel]}, backcolor)),
                    Icon(
                        IconData(
                          data[gValue],
                          fontFamily: 'MaterialIcons',
                        ),
                        size: 36.0,
                        color: Colors.white),
                    SizedBox(
                      width: 5.0,
                    )
                  ])
                : MyLabel({gLabel: getSCurrent(data)}, backcolor);
      }).toList(),
    );
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

  Widget getRowItemOne(name, id, item, context, backColorValue, type) {
    Map info;
    var typeOwner = gForm;
    if (_tableList[name] != null) {
      typeOwner = gTable;
    }
    if (typeOwner == gForm) {
      info = formLists[name]!;
    } else {
      info = tableList[name]!;
    }
    if (isNull(info)) {
      return MyLabel(
          {gLabel: gNotavailable, gFontSize: _defaultFontSize}, backColorValue);
    }

    if ((item[gIsHidden] ?? "false") == gTrue) {
      return SizedBox(height: 5.0);
    }
    if ((item[gInputType] ?? item[gType]) == gHidden) {
      return SizedBox(height: 5.0);
    }
    if ((item[gInputType] ?? "") == gCode) {
      return MyPinCode(item, name);
    }

    var originalValue;
    bool isModified = false;
    bool needi10n = false;
    var droplist;
    bool isFocus = false;
    bool isReadonly = false;
    if (typeOwner != gForm && !info[gAttr][gCanEdit]) {
      isReadonly = true;
    }
    if (item[gType] == gLabel) {
      isReadonly = true;
    } else {
      if ((_mFocusNode[gIsLabel] ?? false) &&
          ((_mFocusNode[gName] ?? '') == name) &&
          (_mFocusNode[gCol] == item[gId]) &&
          ((id ?? '') == (_mFocusNode[gId] ?? ''))) {
        isReadonly = true;
      }
    }

    Map param = {
      gItem: item,
      gName: name,
      //gRow: row,
      gTypeOwner: (type == gForm) ? gForm : typeOwner,
      gBackgroundColor: backColorValue
    };
    droplist = item[gDroplist] ?? "";
    if (typeOwner == gForm) {
      //var colname = item[gId];
      id = id ?? getValueOriginal(name, gId, id);
      param[gId] = id;
      originalValue = getValueOriginal(name, item[gId], id);

      if (_mFocusNode[gType] == gForm &&
          _mFocusNode[gName] == name &&
          _mFocusNode[gCol] == item[gId]) {
        isFocus = true;
      }
    } else {
      var colname = item[gId];
      Map dataRow = getTableRowByID(name, id);
      originalValue = getValueOriginal(name, colname, id);

      if (_mFocusNode[gType] == typeOwner &&
          _mFocusNode[gName] == name &&
          _mFocusNode[gCol] == colname &&
          _mFocusNode[gId] == id) {
        /*if (!isNull(info[gTableItemRow]) && dataRow[gId] == id
          //&&          colname == info[gTableItemColName]
          ) {*/
        Map<dynamic, dynamic> formDefine = formLists[name]!;
        Map<dynamic, dynamic> formItems = formDefine[gItems];
        item = getFormOneItem(formItems, colname, dataRow, name, param[gValue],
            isModified, originalValue);
        isFocus = true;
      }
    }
    param[gFocus] = isFocus;
    param[gId] = id;
    dynamic aValue = getRowItemOneValue(param);
    param[gValue] = aValue[gValue];
    param[gType] = aValue[gType];

    isModified = param[gValue] != originalValue;
    if (!isNull(droplist)) {
      needi10n = true;
    }
    Widget w;
    /*
        如果是非点中项
          显示label,退出

        如果不可编辑，显示label,加上按钮，退出
            (
              如果是电话，加上电话按钮
              如果是URL，加上URL按钮
              如果是邮件，加上邮件按钮
              如果是密码，用星号显示
              ...
            )
        
        如果不是下拉框（日期、地址、下拉），用编辑框，退出

        如果是地址，用编辑框加地址按钮，退出


        加上下拉框按钮，退出


    */
    param[gAlert] = isItemValueValidStr(item, param[gValue]);
    /*if (typeOwner == gForm) {
      param[gAlert] = isItemValueValidStr(item, param[gValue]);
    }*/
    /*if (!isNull(param[gAlert])) {
      _formLists[name][gStatus] = false;
    }*/
    if (item[gType] == gDate) {
      //droplist = item[gType];
      isReadonly = true;
    }

    var showTxt = getValueGUI(param[gValue], item);

    if ((item[gInputType] ?? "") == gBool) {
      bool isTrue = ((showTxt ?? '') == "true");

      return IconButton(
          icon: Icon(isTrue
              ? Icons.check_box_outlined
              : Icons.check_box_outline_blank_outlined),
          onPressed: () {
            if (isReadonly) {
              return;
            }
            setFocus(
                name, item[gId], id, (param[gTypeOwner] == gForm), context);
            textChange(isTrue ? "false" : "true", item, context,
                param[gTypeOwner], name, id);

            myNotifyListeners();
            //phonecallItem();
          });
    }
    if ((item[gInputType] ?? "") == gIcon) {
      //选择icon
      isReadonly = true;
    }
    if (!isFocus || isReadonly) {
      if (item[gType] == gPassword) {
        showTxt = getStrMask(showTxt, '*');
      }
      /*print('============= showTxt is ' +
          showTxt.toString() +
          ' item type is ' +
          item[gInputType].toString() +
          ',typeOwner is ' +
          param[gTypeOwner].toString() +
          ", isReadonly is " +
          isReadonly.toString());*/
      if (isNull(showTxt) && param[gTypeOwner] == gForm) {
        if (isReadonly) {
          if ((item[gInputType] ?? "") == gIcon) {
            showTxt = getSCurrent('Please select icon');
          }
        } else {
          showTxt = getSCurrent('Please enter ') + getSCurrent(item[gLabel]);
        }
      }

      Map labelParam = {
        gLabel: showTxt,
        gOriginalValue: (isModified && item[gType] != gPassword)
            ? getValueGUI(originalValue, item)
            : null,
        gNeedi10n: needi10n
      };
      if (param[gType] == gDataModifiedInvalid) {
        labelParam[gColorLabel] = warningColor;
      }
      if (isModified && isNull(labelParam[gOriginalValue])) {
        labelParam[gIsBold] = true;
      }
      if (param[gTypeOwner] == gForm) {
        labelParam[gAlign] = TextAlign.right;
        labelParam[gTextDecoration] = TextDecoration.underline;
      }
      if (item[gType] == gIcon && !isNull(param[gValue])) {
        param[gIsIcon] = true;
        if (originalValue == param[gValue]) {
          Widget wIcon = getImg(param, backColorValue);
          w = (type == gTreeView)
              ? wIcon
              : Row(
                  children: [
                    Expanded(child: SizedBox()),
                    IgnorePointer(
                      child: wIcon,
                    ),
                  ],
                );
        } else {
          param[gColor] = Colors.red;
          Widget wIcon = getImg(param, backColorValue);
          Widget wIconOriginal =
              getImg({gValue: originalValue}, backColorValue);
          w = (type == gTreeView)
              ? Row(
                  children: [
                    wIconOriginal,
                    MyLabel({gLabel: '->'}, backColorValue),
                    wIcon,
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: SizedBox()),
                    IgnorePointer(
                      child: wIconOriginal,
                    ),
                    MyLabel({gLabel: '->'}, backColorValue),
                    IgnorePointer(
                      child: wIcon,
                    ),
                  ],
                );
        }
      } else {
        w = MyLabel(labelParam, backColorValue);
        param[gIsLabel] = true;
      }
      param[gWidget] = w;

      w = addValidCheckWidget(param, context);

      return w;
    }

    if (isNull(droplist)) {
      item[gFocus] = isFocus;

      item[gFontSize] = _defaultFontSize;
      item[gFontStyle] = FontStyle.italic;
      if (param[gTypeOwner] != gForm) item[gLength] = null;
      w = TextFieldWidget(
        item: item,
        backcolor: backColorValue,
        typeOwner: typeOwner,
        name: name,
        id: id,
      );
      param[gWidget] = Expanded(child: w);
      param[gIsLabel] = false;

      w = addValidCheckWidget(param, context);

      return w;
    }

    if (!isNull(param[gValue])) {
      /*getItemIconDroplist(
          item, typeOwner, name, param[gValue], id, backColorValue, context);*/
      w = MyLabel({
        gLabel: param[gValue],
        gOriginalValue: isModified ? originalValue : null,
        gNeedi10n: needi10n
      }, backColorValue);
      param[gWidget] = w;
      param[gIsLabel] = true;

      w = addValidCheckWidget(param, context);

      return w;
    }

    showPopupItem(item, typeOwner, name, param[gValue], id, backColorValue,
        context, true);
    return Text("");
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

    return result;
  }

  getRowItemOneValue(param) {
    //get value from current focus node

    /*var value = getValue(_mFocusNode[gName], _mFocusNode[gCol], _mFocusNode[gId])[gValue];
    return value;*/

    dynamic value;

    var colname = param[gItem][gId];
    if (param[gTypeOwner] == gForm) {
      value = getValue(param[gName], colname, param[gId]);
    } else {
      //Map info = tableList[param[gName]];

      value = getValue(param[gName], colname, param[gId]);
      if (value == null || isNull(value[gValue])) {
        dynamic dataRow;
        if (param[gRow] == null) {
          dataRow = getTableRowByID(param[gName], param[gId]);
        } else {
          List tableData = getTableData(param[gName]);
          dataRow = tableData[param[gRow]];
        }

        value = {
          gValue: (dataRow == null) ? '' : dataRow[colname],
          gType: gOriginalValue
        };
      }
    }
    return value;
  }

  getRowsPerPage(tableInfo, context) {
    int lines = ((MediaQuery.of(context).size.height - 600) / 150).round() * 5;
    if (lines < 5) {
      lines = 5;
    }
    if (lines > 50) {
      lines = 50;
    }
    if (tableInfo[gRowsPerPage] == null) {
      tableInfo[gRowsPerPage] = lines;
    }
    return tableInfo[gRowsPerPage];
  }

  getScreenItem(Map mItemDetail, context, int backcolor) {
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
            List<dynamic> listValueNew = [];

            listValue1.forEach((data0) {
              listValueNew.add(Map.of(data0));
            });
            dynamic result = Radios(listValueNew, backcolor);
            return result;
          }
        });
      } else if (key == gItem) {
        return getMyItem(valueMap, context, backcolor);
      }
    });
    return SizedBox(height: 0.5);
  }

  getScreenItems(param, context, int backcolor) {
    List<Widget> result = [];
    result.add(SizedBox(height: 4.5));
    //Map map = Map.of(param[gItems]);
    if (param == null) {
      return result;
    }
    Map map = Map.of(param);
    map.forEach((key, value) {
      Map mapItem = Map.of(value);
      dynamic itemWidget = getScreenItem(mapItem, context, backcolor);
      if (itemWidget != null) {
        //result.add(SizedBox(height: 0.5));
        result.add(itemWidget);
      }
    });

    return result;
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

  getSCurrent(dynamic sourceOriginal) {
    return getSCurrentLan(sourceOriginal, _locale);
  }

  getSCurrentLan(dynamic sourceOriginal, lancode) {
    if (isNull(sourceOriginal)) {
      return '';
    }
    dynamic source = sourceOriginal.toString().replaceAll(gSTRSEPITEM, ' ');
    dynamic sourceLocase = source.toLowerCase();

    if (!isNull(_i10nMap[sourceLocase]) &&
        !isNull(_i10nMap[sourceLocase][lancode])) {
      return _i10nMap[sourceLocase][lancode].toString();
    }
    /*dynamic sourceLocase = source0.toLowerCase();
    dynamic source = sourceLocase;*/
    dynamic splitS = source.split('}');
    dynamic result = '';
    dynamic delimiter = '';
    //先按其它符号分隔，再按空格分隔
    for (int i = 0; i < splitS.length; i++) {
      dynamic splitSpace = splitS[i].split(' ');
      for (int k = 0; k < splitSpace.length; k++) {
        dynamic sourceChck = splitSpace[k].split('{');
        dynamic sj = '';
        for (int j = 0; j < sourceChck.length; j++) {
          String sourceStr = sourceChck[j].toString();
          String tmp = sourceStr.toLowerCase();
          if (isNull(_i10nMap[tmp]) || isNull(_i10nMap[tmp][lancode])) {
            sj += sourceChck[j];
          } else {
            String tmpI10n = _i10nMap[tmp][lancode].toString();

            if (lancode != 'en' || sourceStr.length < 1 || sourceStr == tmp) {
              sj += tmpI10n;
            } else {
              //首字母是否大写
              sj +=
                  tmpI10n.substring(0, 1).toUpperCase() + tmpI10n.substring(1);
            }
          }
        }
        result += delimiter + sj;
        if (lancode != 'zh') {
          delimiter = ' ';
        }
      }
    }
    return result;
  }

  /*getSCurrentLanOld(dynamic sourceOriginal, lancode) {
    dynamic source0 = sourceOriginal.toString();
    dynamic sourceLocase = source0.toLowerCase();
    dynamic source = sourceLocase;
    dynamic sourceChck = source;
    dynamic sourceChckTub = '';
    if (sourceChck.indexOf("{") > 0) {
      sourceChck = sourceChck.substring(0, sourceChck.indexOf("{"));
    }
    if (_i10nMap[sourceChck] != null) {
      dynamic result = _i10nMap[sourceChck][lancode] + sourceChckTub;
      if (result != null) {
        while ((result.indexOf('}') > 0 && result.indexOf('{') >= 0)) {
          dynamic result0 = result.substring(0, result.indexOf('{'));

          dynamic resultMid = "";
          if (source.indexOf('{') > -1 &&
              source.indexOf('}') > -1 &&
              source.indexOf('}') > source.indexOf('{')) {
            resultMid =
                source.substring(source.indexOf('{') + 1, source.indexOf('}'));
          }

          dynamic result1 = result.substring(result.indexOf('}') + 1);

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
      dynamic s0 = source0.substring(0, source.indexOf(" "));
      dynamic s1 = source0.substring(source.indexOf(" ") + 1);
      dynamic s0Result = getSCurrent(s0);
      dynamic s1Result = getSCurrent(s1);
      dynamic delimiter = ' ';
      if (lancode == 'zh') {
        if (s0 != s0Result && s1 != s1Result) {
          delimiter = '';
        }
      }

      return s0Result + delimiter + s1Result;
    }
    return source0;
  }*/

  getStrDistance(str, List msgList) {
    int result = 0;
    msgList.forEach((element) {
      int index = str.indexOf(element);
      if (index > -1) {
        result += index;
        var strLeft = str.substring(0, index);
        var strRight = str.substring(index + element.length);
        str = strRight + strLeft;
      } else {
        result += str.toString().length;
      }
    });
    return result;
  }

  getStrMask(value, aMask) {
    dynamic result = '';
    for (int i = 0; i < (value ?? '').length; i++) {
      result += aMask;
    }
    return result;
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
    //print('===========  getTabBody 0');
    if (_tabList[tabname] == null) {
      return null;
    }
    //print('===========  getTabBody 1');
    dynamic data = _tabList[tabname][gData][_tabList[tabname][gTabIndex]];
    if (!(data[gVisible] ?? true)) {
      return null;
    }
    //print('===========  getTabBody 2');
    //print('===========  getTabBody gType is ' + data.toString());
    if (data[gType] == gCard) {
      return getCard(data[gBody], context, tabname, backcolor);
    } else if (data[gType].toString().endsWith(gTable)) {
      //dynamic tableName = data[gActionid];
      //print('===========  getTabBody 2 0');
      data[gTabName] = tabname;
      //print('===========  getTabBody 2 1');
      return getTableBody(data, context, backcolor);
    } else if (data[gType] == gTab) {
      //设置明细tab
      List<Widget> result = [];
      //print('== ====  data is ' + data.toString());
      dynamic tabID = data[gTabid];
      List dataChild = [];
      List dataBody = data[gBody][0][gData];
      dataBody.forEach((element) {
        Map data0 = Map.of(element);
        dataChild.add(data0);
      });
      //print('== ====  dataChild is ' + dataChild.toString());

      setTabBasic(dataChild, context, tabID);
      var tab = getTab(tabID, context);
      //print('== ====  tab is ' + tab.toString());
      if (tab == null) {
        return SizedBox();
      }
      //var tabData = tab[gData];
      final double _screenHeight = MediaQuery.of(context).size.height;
      result.add(Column(
        children: [
          SizedBox(
            height: 60.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tab[gData].length,
              itemBuilder: (context, index) =>
                  getTabByIndex(index, tabID, context),
            ),
          ),
          SizedBox(
            height: _screenHeight - 400.0,
            child: getTabBody(tabID, context, backcolor),
          )
        ],
      ));
      //show tab
      if (result.length > 1) {
        result[0] = Expanded(child: result[0]);
        Widget aRow = Column(
            mainAxisAlignment: MainAxisAlignment.center, children: result);
        return aRow;
      }
      return result[0];
    } else if (data[gType] == gTabletree) {
      //dynamic tableName = data[gActionid];
      setTreeNode(data, context);
      return getTreeBody(data, context, backcolor);
    }

    return MyLabel(
        {gLabel: data[gType] + ' will be available soon'}, backcolor);
  }

  getTabByIndex(int index, tabName, context) {
    List<Widget> titleWidgets = [];
    var dataThis = _tabList[tabName][gData][index];
    if (!(dataThis[gVisible] ?? true)) {
      return null;
    }
    titleWidgets.add(Text(getSCurrent(dataThis[gLabel]),
        style: TextStyle(
            fontSize: _tabList[tabName][gFontSize] ?? (_defaultFontSize + 5),
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
        clearMFocusNode(context);
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

  getTabIndex(label, context, tabName) {
    for (int i = 0; i < _tabList[tabName][gData].length; i++) {
      if (_tabList[tabName][gData][i][gLabel] == label) {
        return i;
      }
    }
    return -1;
  }

  getTableBody(data, context, backcolor) {
    return MyScreen(getTableBodyParam(data, context), backcolor);
  }

  getTableByIndex(int index, tableid) {
    dynamic tableData = _tableList[tableid]![gData][index];
    return tableData;
  }

  getTableByTableID(tableid, where, context) {
    dynamic tableData = _tableList[tableid] ?? null;
    if (tableData == null) {
      getTableFromDB(tableid, where, context);
    }

    if (isNull(where)) {
      return tableData[gData];
    }

    return getTableDataFromWhere(tableData, where);
  }

  getTableCol(tableid, colId) {
    List colList = _tableList[tableid]![gColumns];

    if (colList.length > 0) {
      for (int i = 0; i < colList.length; i++) {
        if (colList[i][gId] == colId) {
          return colList[i];
        }
      }
    }
    return null;
  }

  getTableData(name) {
    Map info = tableList[name]!;
    if ((info[gDataSearch] ?? []).length < 1) {
      return info[gData];
    }
    Map<dynamic, int> mapIDIndex = {};
    List tableData = info[gData];

    for (int i = 0; i < tableData.length; i++) {
      mapIDIndex[tableData[i][gId]] = i;
    }
    List result = [];
    for (int i = 0; i < info[gDataSearch].length; i++) {
      dynamic infoI = info[gDataSearch]![i];
      int aInt = mapIDIndex[infoI]!;
      result.add(tableData[aInt]);
    }
    return result;
  }

  getTableFloatingBtns(name, context) {
    var tableInfo = _tableList[name];
    bool canEdit = tableInfo![gAttr]![gCanEdit];
    bool canDelete = tableInfo[gAttr]![gCanDelete];
    bool hasDetail = ((tableInfo[gAttr]![gDetail] ?? "") != "");
    bool isNotLog = (name.indexOf(gZzylog) < 0);
    bool canCancel = canEdit;

    clearActionBtnMap(name);
    var focusName = _mFocusNode[gName] ?? '';
    if (isNull(focusName)) {
      return;
    }
    if (name != focusName) {
      return;
    }
    if (_tableList[name] == null) {
      return;
    }
    var id = _mFocusNode[gId] ?? '';
    if (isNull(id)) {
      return;
    }
    var dataRow = getTableRowByID(name, id);
    if (dataRow == null) {
      return;
    }

    double size = 36.0;
    int backgroundcolor = Colors.white.value;
    bool isForm = _mFocusNode[gIsForm] ?? false;
    if (isForm) {
      return;
    }
    if (canEdit) {
      var labelValue = gEdit;
      var icon = 61453;

      addActionButton(
          name,
          {
            gLabel: labelValue,
            gAction: gLocalAction,
            gTableID: name,
            gRow: dataRow,
            gContext: context,
            gIconSize: size,
            gIcon: icon,
            gBackgroundColor: backgroundcolor
          },
          context);
    }

    if (canCancel) {
      if (isModifiedValid(tableInfo, dataRow)) {
        addActionButton(
            name,
            {
              gLabel: gSave,
              gAction: gLocalAction,
              gTableID: name,
              gRow: dataRow,
              gContext: context,
              gIconSize: size,
              gIcon: 62260,
              gBackgroundColor: backgroundcolor
            },
            context);
      }
      if (isModifiedValidOrInvalid(tableInfo, dataRow)) {
        addActionButton(
            name,
            {
              gLabel: gCancel,
              gAction: gLocalAction,
              gTableID: name,
              gRow: dataRow,
              gContext: context,
              gIconSize: size,
              gIcon: 62575,
              gBackgroundColor: backgroundcolor
            },
            context);
      }
    }
    if (canDelete) {
      addActionButton(
          name,
          {
            gLabel: gDelete,
            gAction: gLocalAction,
            gTableID: name,
            gRow: dataRow,
            gContext: context,
            gIconSize: size,
            gIcon: 57787,
            gBackgroundColor: backgroundcolor
          },
          context);
    }
    if (hasDetail) {
      addActionButton(
          name,
          {
            gLabel: gDetail,
            gAction: gLocalAction,
            gTableID: name,
            gRow: dataRow,
            gContext: context,
            gIconSize: size,
            gIcon: 0xe246,
            gBackgroundColor: backgroundcolor
          },
          context);
    }
    if (isNotLog) {
      addActionButton(
          name,
          {
            gLabel: gLog,
            gAction: gLocalAction,
            gTableID: name,
            gRow: dataRow,
            gContext: context,
            gIconSize: size,
            gIcon: 0xf102,
            gBackgroundColor: backgroundcolor
          },
          context);
    }
  }

  getTableDataFromWhere(tableInfo, where) {
    //filter the table data by where condition
    Map mapWhere = {};
    List whereList = where.toString().split(' and ');
    for (int i = 0; i < whereList.length; i++) {
      List keyValue = whereList[i].toString().split('=');
      mapWhere[keyValue[0]] = keyValue[1];
    }
    List result = [];
    if (tableInfo != null) {
      tableInfo[gData].forEach((dataRow) {
        bool isMatch = true;
        mapWhere.forEach((key, value) {
          if (dataRow[key].toString() != value) {
            isMatch = false;
          }
        });
        if (isMatch) {
          result.add(dataRow);
        }
      });
    }
    return result;
  }

  getTableFromDB(tableid, where, context) {
    Map element = {
      gLabel: '',
      gType: gTable,
      gActionid: tableid,
      gWhere: (where ?? ""),
      gColorIndex: 0
    };
    sendRequestOne(gProcess, [element], context);
  }

  getTableHeader(name, context) {
    var focusName = _mFocusNode[gName] ?? '';
    if (isNull(focusName)) {
      return;
    }
    if (name != focusName) {
      return;
    }
    if (_tableList[name] == null) {
      return;
    }
    var id = _mFocusNode[gId] ?? '';
    if (isNull(id)) {
      return;
    }
    var dataRow = getTableRowByID(name, id);
    if (dataRow == null) {
      return;
    }
    var value = getTableKeyword(name, id, context);
    if (isNull(value)) {
      return;
    }
    int backgroundcolor = Colors.white.value;

    return MyLabel(
        {gLabel: value, gFontSize: _defaultFontSize - 5}, backgroundcolor);
    /*List<Widget> actionList = [];
    actionList.insert(
        0,
        Expanded(
            child: MyLabel({gLabel: value, gFontSize: 10.0}, backgroundcolor)));
    return Row(
      children: actionList,
    );*/
  }

  getTableMap(name, col) {
    dynamic table = _tableList[name];
    if (table == null) {
      return null;
    }

    if (table != null &&
        table[gTableMapPrefix] != null &&
        table[gTableMapPrefix][col] != null) {
      return table[gTableMapPrefix][col];
    }
    Map map = {};
    for (int i = 0; i < table[gData].length; i++) {
      var dataRow = table[gData][i];
      map[dataRow[col]] = dataRow[gId];
    }
    table[gTableMapPrefix][col] = map;

    return map;
  }

  /*getTableItemByName(tableInfo, itemName, value) {
    //TextEditingController searchController = getTextController(value);

    Map item = {
      gWidth: 150.0,
      gType: itemName,
      gLabel: itemName,
      gFocus: false,
      gValue: value,
      gInputType: itemName,
      //gTxtEditingController: searchController
    };

    return item;
  }*/

  getTableRowByID(tableName, id) {
    dynamic tableInfo = _tableList[tableName];
    if (tableInfo[gData] == null) {
      return null;
    }
    if (isNull(id)) {
      return null;
    }
    List tableData = tableInfo[gData];
    for (int i = 0; i < tableData.length; i++) {
      if (tableData[i][gId] == id) {
        return tableData[i];
      }
    }
    return null;

    /*if (tableInfo[gTableMapPrefix] == null ||
        tableInfo[gTableMapPrefix][gId] == null ||
        tableData[tableInfo[gTableMapPrefix][gId][id]] == null) {
      Map<dynamic, int> mapIDIndex = {};

      for (int i = 0; i < tableData.length; i++) {
        mapIDIndex[tableData[i][gId]] = i;
      }

      if (tableInfo[gTableMapPrefix] == null) {
        tableInfo[gTableMapPrefix] = {};
      }
      tableInfo[gTableMapPrefix][gId] = mapIDIndex;
    }

    return tableData[tableInfo[gTableMapPrefix][gId][id]];*/
  }

  getTableRowByParentID(tableName, parentid) {
    dynamic tableInfo = _tableList[tableName];
    if (tableInfo[gData] == null) {
      return null;
    }
    List tableData = tableInfo[gData];
    List result = [];
    for (int i = 0; i < tableData.length; i++) {
      dynamic dataRow = tableData[i];
      if ((dataRow[gParentid] ?? '') == parentid) {
        result.add(dataRow);
      }
    }
    return result;
  }

  getTableBodyParam(data, context) {
    //_tableList[tableName][gKey] = UniqueKey();
    dynamic tableName = data[gActionid] ?? data[gTableID];
    //dynamic tableName = _param[gData][gActionid] ?? _param[gData][gTableID];

    dynamic tableInfo = _tableList[tableName];
    if (tableInfo == null) {
      return null;
    }
    //List tableData = tableInfo[gData];
    //List columns = tableInfo[gColumns];

    Map param = {};
    int index = 0;
    double iconSize = 40.0;
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
      detail.add({
        gLabel: gAddnew,
        gTableID: tableName,
        gIconSize: iconSize,
        gData: data,
        gIcon: 60999
      });
    }
    detail.add({
      gLabel: gPdf,
      gTableID: tableName,
      gIconSize: iconSize,
      gData: data,
      gIcon: 62116
    });
    detail.add({
      gLabel: gExcel,
      gTableID: tableName,
      gIconSize: iconSize,
      gData: data,
      gIcon: 62495
    });

    if (tableInfo[gAttr][gCanEdit]) {
      if (isModifiedValidAll(tableInfo)) {
        detail.add({
          gLabel: gSaveall,
          gTableID: tableName,
          gIconSize: iconSize,
          gData: data,
          gIcon: 62260
        });
      }
    }

    param[index++] = {
      gItem: jsonEncode(
          {gType: gBtns, gAction: gTable, gValue: tableName, gItems: detail})
    };

    param[index++] = {
      gItem: jsonEncode({gType: gTableEditor, gName: tableName, gOther: data})
    };
    return param;
  }

  getTableCellValueFromData(data, columns, colIndex, rowIndex, context) {
    var dataRow = data[rowIndex];
    return getTableCellValueFromDataRow(dataRow, columns, colIndex, context);
  }

  getTableCellValueFromDataRow(dataRow, columns, colIndex, context) {
    return getTableCellValueFromDataRowIsRaw(
        dataRow, columns, colIndex, context, true);
  }

  getTableCellValueFromDataRowIsRaw(
      dataRow, columns, colIndex, context, isRaw) {
    Map col = columns[colIndex];
    return getTableCellValueFromDataRowIsRawCol(dataRow, col, context, isRaw);
  }

  getTableCellValueFromDataRowIsRawCol(dataRow, col, context, isRaw) {
    dynamic colName = col[gId];
    var result = dataRow[colName];
    if (isNull(result)) {
      return result;
    }
    dynamic inputType = col[gInputType];
    if (inputType == gDatetime) {
      if (isRaw) {
        if (isNull(result)) {
          return 0;
        }
        return getInt("$result");
      }
    }
    if (isRaw) {
      return result;
    }
    return getValueGUI(result, col);
    //return result;
  }

  getTableCellValueFromTable(tableName, colIndex, rowIndex, context) {
    List data = tableList[tableName]![gData];
    List columns = tableList[tableName]![gColumns];
    return getTableCellValueFromData(
        data, columns, colIndex, rowIndex, context);
  }

  /*getTableIDMap(table) {
    return getTableMap(table, gId);
  }*/

  getTableKeyword(tableId, dataid, context) {
    var table = _tableList[tableId] ?? null;
    if (table == null) {
      retrieveTableFromDB(tableId, context);

      return dataid;
    }
    var dataRow = getTableRowByID(tableId, dataid);
    if (dataRow == null) {
      return dataid;
    }
    return getTableValueKeyFromTable(tableId, dataRow);
  }

  getTableRowShowValue(tablename, item, colList, context) {
    return getTableRowShowValueFilter(tablename, item, colList, context, null);
  }

  getTableRowShowValueByTablename(item, tablename, context) {
    dynamic tableInfo = _tableList[tablename];
    List colList = tableInfo[gColumns];
    return getTableRowShowValue(tablename, item, colList, context);
  }

  getTableRowShowValueFilter(tablename, item, colList, context, filterValue) {
    return getTableRowShowValueFilterMapOrList(
        tablename, item, colList, context, filterValue, true);
  }

  getTableRowShowValueFilterMapOrList(
      tablename, item, colList, context, filterValue, mapOrList) {
    dynamic filterValueLower = filterValue.toString().toLowerCase();
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
      //var colIndex = i;
      //if (!isNull(item[ci[gId]])) {
      /*var oneValue =
          getTableCellValueFromDataRow(item, colList, colIndex, context) ?? '';*/
      dynamic valueCi = getValue(tablename, ci[gId], item[gId]);
      dynamic valueValue = (valueCi == null) ? '' : valueCi[gValue];
      var oneValue = getValueGUI(valueValue ?? '', ci);

      if (isNull(oneValue)) {
        oneValue = "";
      }
      result[ci[gId]] = oneValue;
      if (!isHiddenColumn(colList, i)) {
        resultList.add(oneValue);
      }
      if (!filterValueExists) {
        if (!isHiddenColumn(colList, i)) {
          if (!isNull(oneValue) &&
              oneValue.toString().toLowerCase().contains(filterValueLower)) {
            filterValueExists = true;
          }
        }
      }
      //}
    }
    if (!filterValueExists) {
      return null;
    }
    if (mapOrList) {
      return result;
    }
    return resultList;
  }

  getTableShowData(tableInfo, context) {
    List tableData = tableInfo[gData];
    List columns = tableInfo[gColumns];
    List result = [];
    tableData.forEach((dataRow) {
      Map map = {};
      for (int i = 0; i < columns.length; i++) {
        Map col = columns[i];
        map[col[gId]] =
            getTableCellValueFromDataRowIsRawCol(dataRow, col, context, false);
      }
      result.add(map);
    });
    return result;
  }

  getTableValue(row, colid) {
    var result = row[colid];

    return result;
  }

  getTableValueAttr(tableId, attrName) {
    var table = _tableList[tableId];

    var result = table![gAttr][attrName];

    return result;
  }

  getTableValueKey(tableid, dataRow) {
    return getTableValueKeyFromTable(tableid, dataRow);
  }

  getTableValueKeyFromColumns(name, columns, dataRow) {
    var result = "";
    var sep = "";
    if (dataRow == null) {
      result = gAddnew;
      return result;
    }
    columns.forEach((element) {
      bool isKeyword = element[gIsKeyword] ?? false;
      if (isKeyword) {
        //var value = dataRow[element[gId]];
        var value = getValueGUI(
            getValue(name, element[gId], dataRow[gId]), element)[gValue];
        if (!isNull(value)) {
          result += sep + value;
          sep = ",";
        }
      }
    });
    return result;
  }

  getTableValueKeyFromTable(tableid, dataRow) {
    //var data = table[gData][row];
    var table = _tableList[tableid];
    List columns = table![gColumns];
    return getTableValueKeyFromColumns(tableid, columns, dataRow);
  }

  getTableValuePrimary(tableId, data) {
    var table = _tableList[tableId];

    //var data = table[gData][row];
    List columns = table![gColumns];
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

  getTextController(value) {
    //var txtValue = value ?? "";
    TextEditingController controller = TextEditingController(text: value);
    /*TextEditingController controller = TextEditingController.fromValue(
        TextEditingValue(
            text: txtValue,
            // 保持光标在最后
            selection: TextSelection.fromPosition(TextPosition(
                affinity: TextAffinity.downstream, offset: txtValue.length))));*/
    return controller;
  }

  getTitle(param, context, backcolor) {
    dynamic aLabel = param[gLabel];
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

  getTreeBody(data, context, backcolor) {
    return Column(
      children: [
        Expanded(child: MyLabel({gLabel: gWelcome, gFontSize: 20.0}, backcolor)

            //MyTree({gData: data, gAction: gLocalAction, gContext: context}),
            ),
      ],
    );
  }

  getTreeNodeTable(tableName, item, parentid, context, backcolor) {
    List list = getTableRowByParentID(tableName, parentid);
    if (list.length < 1) {
      return null;
    }

    List<TreeNode> result = [];
    for (int i = 0; i < list.length; i++) {
      Map dataRow = list[i];
      var id = dataRow[gId];
      List<TreeNode> listChild =
          getTreeNodeTable(tableName, item, id, context, backcolor);
      /*var imgDefault = 0xf064c.toString();
      if (!isNull(dataRow[item[gId]])) {
        imgDefault = dataRow[item[gId]];
      }*/
      result.add(TreeNode(
          content: InkWell(
              child: Row(
                children: [
                  getRowItemOne(tableName, dataRow[gId], item, context,
                      backcolor, gTreeView),
                  //getImg({gValue: imgDefault}, backcolor),
                  MyLabel(
                      {gValue: getTableValueKeyFromTable(tableName, dataRow)},
                      backcolor),
                ],
              ),
              onTap: () {
                sendRequestOne(
                    gLocalAction,
                    {
                      gLabel: gEdit,
                      gAction: gLocalAction,
                      gTableID: tableName,
                      gRow: dataRow
                    },
                    context);
              }),
          children: listChild));
    }
    return result;
  }

  getTreeViewTable(droplistName, item, context, backcolor) {
    var tableName = droplistName;
    var parentid = '';
    if (droplistName.indexOf("[") > 0) {
      //roleid from Zzyuserrole where parentid=@uid
      tableName = droplistName.substring(0, droplistName.indexOf('['));
      var tableNameParent =
          droplistName.substring(droplistName.indexOf('[') + 1);
      tableNameParent =
          tableNameParent.substring(0, tableNameParent.indexOf(']'));
      var tableNameParentCol =
          tableNameParent.substring(0, tableNameParent.indexOf(' from '));
      tableNameParent =
          tableNameParent.substring(tableNameParent.indexOf(' from ') + 6);
      var where =
          tableNameParent.substring(tableNameParent.indexOf(' where ') + 7);
      tableNameParent =
          tableNameParent.substring(0, tableNameParent.indexOf(' where '));
      //if (tableName == gZzyrole) {
      if (where.indexOf('@myDBId') > 0) {
        where = where.toString().replaceAll('@myDBId', _myDBId);
      }
      //}
      dynamic data = getTableByTableID(tableNameParent, where, context);
      if (data == null || data.length < 1) {
        return;
      }
      parentid = data[0][tableNameParentCol];
    }

    return Expanded(
      child: TreeView(nodes: [
        TreeNode(
            content: Row(
              children: [
                getImg(
                    {gValue: getTableValueAttr(tableName, gIcon)}, backcolor),
                MyLabel(
                    {gValue: getTableValueAttr(tableName, gLabel)}, backcolor),
              ],
            ),
            children: getTreeNodeTable(
                tableName, item, parentid, context, backcolor)),
      ]),
    );
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

  getValue(name, colId, id) {
    var typeOwner = gForm;
    if (_tableList[name] != null) {
      typeOwner = gTable;
    }
    if (colId == gSearchZzy) {
      if (typeOwner == gTable) {
        return {gValue: _tableList[name]![gSearch] ?? '', gType: gSearch};
      }
    }
    var value =
        getModifiedValueByType(name, colId, id, gDataModified, typeOwner);
    if (value != null) {
      return {gValue: value, gType: gDataModified};
    }
    value = getModifiedValueByType(
        name, colId, id, gDataModifiedInvalid, typeOwner);
    if (value != null) {
      return {gValue: value, gType: gDataModifiedInvalid};
    }
    return {gValue: getValueOriginal(name, colId, id), gType: gOriginalValue};
  }

  getValueGUI(result, col) {
    dynamic inputType = col[gInputType];
    if (inputType == gDatetime) {
      return toLocalTime(result);
    }
    dynamic dplist = getDPidfromItem(col);

    if (!isNull(dplist)) {
      if (!_dpList.containsKey(dplist)) {
        var tableinfo = _tableList[dplist];
        if (tableinfo != null) {
          List tableData = tableinfo[gData];
          if (tableData.length > 0) {
            tableData.forEach((element) {
              dpListInsert(dplist, element, null);
            });
          }
        }
      }
      bool isLabel = false;
      if (inputType == gAddress) {
        isLabel = true;
      }
      if (isLabel) {
        return result;
      }

      return getSCurrent(result);
    }
    if (result.toString() == gNull) {
      return '';
    }
    return result;
  }

  getValueOriginal(name, colId, id) {
    var typeOwner = gForm;
    if (_tableList[name] != null) {
      typeOwner = gTable;
    }
    if (typeOwner == gForm && isNullID(id)) {
      dynamic formDefine = _formLists[name];
      Map<dynamic, dynamic> items = formDefine[gItems];
      items.entries.forEach((itemOne) {
        Map item = itemOne.value;
        if (item[gId] == colId) {
          return isNull(item[gValue]) ? '' : item[gValue];
        }
      });
    } else {
      dynamic rowData = getTableRowByID(name, id);
      if (rowData == null) {
        return;
      }
      return isNull(rowData[colId]) ? '' : rowData[colId];
    }
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
    } else {
      title = MyLabel({gLabel: param[gTitle][gTitle]}, backcolor);
    }
    return title;
  }

  dynamic hash(str) {
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

  isItemEmail(Map item) {
    if (item[gType] == gEmail) {
      return true;
    }
    if (item[gId] == gEmail) {
      return true;
    }
    return false;
  }

  isItemValueValid(item, value) {
    var result = isItemValueValidStr(item, value);
    return result == '';
  }

  isItemValueValidStr(item, value) {
    if (item[gRequired] && isNull(value)) {
      return getSCurrent(item[gLabel]) + getSCurrent(' ' + gIsrequired);
    }
    if (item[gType] == gEmail &&
        !isNull(value) &&
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
      return getSCurrent('Invalid email');
    }
    //us phone: ^(?:\([2-9]\d{2}\)\ ?|[2-9]\d{2}(?:\-?|\ ?))[2-9]\d{2}[- ]?\d{4}$
    //       or: ^[\(\)\.\- ]{0,}[0-9]{3}[\(\)\.\- ]{0,}[0-9]{3}[\(\)\.\- ]{0,}[0-9]{4}[\(\)\.\- ]{0,}$

    //ca:^\([1-9]\d\d\)\d\d\d-\d\d\d\d$ 或  ^\([1-9][0-9][0-9]\)[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]$ 或^\([1-9]\d{2}\)\d{3}-\d{4}$
    if (item[gType] == gPhone &&
        !isNull(value) &&
        !RegExp(r"^\([1-9]\d{2}\)\d{3}-\d{4}$").hasMatch(value)) {
      return getSCurrent('Invalid phone');
    }
    //post code canada: ^[a-zA-Z]\d{1}[a-zA-Z](\-| |)\d{1}[a-zA-Z]\d{1}$
    //post code us: ^[0-9]{5}([- /]?[0-9]{4})?$

    //url:((http|ftp|https):\/\/)(([a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,4})*(\/[a-zA-Z0-9\&%_\.\/-~-]*)?
    if (item[gType] == gUrl &&
        !isNull(value) &&
        !RegExp(r"^((http|ftp|https):\/\/)(([a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,4})*(\/[a-zA-Z0-9\&%_\.\/-~-]*)?")
            .hasMatch(value)) {
      return getSCurrent('Invalid url');
    }

    if (item[gMinLength] != null &&
        item[gMinLength] != '0' &&
        !isNull(value) &&
        value.toString().length < item[gMinLength]) {
      return getSCurrent(gMininput +
          "{" +
          item[gMinLength].toString() +
          "}{" +
          (isNull(item[gUnit]) ? gCharacter : item[gUnit]) +
          "}");
    }
    if (item[gLength] != null &&
        item[gLength] != '0' &&
        !isNull(value) &&
        value.toString().length > item[gLength]) {
      return getSCurrent(gMaxinput +
          "{" +
          item[gLength].toString() +
          "}{" +
          (isNull(item[gUnit]) ? gCharacter : item[gUnit]) +
          "}");
    }

    return '';
  }

  isModifiedValid(_param, dataRow) {
    return isModifiedValidByType(_param, dataRow, gDataModified);
  }

  isModifiedValidAll(tableInfo) {
    if (!isNull(tableInfo[gDataModified])) {
      dynamic dataModified = tableInfo[gDataModified];
      if (dataModified != null && dataModified.length > 0) {
        return true;
      }
    }
    return false;
  }

  isModifiedValidByType(_param, dataRow, type) {
    if (!isNull(_param[type]) && !isNull(_param[type][dataRow[gId]])) {
      return true;
    }
    return false;
  }

  isModifiedValidOrInvalid(_param, dataRow) {
    return isModifiedValidByType(_param, dataRow, gDataModified) ||
        isModifiedValidByType(_param, dataRow, gDataModifiedInvalid);
  }

  isNull(aValue) {
    if (aValue == null ||
        aValue.toString() == '' ||
        aValue.toString() == gNull ||
        aValue.toString() == "{}" ||
        aValue.toString() == "[]") {
      return true;
    }
    return false;
  }

  isNullID(id) {
    return isNull(id) || id == gFakeId;
  }

  isPopOpen() {
    return !isNull(overlayEntry);
  }

  loadFile(formname, item, id, context) async {
    if (isNull(formname)) {
      return;
    }

    removeOverlay();

    FilePickerResult? result = await pickFiles();
    if (result == null || result.files.isEmpty) {
      //showMsg(context, 'No files picked or file picker was canceled', null);

      throw Exception('Cannot read file from null stream');
      //throw Exception('No files picked or file picker was canceled');
    }
    var file = result.files.first;
    //var filePath = file.path;
    var filename = file.name;
    final fileReadStream = file.readStream;
    if (fileReadStream == null) {
      //showMsg(context, 'Cannot read file from null stream', null);

      throw Exception('Cannot read file from null stream');
      //return;
    }
    print('================ file size is ' + file.size.toString());
    if (file.size > 1048576) {
      //showMsg(context, 'Cannot read file from null stream', null);
      //return;
      throw Exception('file size can not be over 1M');
    }
    final stream = http.ByteStream(fileReadStream);

    dynamic myUrl = 'http://' + MyConfig.URL.name + '/' + MyConfig.UPLOAD.name;
    var request = http.MultipartRequest('POST', Uri.parse(myUrl));
    request.fields['param0'] = filename;
    request.fields['param1'] = _globalCompanyid;
    /*http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath("image", file.name);*/
    request.files.add(http.MultipartFile(_globalCompanyid, stream, file.size,
        filename: filename));
    //upload file
    var res = await request.send();
    if (res.statusCode == 200) {
      if (res.toString().indexOf('Error') == 0) {
        showMsg(context, res.toString(), null);
      }
      var resultname = 'http:/images/' + _globalCompanyid + '/' + filename;
      setValue(formname, item[gId], id, resultname);
      myNotifyListeners();
    }
  }

  loadUrl(url) {
    final anUri = Uri.parse(url);
    _launch(anUri);
  }

  loadUrlItem() {
    var value =
        getValue(_mFocusNode[gName], _mFocusNode[gCol], _mFocusNode[gId]);

    loadUrl(value);
  }

  void _launch(url) async {
    if (url != null) {
      await launchUrl(url);
    }
  }

  localAction(requestFirst, context) {
    Map data;
    try {
      data = requestFirst[gData];
    } catch (e) {
      MapEntry me = requestFirst[gData];
      data = me.value;
    }
    if (data[gLabel] != null && data[gLabel] == gConfirm) {
      if (data[gItem] != null) {
        Map item = data[gItem];
        var id = data[gId];
        var type = item[gType];
        String value = '';
        var dpid = getDPidfromItem(item);

        if (type == gDate || !isNull(dpid)) {
          if (type == gDate) {
            value = _dpList[gYear][_dpListDefaultIndex[gYear]] +
                '-' +
                _dpList[gMonth][_dpListDefaultIndex[gMonth]] +
                '-' +
                _dpList[gDay][_dpListDefaultIndex[gDay]];
          } else if (type == gIcon) {
            var indexRow = getDPIndex(_dpListDefaultIndex[dpid], item);
            value = getInt(indexRow[gValue]).toString();
          } else {
            //print('=========   confirm: ' + item.toString());
            var indexRow = getDPIndex(_dpListDefaultIndex[dpid], item);
            value = indexRow;
          }
          bool status = setItemAferDPClick(
              item, value, data[gTypeOwner], data[gName], id, context);

          if (status) {
            removeOverlay();
          }
        }
      }
    } else if (data[gLabel] != null &&
        data[gLabel] == gEdit &&
        data[gTableID] != null) {
      //var tableId = data[gTableID];
      //int index = data[gRow];
      showFormEdit(data, context);
      showTableForm(data, context, null);
    } else if (data[gLabel] != null &&
        data[gLabel] == gSave &&
        data[gTableID] != null) {
      saveTableModify(data, context);
    } else if (data[gLabel] != null &&
        data[gLabel] == gCancel &&
        data[gTableID] != null) {
      cancelTableModify(data, context);
    } else if (data[gLabel] != null &&
        data[gLabel] == gSaveall &&
        data[gTableID] != null) {
      saveTableModifyAll(data, context);
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
              gWhere: _tabList[data[gTabName]][gData][data[gTabIndex]][gWhere],
              gColorIndex: 0
            }
          ],
          context);
    } else if (data[gLabel] != null &&
        data[gLabel] == gTreeExpand &&
        data[gValue] != null &&
        data[gMove] != null) {
      //bool expanded = data[gMove];
      //dynamic key = data[gValue];
    } else if (data[gLabel] != null &&
        data[gLabel] == gTreeSelected &&
        data[gValue] != null) {
      if (data[gData] != null && data[gData][gType] != null) {
        if (data[gData][gType] == gTabletree) {
          dynamic tableid = data[gValue] ?? '';
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
    } else if (!isNull(data[gAction1])) {
      businessFunc(data[gAction1], context, data);
    } else if (data[gLabel] != null &&
        data[gLabel] == gLog &&
        data[gTableID] != null) {
      var id = data[gRow][gId];
      var name = data[gTableID];
      var where = "dataid='" + id + "' order by entrytime";
      getTableFromDB(gZzylog + '_' + name, where, context);
    }
  }

  logOff(context) {
    finishme(context);
    clear(context);

    //myNotifyListeners();
  }

  moveItemBetweenMaps(id, Map originMap, Map destineMap) {
    Map mValue = originMap[id];
    destineMap[id] = mValue;
    originMap.remove(id);
  }

  myNotifyListeners() {
    _debouncer.run(() => notifyListeners());
  }

  navigatorPush(context, Widget aScreen, msg) {
    Route lastRoute = MaterialPageRoute(builder: (context) => aScreen);
    Navigator.push(context, lastRoute);
  }

  newForm(data, context) {
    var tableName = data[gActionid] ?? data[gTableID];
    dynamic formDefine = _formLists[tableName];
    Map<dynamic, dynamic> items = formDefine[gItems];
    Map mapWhereList = {};
    if (data[gData] != null) {
      Map mapData = Map.of(data[gData]);
      if (!isNull(mapData[gWhere])) {
        List whereList = mapData[gWhere].split(" and ");
        whereList.forEach((element) {
          if (element.toString().indexOf("=") > 0) {
            String aKey = element
                .toString()
                .substring(0, element.toString().indexOf("="));
            String aValue = element
                .toString()
                .substring(element.toString().indexOf("=") + 1);
            if (aValue.indexOf("'") == 0) {
              aValue = aValue.substring(1, aValue.length - 1);
            }
            mapWhereList[aKey] = aValue;
          }
        });
      }
    }
    items.entries.forEach((itemOne) {
      Map item = itemOne.value;
      if (mapWhereList.containsKey(item[gId])) {
        if (isNull(item[gDefaultValue]))
          item[gDefaultValue] = mapWhereList[item[gId]];
      }
      item[gValue] = item[gDefaultValue];
    });
    clearMFocusNode(context);
    setFocus(tableName, null, null, true, context);
  }

  notAvailable(backcolor) {
    return MyLabel({gLabel: gNotavailable}, backcolor);
  }

  openDetailForm(formname, context, backcolor) {
    Map param = {
      gsBackgroundColor: _formLists[formname]![gsBackgroundColor],
      gColor: _formLists[formname]![gColor],
      gName: formname,
      gType: gForm
    };
    showMyDetail(param, 'openDetailForm', context, backcolor);
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

        showTable(
            tableid, context, map[gLabel] ?? "", "", backcolor, null, null);
      }
    } catch (e) {
      showMsg(context, e, null);
    }
    if (map[gLabel] == "Test") {
      //showTab("role", context);
    }
    //print('=====typed ' + map[gLabel]);
  }

  phonecall(sNum) {
    String nums = sNum.replaceAll(RegExp(r'[\D]'), '');
    final anUri = Uri.parse('tel:' + nums);
    _launch(anUri);
  }

  phonecallItem() {
    var value = getValue(
        _mFocusNode[gName], _mFocusNode[gCol], _mFocusNode[gId])[gValue];

    phonecall(value);
  }

  pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withReadStream: true);
    return result;
  }

  processRequest(requestFirst, context) async {
    var dataRequest = encryptByDES(requestFirst);
    final headers = {
      'contentType':
          'text/html,application/xhtml+xml,application/xml,application/x-www-form-urlencoded',
      'accept-language': 'en-US,en'
    };

    //dynamic url = MyConfig.URL.name + 'smilesmart';
    Uri uri = new Uri.http(MyConfig.URL.name, MyConfig.PROJ.name);
    http.Response response;
    try {
      waitDialog(context);
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

      print('==response is: ' + data.toString());
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
        if (action == gAddnewcheck) {
          //update the current able data
          addNewCheck(actionData, context);
        } else if (action == gAddTable) {
          actionData.forEach((element) {
            Map data0 = Map.of(element);

            addTable(data0, context);
          });
        } else if (action == gBackContext) {
          await setBackContext(context, actionData);
        } else if (action == gChangepassword) {
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
          /*} else if (action == gSetFormDefaultValue) {
          await setFormDefaultValue(actionData);*/
          /*} else if (action == gSetI10n) {
          await setI10n(actionData);*/
        } else if (action == gSetFocus) {
          await setFocusNode(actionData[0][gData], context);
        } else if (action == gSetImgList) {
          await setImgList(actionData);
        } else if (action == 'setInitForm') {
          await setInitForm(actionData);
        } else if (action == 'setMyAction') {
          await setMyAction(actionData);
        } else if (action == gSetMyInfo) {
          await setMyInfo(actionData[0], context);
        } else if (action == gSetMyMenu) {
          await setMyMenu(actionData);
        } else if (action == gSetMyTab) {
          await setMyTab(actionData);
        } else if (action == gSetTab) {
          await setTab(actionData, context);
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
          await setFormList(actionData, context);
        } else if (action == gSetTextController) {
          await setTextController(actionData, context);
        } else if (action == gShowTable) {
          await showTable(actionData[0][gTableID], context,
              actionData[0][gLabel] ?? "", "", "", null, null);
        } else if (action == gSetDroplist) {
          await setDroplist();
        } else if (action == gSetAddressList) {
          await setAddressList(actionData, context);
        }
      });
    } catch (e) {
      throw e;
    } finally {
      waitDialogClose(context);
    }
  }

  processTab(List data, context) {
    data.forEach((element) {
      Map data0 = Map.of(element);
      if (data0[gType].toString().endsWith(gTable) ||
          data0[gType] == gTabletree) {
        addTable(data0, context);
        if (data0[gWhere] != null && data0[gWhere].indexOf("=") > 0) {
          if (data0[gWhere].indexOf(' order by') > 0) {
            data0[gWhere] =
                data0[gWhere].substring(0, data0[gWhere].indexOf(' order by'));
          }
          _whereList[data0[gActionid] + '_' + data0[gLabel]] = data0;

          showTable(data0[gActionid], context, data0[gLabel], data0[gTranspass],
              null, data0[gActionid] + '_' + data0[gLabel], data0[gWhere]);
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
      var tablename = data0[gTableID];

      getTableFloatingBtns(tablename, context);
    });
    showMsg(context, "Save successful", null);

    //myNotifyListeners();
  }

  processTap(context, element, tabName) {
    processTapBasic(context, element, tabName, false);
  }

  processTapBasic(context, element, tabName, needPosChange) {
    if (needPosChange) {
      changeTabPos(tabName, element[gLabel]);
    }
    List tabData = _tabList[tabName][gData];
    for (int i = 0; i < tabData.length; i++) {
      Map el = tabData[i];
      if (el[gLabel] == element[gLabel]) {
        showTab(el[gLabel], context, tabName);
        return;
      }
    }
    /*tabData.forEach((el) {
      if (el[gLabel] == element[gLabel]) {
        showTab(el[gLabel], context, tabName);
        return;
      }
    });*/
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
    _myDetailIDCurrent = 0;
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    myNotifyListeners();
  }

  removeLastScreens(context) {
    Navigator.of(context).pop();

    myNotifyListeners();
  }

  removeOverlay() {
    if (overlayEntry == null) {
      return;
    }
    try {
      overlayEntry?.remove();
      overlayEntry = null;
    } catch (e) {}
    myNotifyListeners();
  }

  removeTableModified(tablename, id) {
    removeTableModifiedByType(tablename, id, gDataModified);
    removeTableModifiedByType(tablename, id, gDataModifiedInvalid);
  }

  removeTableModifiedByType(tablename, id, type) {
    if (isNull(_tableList[tablename]![type])) {
      return;
    }
    if (isNull(_tableList[tablename]![type][id])) {
      return;
    }
    Map modifiedRow = _tableList[tablename]![type];
    modifiedRow.remove(id);
  }

  requestListadd(data) {
    requestListaddCommon(data, false);
  }

  requestListaddCommon(data, isFirst) {
    if (data == null) {
      return;
    }

    if (isFirst) {
      _requestList!.addFirst(data);
    } else {
      _requestList!.add(data);
    }
  }

  requestListAddFirst(data) {
    requestListaddCommon(data, true);
  }

  requestListExists(item) {
    if (_requestList == null) {
      //print('------- request exists: false ' + item.toString());
      return false;
    }
    int length = _requestList!
        .where((element) => element.toString() == item.toString())
        .length;
    bool exists = length > 0;

    return exists;
  }

  requestListRemove(requestFirst) {
    _requestList!.removeWhere(
        (element) => element.toString() == requestFirst.toString());
    //print('---------request list remove ' + requestFirst.toString());
    _requestListRunning.removeWhere(
        (element) => element.toString() == requestFirst.toString());
    //print('---------request list running remove ' + requestFirst.toString());
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
              gLabel: gNull,
              gType: gTable,
              gActionid: tableid,
              gColorIndex: 0,
            }
          ],
          context);
    } catch (e) {
      throw e;
    }
  }

  saveTableModify(data, context) async {
    var tableName = data[gActionid] ?? data[gTableID];
    //print('==== data is ' + data.toString());
    showFormTableEdit(data, context);
    await formSubmit(context, tableName);
  }

  saveTableModifyAll(data, context) {
    var tableName = data[gActionid] ?? data[gTableID];
    if (isNull(_tableList[tableName]![gDataModified])) {
      //print('======== dataModified is null: ' + tableName.toString());
      return;
    }
    Map dataModified = _tableList[tableName]![gDataModified];
    if (dataModified.length < 1) {
      //print('======== dataModified  length is 0: ' + tableName.toString());
      return;
    }

    dataModified.keys.forEach((id) async {
      dynamic dataRow = getTableRowByID(tableName, id);
      //print('======== dataRow 0 is ' + dataModified[id].toString());
      //print('======== dataRow 1 is ' + dataRow.toString());
      showFormTableEditTableID(context, tableName, dataRow);
      await formSubmit(context, tableName);
    });
  }

  saveTableOne(data0, context) {
    //formid = data0[gFormid];
    var tablename = data0[gTableID];
    _tableList[tablename]![gTableMapPrefix] = null;
    //List tableData = tableList[tablename][gData];

    if (data0[gActionid] == gTableAdd) {
      //tableData.insert(0, Map.of(data0[gBody]));
      //finishme(context);
      removeTableModified(tablename, '');
      clearTable(tablename);

      _mFocusNode[gId] = data0[gBody][gId];

      tableInsert(tablename, data0[gBody], context);
      tableList[data0[gTableID]]![gKey] = UniqueKey();
      //if table have detail, popup the detail page
      Map tableAttr = tableList[data0[gTableID]]![gAttr];
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
      //finishme(context);
      //var updateID = data0[gBody][gId];
      //tableData.removeWhere((element) => element[gId] == updateID);
      tableRemove(tablename, data0[gBody], context);
      //tableData.insert(0, Map.of(data0[gBody]));
      tableInsert(tablename, data0[gBody], context);
    } else if (data0[gActionid] == gTableDelete) {
      //var deletedID = data0[gBody][gId];
      //tableData.removeWhere((element) => element[gId] == deletedID);

      tableRemove(tablename, data0[gBody], context);
      clearMFocusNode(context);
    }

    myNotifyListeners();
  }

  searchTable(data, context) {
    var tableId = data[gTableID];
    var searchTxt = data[gSearch];
    _tableList[tableId]![gSearch] = searchTxt;
    myNotifyListeners();
  }

  sendEmail(email) {
    sendEmailBody(email, '', '');
  }

  sendEmailBody(email, subject, body) {
    final anUri = Uri(
        scheme: 'mailto',
        path: email,
        query: 'subject=' + subject.toString() + '&body=' + body.toString());
    _launch(anUri);
  }

  sendEmailItem() {
    var value = getValue(
        _mFocusNode[gName], _mFocusNode[gCol], _mFocusNode[gId])[gValue];
    sendEmail(value);
    //sendEmail(getRowItemOneValue(param)[gValue]);
  }

  sendRequestFormChange(data, context) {
    try {
      if (data[gFormid] == gVerifycode || data[gFormid] == gChangepassword) {
        data[gEmail] = _myId;
      }
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
          Map data = {
            gAction: gGetsessionkey,
            gData: [
              {gKey: param}
            ]
          };
          requestListAddFirst(data);
        }
      }
      if (_requestList!.isEmpty) {
        return;
      }
      if (_requestList!.length < 1) {
        return;
      }
      //while (_requestList.length > 0)
      for (int i = 0; i < _requestList!.length; i++) {
        //Map requestFirst = _requestList.first;
        Map requestFirst = _requestList!.elementAt(i);
        //Map requestFirst = _requestList.removeFirst();
        //print('----------request list remove ' + requestFirst.toString());

        if (_requestListRunning
                .where(
                    (element) => element.toString() == requestFirst.toString())
                .length >
            0) {
          continue;
        }
        _requestListRunning.add(requestFirst);

        if (requestFirst[gAction] != null &&
            requestFirst[gAction] == gLocalAction) {
          try {
            localAction(requestFirst, context);
          } catch (e1) {
            showMsg(context, e1, null);
          } finally {
            requestListRemove(requestFirst);
          }

          return;
        }
        if (_token != '') {
          requestFirst[gToken] = _token;
          requestFirst[gCompanyid] = _globalCompanyid;
          //if is company detail, zzyuser, company, change the companyid to parentid in the where condition.
        }
        //#add timestamp for process table

        if (requestFirst[gData] != null && requestFirst[gData] is List) {
          List requestData = requestFirst[gData];
          var existsTables = '';
          var existsTablesSep = '';
          /*_tableList.forEach((key, value) {
          existsTables = existsTables + existsTablesSep + key;
          existsTablesSep = ',';
        });*/
          _dpList.forEach((key, value) {
            existsTables = existsTables + existsTablesSep + key;
            existsTablesSep = ',';
          });
          requestData.forEach((element) {
            if (!isNull(element[gType]) &&
                element[gType] == gTable &&
                !isNull(element[gActionid])) {
              var tablename = element[gActionid];
              var timestamp;
              if (_tableList[tablename] != null) {
                timestamp = _tableList[tablename]![gTimestamp];
              }
              element[gTimestamp] = timestamp;
              element[gTablelistExist] = existsTables;
            }
          });
        }
        //var dataRequest = encryptByDES(requestFirst);
        try {
          await processRequest(requestFirst, context);
        } catch (e1) {
          showMsg(context, e1, null);
        } finally {
          requestListRemove(requestFirst);
        }
      }

      //await sendRequestList(context);
    } catch (e) {
      showMsg(context, e, null);
      //throw e;
      //print('=====exception is ' + e);
    } finally {}
    //downloadResponse(data);
  }

  sendRequestOne(action, data, context) {
    try {
      //check if duplicate
      if (requestListExists({gAction: action, gData: data})) {
        return;
      }

      requestListadd({gAction: action, gData: data});

      sendRequestList(context);
    } catch (e) {
      throw e;
    } finally {}
  }

  setAddressList(actionData, context) async {
    Map data = Map.of(actionData[0]);
    List result = data[gBody];
    Map attr = Map.of(data[gAttr]);
    dynamic searchTxt = attr[gValue];
    dynamic dpid = attr[gActionid];

    /*dynamic typeOwner = attr[gTypeOwner];
    dynamic name = attr[gName];
    dynamic id = attr[gId];
    dynamic col = attr[gCol];*/
    dynamic typeOwner = _mFocusNode[gType];
    dynamic name = _mFocusNode[gName];
    dynamic id = _mFocusNode[gId];
    dynamic col = _mFocusNode[gCol];
    List resultSort = getArrayMatch(result, searchTxt);
    _dpList[dpid] = resultSort;

    Map item = getFormItem(name, col);

    List actions = [];
    actions.add({
      gType: gIcon,
      gValue: 0xef49,
      gLabel: gConfirm,
      gAction: gLocalAction,
      gItem: item,
      gTypeOwner: typeOwner,
      gName: name,
      gId: id,
    });
    Widget w = await getItemSubWidget(
        item, typeOwner, name, context, id, Colors.black.value, actions);

    //}
    showPopup(context, w, null, actions, false);
  }

  setBackContext(context, actionData) {
    dynamic lastFocus = {};
    List<dynamic> thisList = actionData;
    for (int i = 0; i < thisList.length; i++) {
      lastFocus = Map.of(thisList[i]);
    }
    backContext(lastFocus, context, 1);
  }

  setDplistIcon() {
    List<Map> result = [
      {gLabel: 'ten_k', gValue: 0xedf2},
      {gLabel: 'ten_mp', gValue: 0xedf3},
      {gLabel: 'eleven_mp', gValue: 0xedf4},
      {gLabel: 'onetwothree', gValue: 0xf05b0},
      {gLabel: 'twelve_mp', gValue: 0xedf5},
      {gLabel: 'thirteen_mp', gValue: 0xedf6},
      {gLabel: 'fourteen_mp', gValue: 0xedf7},
      {gLabel: 'fifteen_mp', gValue: 0xedf8},
      {gLabel: 'sixteen_mp', gValue: 0xedf9},
      {gLabel: 'seventeen_mp', gValue: 0xedfa},
      {gLabel: 'eighteen_up_rating', gValue: 0xf06d4},
      {gLabel: 'eighteen_mp', gValue: 0xedfb},
      {gLabel: 'nineteen_mp', gValue: 0xedfc},
      {gLabel: 'one_k', gValue: 0xedfd},
      {gLabel: 'one_k_plus', gValue: 0xedfe},
      {gLabel: 'one_x_mobiledata', gValue: 0xedff},
      {gLabel: 'twenty_mp', gValue: 0xee00},
      {gLabel: 'twenty_one_mp', gValue: 0xee01},
      {gLabel: 'twenty_two_mp', gValue: 0xee02},
      {gLabel: 'twenty_three_mp', gValue: 0xee03},
      {gLabel: 'twenty_four_mp', gValue: 0xee04},
      {gLabel: 'two_k', gValue: 0xee05},
      {gLabel: 'two_k_plus', gValue: 0xee06},
      {gLabel: 'two_mp', gValue: 0xee07},
      {gLabel: 'thirty_fps', gValue: 0xee08},
      {gLabel: 'thirty_fps_select', gValue: 0xee09},
      {gLabel: 'threesixty', gValue: 0xee0a},
      {gLabel: 'threed_rotation', gValue: 0xee0b},
      {gLabel: 'three_g_mobiledata', gValue: 0xee0c},
      {gLabel: 'three_k', gValue: 0xee0d},
      {gLabel: 'three_k_plus', gValue: 0xee0e},
      {gLabel: 'three_mp', gValue: 0xee0f},
      {gLabel: 'three_p', gValue: 0xee10},
      {gLabel: 'four_g_mobiledata', gValue: 0xee11},
      {gLabel: 'four_g_plus_mobiledata', gValue: 0xee12},
      {gLabel: 'four_k', gValue: 0xee13},
      {gLabel: 'four_k_plus', gValue: 0xee14},
      {gLabel: 'four_mp', gValue: 0xee15},
      {gLabel: 'five_g', gValue: 0xee16},
      {gLabel: 'five_k', gValue: 0xee17},
      {gLabel: 'five_k_plus', gValue: 0xee18},
      {gLabel: 'five_mp', gValue: 0xee19},
      {gLabel: 'sixty_fps', gValue: 0xee1a},
      {gLabel: 'sixty_fps_select', gValue: 0xee1b},
      {gLabel: 'six_ft_apart', gValue: 0xee1c},
      {gLabel: 'six_k', gValue: 0xee1d},
      {gLabel: 'six_k_plus', gValue: 0xee1e},
      {gLabel: 'six_mp', gValue: 0xee1f},
      {gLabel: 'seven_k', gValue: 0xee20},
      {gLabel: 'seven_k_plus', gValue: 0xee21},
      {gLabel: 'seven_mp', gValue: 0xee22},
      {gLabel: 'eight_k', gValue: 0xee23},
      {gLabel: 'eight_k_plus', gValue: 0xee24},
      {gLabel: 'eight_mp', gValue: 0xee25},
      {gLabel: 'nine_k', gValue: 0xee26},
      {gLabel: 'nine_k_plus', gValue: 0xee27},
      {gLabel: 'nine_mp', gValue: 0xee28},
      {gLabel: 'abc', gValue: 0xf05b1},
      {gLabel: 'ac_unit', gValue: 0xee29},
      {gLabel: 'access_alarm', gValue: 0xee2a},
      {gLabel: 'access_alarms', gValue: 0xee2b},
      {gLabel: 'access_time', gValue: 0xee2d},
      {gLabel: 'access_time_filled', gValue: 0xee2c},
      {gLabel: 'accessibility', gValue: 0xee2f},
      {gLabel: 'accessibility_new', gValue: 0xee2e},
      {gLabel: 'accessible', gValue: 0xee31},
      {gLabel: 'accessible_forward', gValue: 0xee30},
      {gLabel: 'account_balance', gValue: 0xee32},
      {gLabel: 'account_balance_wallet', gValue: 0xee33},
      {gLabel: 'account_box', gValue: 0xee34},
      {gLabel: 'account_circle', gValue: 0xee35},
      {gLabel: 'account_tree', gValue: 0xee36},
      {gLabel: 'ad_units', gValue: 0xee37},
      {gLabel: 'adb', gValue: 0xee38},
      {gLabel: 'add', gValue: 0xee47},
      {gLabel: 'add_a_photo', gValue: 0xee39},
      {gLabel: 'add_alarm', gValue: 0xee3a},
      {gLabel: 'add_alert', gValue: 0xee3b},
      {gLabel: 'add_box', gValue: 0xee3c},
      {gLabel: 'add_business', gValue: 0xee3d},
      {gLabel: 'add_card', gValue: 0xf05b2},
      {gLabel: 'add_chart', gValue: 0xee3e},
      {gLabel: 'add_circle', gValue: 0xee40},
      {gLabel: 'add_circle_outline', gValue: 0xee3f},
      {gLabel: 'add_comment', gValue: 0xee41},
      {gLabel: 'add_home', gValue: 0xf06d5},
      {gLabel: 'add_home_work', gValue: 0xf06d6},
      {gLabel: 'add_ic_call', gValue: 0xee42},
      {gLabel: 'add_link', gValue: 0xee43},
      {gLabel: 'add_location', gValue: 0xee45},
      {gLabel: 'add_location_alt', gValue: 0xee44},
      {gLabel: 'add_moderator', gValue: 0xee46},
      {gLabel: 'add_photo_alternate', gValue: 0xee48},
      {gLabel: 'add_reaction', gValue: 0xee49},
      {gLabel: 'add_road', gValue: 0xee4a},
      {gLabel: 'add_shopping_cart', gValue: 0xee4b},
      {gLabel: 'add_task', gValue: 0xee4c},
      {gLabel: 'add_to_drive', gValue: 0xee4d},
      {gLabel: 'add_to_home_screen', gValue: 0xee4e},
      {gLabel: 'add_to_photos', gValue: 0xee4f},
      {gLabel: 'add_to_queue', gValue: 0xee50},
      {gLabel: 'addchart', gValue: 0xee51},
      {gLabel: 'adf_scanner', gValue: 0xf05b3},
      {gLabel: 'adjust', gValue: 0xee52},
      {gLabel: 'admin_panel_settings', gValue: 0xee53},
      {gLabel: 'adobe', gValue: 0xf05b4},
      {gLabel: 'ads_click', gValue: 0xf05b5},
      {gLabel: 'agriculture', gValue: 0xee54},
      {gLabel: 'air', gValue: 0xee55},
      {gLabel: 'airline_seat_flat', gValue: 0xee57},
      {gLabel: 'airline_seat_flat_angled', gValue: 0xee56},
      {gLabel: 'airline_seat_individual_suite', gValue: 0xee58},
      {gLabel: 'airline_seat_legroom_extra', gValue: 0xee59},
      {gLabel: 'airline_seat_legroom_normal', gValue: 0xee5a},
      {gLabel: 'airline_seat_legroom_reduced', gValue: 0xee5b},
      {gLabel: 'airline_seat_recline_extra', gValue: 0xee5c},
      {gLabel: 'airline_seat_recline_normal', gValue: 0xee5d},
      {gLabel: 'airline_stops', gValue: 0xf05b6},
      {gLabel: 'airlines', gValue: 0xf05b7},
      {gLabel: 'airplane_ticket', gValue: 0xee5e},
      {gLabel: 'airplanemode_active', gValue: 0xee5f},
      {gLabel: 'airplanemode_inactive', gValue: 0xee60},
      {gLabel: 'airplanemode_off', gValue: 0xee60},
      {gLabel: 'airplanemode_on', gValue: 0xee5f},
      {gLabel: 'airplay', gValue: 0xee61},
      {gLabel: 'airport_shuttle', gValue: 0xee62},
      {gLabel: 'alarm', gValue: 0xee66},
      {gLabel: 'alarm_add', gValue: 0xee63},
      {gLabel: 'alarm_off', gValue: 0xee64},
      {gLabel: 'alarm_on', gValue: 0xee65},
      {gLabel: 'album', gValue: 0xee67},
      {gLabel: 'align_horizontal_center', gValue: 0xee68},
      {gLabel: 'align_horizontal_left', gValue: 0xee69},
      {gLabel: 'align_horizontal_right', gValue: 0xee6a},
      {gLabel: 'align_vertical_bottom', gValue: 0xee6b},
      {gLabel: 'align_vertical_center', gValue: 0xee6c},
      {gLabel: 'align_vertical_top', gValue: 0xee6d},
      {gLabel: 'all_inbox', gValue: 0xee6e},
      {gLabel: 'all_inclusive', gValue: 0xee6f},
      {gLabel: 'all_out', gValue: 0xee70},
      {gLabel: 'alt_route', gValue: 0xee71},
      {gLabel: 'alternate_email', gValue: 0xee72},
      {gLabel: 'amp_stories', gValue: 0xee73},
      {gLabel: 'analytics', gValue: 0xee74},
      {gLabel: 'anchor', gValue: 0xee75},
      {gLabel: 'android', gValue: 0xee76},
      {gLabel: 'animation', gValue: 0xee77},
      {gLabel: 'announcement', gValue: 0xee78},
      {gLabel: 'aod', gValue: 0xee79},
      {gLabel: 'apartment', gValue: 0xee7a},
      {gLabel: 'api', gValue: 0xee7b},
      {gLabel: 'app_blocking', gValue: 0xee7c},
      {gLabel: 'app_registration', gValue: 0xee7d},
      {gLabel: 'app_settings_alt', gValue: 0xee7e},
      {gLabel: 'app_shortcut', gValue: 0xf05b8},
      {gLabel: 'apple', gValue: 0xf05b9},
      {gLabel: 'approval', gValue: 0xee7f},
      {gLabel: 'apps', gValue: 0xee80},
      {gLabel: 'apps_outage', gValue: 0xf05ba},
      {gLabel: 'architecture', gValue: 0xee81},
      {gLabel: 'archive', gValue: 0xee82},
      {gLabel: 'area_chart', gValue: 0xf05bb},
      {gLabel: 'arrow_back', gValue: 0xee85},
      {gLabel: 'arrow_back_ios', gValue: 0xee84},
      {gLabel: 'arrow_back_ios_new', gValue: 0xee83},
      {gLabel: 'arrow_circle_down', gValue: 0xee86},
      {gLabel: 'arrow_circle_left', gValue: 0xf05bc},
      {gLabel: 'arrow_circle_right', gValue: 0xf05bd},
      {gLabel: 'arrow_circle_up', gValue: 0xee87},
      {gLabel: 'arrow_downward', gValue: 0xee88},
      {gLabel: 'arrow_drop_down', gValue: 0xee8a},
      {gLabel: 'arrow_drop_down_circle', gValue: 0xee89},
      {gLabel: 'arrow_drop_up', gValue: 0xee8b},
      {gLabel: 'arrow_forward', gValue: 0xee8d},
      {gLabel: 'arrow_forward_ios', gValue: 0xee8c},
      {gLabel: 'arrow_left', gValue: 0xee8e},
      {gLabel: 'arrow_outward', gValue: 0xf089b},
      {gLabel: 'arrow_right', gValue: 0xee90},
      {gLabel: 'arrow_right_alt', gValue: 0xee8f},
      {gLabel: 'arrow_upward', gValue: 0xee91},
      {gLabel: 'art_track', gValue: 0xee92},
      {gLabel: 'article', gValue: 0xee93},
      {gLabel: 'aspect_ratio', gValue: 0xee94},
      {gLabel: 'assessment', gValue: 0xee95},
      {gLabel: 'assignment', gValue: 0xee98},
      {gLabel: 'assignment_ind', gValue: 0xee96},
      {gLabel: 'assignment_late', gValue: 0xee97},
      {gLabel: 'assignment_return', gValue: 0xee99},
      {gLabel: 'assignment_returned', gValue: 0xee9a},
      {gLabel: 'assignment_turned_in', gValue: 0xee9b},
      {gLabel: 'assist_walker', gValue: 0xf089c},
      {gLabel: 'assistant', gValue: 0xee9d},
      {gLabel: 'assistant_direction', gValue: 0xee9c},
      {gLabel: 'assistant_photo', gValue: 0xee9e},
      {gLabel: 'assured_workload', gValue: 0xf05be},
      {gLabel: 'atm', gValue: 0xee9f},
      {gLabel: 'attach_email', gValue: 0xeea0},
      {gLabel: 'attach_file', gValue: 0xeea1},
      {gLabel: 'attach_money', gValue: 0xeea2},
      {gLabel: 'attachment', gValue: 0xeea3},
      {gLabel: 'attractions', gValue: 0xeea4},
      {gLabel: 'attribution', gValue: 0xeea5},
      {gLabel: 'audio_file', gValue: 0xf05bf},
      {gLabel: 'audiotrack', gValue: 0xeea6},
      {gLabel: 'auto_awesome', gValue: 0xeea9},
      {gLabel: 'auto_awesome_mosaic', gValue: 0xeea7},
      {gLabel: 'auto_awesome_motion', gValue: 0xeea8},
      {gLabel: 'auto_delete', gValue: 0xeeaa},
      {gLabel: 'auto_fix_high', gValue: 0xeeab},
      {gLabel: 'auto_fix_normal', gValue: 0xeeac},
      {gLabel: 'auto_fix_off', gValue: 0xeead},
      {gLabel: 'auto_graph', gValue: 0xeeae},
      {gLabel: 'auto_mode', gValue: 0xf06d7},
      {gLabel: 'auto_stories', gValue: 0xeeaf},
      {gLabel: 'autofps_select', gValue: 0xeeb0},
      {gLabel: 'autorenew', gValue: 0xeeb1},
      {gLabel: 'av_timer', gValue: 0xeeb2},
      {gLabel: 'baby_changing_station', gValue: 0xeeb3},
      {gLabel: 'back_hand', gValue: 0xf05c0},
      {gLabel: 'backpack', gValue: 0xeeb4},
      {gLabel: 'backspace', gValue: 0xeeb5},
      {gLabel: 'backup', gValue: 0xeeb6},
      {gLabel: 'backup_table', gValue: 0xeeb7},
      {gLabel: 'badge', gValue: 0xeeb8},
      {gLabel: 'bakery_dining', gValue: 0xeeb9},
      {gLabel: 'balance', gValue: 0xf05c1},
      {gLabel: 'balcony', gValue: 0xeeba},
      {gLabel: 'ballot', gValue: 0xeebb},
      {gLabel: 'bar_chart', gValue: 0xeebc},
      {gLabel: 'batch_prediction', gValue: 0xeebd},
      {gLabel: 'bathroom', gValue: 0xeebe},
      {gLabel: 'bathtub', gValue: 0xeebf},
      {gLabel: 'battery_0_bar', gValue: 0xf06d8},
      {gLabel: 'battery_1_bar', gValue: 0xf06d9},
      {gLabel: 'battery_2_bar', gValue: 0xf06da},
      {gLabel: 'battery_3_bar', gValue: 0xf06db},
      {gLabel: 'battery_4_bar', gValue: 0xf06dc},
      {gLabel: 'battery_5_bar', gValue: 0xf06dd},
      {gLabel: 'battery_6_bar', gValue: 0xf06de},
      {gLabel: 'battery_alert', gValue: 0xeec0},
      {gLabel: 'battery_charging_full', gValue: 0xeec1},
      {gLabel: 'battery_full', gValue: 0xeec2},
      {gLabel: 'battery_saver', gValue: 0xeec3},
      {gLabel: 'battery_std', gValue: 0xeec4},
      {gLabel: 'battery_unknown', gValue: 0xeec5},
      {gLabel: 'beach_access', gValue: 0xeec6},
      {gLabel: 'bed', gValue: 0xeec7},
      {gLabel: 'bedroom_baby', gValue: 0xeec8},
      {gLabel: 'bedroom_child', gValue: 0xeec9},
      {gLabel: 'bedroom_parent', gValue: 0xeeca},
      {gLabel: 'bedtime', gValue: 0xeecb},
      {gLabel: 'bedtime_off', gValue: 0xf05c2},
      {gLabel: 'beenhere', gValue: 0xeecc},
      {gLabel: 'bento', gValue: 0xeecd},
      {gLabel: 'bike_scooter', gValue: 0xeece},
      {gLabel: 'biotech', gValue: 0xeecf},
      {gLabel: 'blender', gValue: 0xeed0},
      {gLabel: 'blind', gValue: 0xf089d},
      {gLabel: 'blinds', gValue: 0xf06e0},
      {gLabel: 'blinds_closed', gValue: 0xf06df},
      {gLabel: 'block', gValue: 0xeed1},
      {gLabel: 'bloodtype', gValue: 0xeed2},
      {gLabel: 'bluetooth', gValue: 0xeed7},
      {gLabel: 'bluetooth_audio', gValue: 0xeed3},
      {gLabel: 'bluetooth_connected', gValue: 0xeed4},
      {gLabel: 'bluetooth_disabled', gValue: 0xeed5},
      {gLabel: 'bluetooth_drive', gValue: 0xeed6},
      {gLabel: 'bluetooth_searching', gValue: 0xeed8},
      {gLabel: 'blur_circular', gValue: 0xeed9},
      {gLabel: 'blur_linear', gValue: 0xeeda},
      {gLabel: 'blur_off', gValue: 0xeedb},
      {gLabel: 'blur_on', gValue: 0xeedc},
      {gLabel: 'bolt', gValue: 0xeedd},
      {gLabel: 'book', gValue: 0xeedf},
      {gLabel: 'book_online', gValue: 0xeede},
      {gLabel: 'bookmark', gValue: 0xeee3},
      {gLabel: 'bookmark_add', gValue: 0xeee0},
      {gLabel: 'bookmark_added', gValue: 0xeee1},
      {gLabel: 'bookmark_border', gValue: 0xeee2},
      {gLabel: 'bookmark_outline', gValue: 0xeee2},
      {gLabel: 'bookmark_remove', gValue: 0xeee4},
      {gLabel: 'bookmarks', gValue: 0xeee5},
      {gLabel: 'border_all', gValue: 0xeee6},
      {gLabel: 'border_bottom', gValue: 0xeee7},
      {gLabel: 'border_clear', gValue: 0xeee8},
      {gLabel: 'border_color', gValue: 0xeee9},
      {gLabel: 'border_horizontal', gValue: 0xeeea},
      {gLabel: 'border_inner', gValue: 0xeeeb},
      {gLabel: 'border_left', gValue: 0xeeec},
      {gLabel: 'border_outer', gValue: 0xeeed},
      {gLabel: 'border_right', gValue: 0xeeee},
      {gLabel: 'border_style', gValue: 0xeeef},
      {gLabel: 'border_top', gValue: 0xeef0},
      {gLabel: 'border_vertical', gValue: 0xeef1},
      {gLabel: 'boy', gValue: 0xf05c3},
      {gLabel: 'branding_watermark', gValue: 0xeef2},
      {gLabel: 'breakfast_dining', gValue: 0xeef3},
      {gLabel: 'brightness_1', gValue: 0xeef4},
      {gLabel: 'brightness_2', gValue: 0xeef5},
      {gLabel: 'brightness_3', gValue: 0xeef6},
      {gLabel: 'brightness_4', gValue: 0xeef7},
      {gLabel: 'brightness_5', gValue: 0xeef8},
      {gLabel: 'brightness_6', gValue: 0xeef9},
      {gLabel: 'brightness_7', gValue: 0xeefa},
      {gLabel: 'brightness_auto', gValue: 0xeefb},
      {gLabel: 'brightness_high', gValue: 0xeefc},
      {gLabel: 'brightness_low', gValue: 0xeefd},
      {gLabel: 'brightness_medium', gValue: 0xeefe},
      {gLabel: 'broadcast_on_home', gValue: 0xf06e1},
      {gLabel: 'broadcast_on_personal', gValue: 0xf06e2},
      {gLabel: 'broken_image', gValue: 0xeeff},
      {gLabel: 'browse_gallery', gValue: 0xf03bc},
      {gLabel: 'browser_not_supported', gValue: 0xef00},
      {gLabel: 'browser_updated', gValue: 0xf05c4},
      {gLabel: 'brunch_dining', gValue: 0xef01},
      {gLabel: 'brush', gValue: 0xef02},
      {gLabel: 'bubble_chart', gValue: 0xef03},
      {gLabel: 'bug_report', gValue: 0xef04},
      {gLabel: 'build', gValue: 0xef06},
      {gLabel: 'build_circle', gValue: 0xef05},
      {gLabel: 'bungalow', gValue: 0xef07},
      {gLabel: 'burst_mode', gValue: 0xef08},
      {gLabel: 'bus_alert', gValue: 0xef09},
      {gLabel: 'business', gValue: 0xef0b},
      {gLabel: 'business_center', gValue: 0xef0a},
      {gLabel: 'cabin', gValue: 0xef0c},
      {gLabel: 'cable', gValue: 0xef0d},
      {gLabel: 'cached', gValue: 0xef0e},
      {gLabel: 'cake', gValue: 0xef0f},
      {gLabel: 'calculate', gValue: 0xef10},
      {gLabel: 'calendar_month', gValue: 0xf051f},
      {gLabel: 'calendar_today', gValue: 0xef11},
      {gLabel: 'calendar_view_day', gValue: 0xef12},
      {gLabel: 'calendar_view_month', gValue: 0xef13},
      {gLabel: 'calendar_view_week', gValue: 0xef14},
      {gLabel: 'call', gValue: 0xef1a},
      {gLabel: 'call_end', gValue: 0xef15},
      {gLabel: 'call_made', gValue: 0xef16},
      {gLabel: 'call_merge', gValue: 0xef17},
      {gLabel: 'call_missed', gValue: 0xef19},
      {gLabel: 'call_missed_outgoing', gValue: 0xef18},
      {gLabel: 'call_received', gValue: 0xef1b},
      {gLabel: 'call_split', gValue: 0xef1c},
      {gLabel: 'call_to_action', gValue: 0xef1d},
      {gLabel: 'camera', gValue: 0xef23},
      {gLabel: 'camera_alt', gValue: 0xef1e},
      {gLabel: 'camera_enhance', gValue: 0xef1f},
      {gLabel: 'camera_front', gValue: 0xef20},
      {gLabel: 'camera_indoor', gValue: 0xef21},
      {gLabel: 'camera_outdoor', gValue: 0xef22},
      {gLabel: 'camera_rear', gValue: 0xef24},
      {gLabel: 'camera_roll', gValue: 0xef25},
      {gLabel: 'cameraswitch', gValue: 0xef26},
      {gLabel: 'campaign', gValue: 0xef27},
      {gLabel: 'cancel', gValue: 0xef28},
      {gLabel: 'cancel_presentation', gValue: 0xef29},
      {gLabel: 'cancel_schedule_send', gValue: 0xef2a},
      {gLabel: 'candlestick_chart', gValue: 0xf05c5},
      {gLabel: 'car_crash', gValue: 0xf06e3},
      {gLabel: 'car_rental', gValue: 0xef2b},
      {gLabel: 'car_repair', gValue: 0xef2c},
      {gLabel: 'card_giftcard', gValue: 0xef2d},
      {gLabel: 'card_membership', gValue: 0xef2e},
      {gLabel: 'card_travel', gValue: 0xef2f},
      {gLabel: 'carpenter', gValue: 0xef30},
      {gLabel: 'cases', gValue: 0xef31},
      {gLabel: 'casino', gValue: 0xef32},
      {gLabel: 'cast', gValue: 0xef35},
      {gLabel: 'cast_connected', gValue: 0xef33},
      {gLabel: 'cast_for_education', gValue: 0xef34},
      {gLabel: 'castle', gValue: 0xf05c6},
      {gLabel: 'catching_pokemon', gValue: 0xef36},
      {gLabel: 'category', gValue: 0xef37},
      {gLabel: 'celebration', gValue: 0xef38},
      {gLabel: 'cell_tower', gValue: 0xf05c7},
      {gLabel: 'cell_wifi', gValue: 0xef39},
      {gLabel: 'center_focus_strong', gValue: 0xef3a},
      {gLabel: 'center_focus_weak', gValue: 0xef3b},
      {gLabel: 'chair', gValue: 0xef3d},
      {gLabel: 'chair_alt', gValue: 0xef3c},
      {gLabel: 'chalet', gValue: 0xef3e},
      {gLabel: 'change_circle', gValue: 0xef3f},
      {gLabel: 'change_history', gValue: 0xef40},
      {gLabel: 'charging_station', gValue: 0xef41},
      {gLabel: 'chat', gValue: 0xef44},
      {gLabel: 'chat_bubble', gValue: 0xef43},
      {gLabel: 'chat_bubble_outline', gValue: 0xef42},
      {gLabel: 'check', gValue: 0xef49},
      {gLabel: 'check_box', gValue: 0xef46},
      {gLabel: 'check_box_outline_blank', gValue: 0xef45},
      {gLabel: 'check_circle', gValue: 0xef48},
      {gLabel: 'check_circle_outline', gValue: 0xef47},
      {gLabel: 'checklist', gValue: 0xef4a},
      {gLabel: 'checklist_rtl', gValue: 0xef4b},
      {gLabel: 'checkroom', gValue: 0xef4c},
      {gLabel: 'chevron_left', gValue: 0xef4d},
      {gLabel: 'chevron_right', gValue: 0xef4e},
      {gLabel: 'child_care', gValue: 0xef4f},
      {gLabel: 'child_friendly', gValue: 0xef50},
      {gLabel: 'chrome_reader_mode', gValue: 0xef51},
      {gLabel: 'church', gValue: 0xf05c8},
      {gLabel: 'circle', gValue: 0xef53},
      {gLabel: 'circle_notifications', gValue: 0xef52},
      {gLabel: 'class', gValue: 0xef54},
      {gLabel: 'clean_hands', gValue: 0xef55},
      {gLabel: 'cleaning_services', gValue: 0xef56},
      {gLabel: 'clear', gValue: 0xef58},
      {gLabel: 'clear_all', gValue: 0xef57},
      {gLabel: 'close', gValue: 0xef5a},
      {gLabel: 'close_fullscreen', gValue: 0xef59},
      {gLabel: 'closed_caption', gValue: 0xef5d},
      {gLabel: 'closed_caption_disabled', gValue: 0xef5b},
      {gLabel: 'closed_caption_off', gValue: 0xef5c},
      {gLabel: 'cloud', gValue: 0xef62},
      {gLabel: 'cloud_circle', gValue: 0xef5e},
      {gLabel: 'cloud_done', gValue: 0xef5f},
      {gLabel: 'cloud_download', gValue: 0xef60},
      {gLabel: 'cloud_off', gValue: 0xef61},
      {gLabel: 'cloud_queue', gValue: 0xef63},
      {gLabel: 'cloud_sync', gValue: 0xf05c9},
      {gLabel: 'cloud_upload', gValue: 0xef64},
      {gLabel: 'co2', gValue: 0xf05ca},
      {gLabel: 'co_present', gValue: 0xf05cb},
      {gLabel: 'code', gValue: 0xef66},
      {gLabel: 'code_off', gValue: 0xef65},
      {gLabel: 'coffee', gValue: 0xef68},
      {gLabel: 'coffee_maker', gValue: 0xef67},
      {gLabel: 'collections', gValue: 0xef6a},
      {gLabel: 'collections_bookmark', gValue: 0xef69},
      {gLabel: 'color_lens', gValue: 0xef6b},
      {gLabel: 'colorize', gValue: 0xef6c},
      {gLabel: 'comment', gValue: 0xef6e},
      {gLabel: 'comment_bank', gValue: 0xef6d},
      {gLabel: 'comments_disabled', gValue: 0xf05cc},
      {gLabel: 'commit', gValue: 0xf05cd},
      {gLabel: 'commute', gValue: 0xef6f},
      {gLabel: 'compare', gValue: 0xef71},
      {gLabel: 'compare_arrows', gValue: 0xef70},
      {gLabel: 'compass_calibration', gValue: 0xef72},
      {gLabel: 'compost', gValue: 0xf05ce},
      {gLabel: 'compress', gValue: 0xef73},
      {gLabel: 'computer', gValue: 0xef74},
      {gLabel: 'confirmation_num', gValue: 0xef75},
      {gLabel: 'confirmation_number', gValue: 0xef75},
      {gLabel: 'connect_without_contact', gValue: 0xef76},
      {gLabel: 'connected_tv', gValue: 0xef77},
      {gLabel: 'connecting_airports', gValue: 0xf05cf},
      {gLabel: 'construction', gValue: 0xef78},
      {gLabel: 'contact_emergency', gValue: 0xf089e},
      {gLabel: 'contact_mail', gValue: 0xef79},
      {gLabel: 'contact_page', gValue: 0xef7a},
      {gLabel: 'contact_phone', gValue: 0xef7b},
      {gLabel: 'contact_support', gValue: 0xef7c},
      {gLabel: 'contactless', gValue: 0xef7d},
      {gLabel: 'contacts', gValue: 0xef7e},
      {gLabel: 'content_copy', gValue: 0xef7f},
      {gLabel: 'content_cut', gValue: 0xef80},
      {gLabel: 'content_paste', gValue: 0xef82},
      {gLabel: 'content_paste_go', gValue: 0xf05d0},
      {gLabel: 'content_paste_off', gValue: 0xef81},
      {gLabel: 'content_paste_search', gValue: 0xf05d1},
      {gLabel: 'contrast', gValue: 0xf05d2},
      {gLabel: 'control_camera', gValue: 0xef83},
      {gLabel: 'control_point', gValue: 0xef85},
      {gLabel: 'control_point_duplicate', gValue: 0xef84},
      {gLabel: 'cookie', gValue: 0xf05d3},
      {gLabel: 'copy', gValue: 0xef7f},
      {gLabel: 'copy_all', gValue: 0xef86},
      {gLabel: 'copyright', gValue: 0xef87},
      {gLabel: 'coronavirus', gValue: 0xef88},
      {gLabel: 'corporate_fare', gValue: 0xef89},
      {gLabel: 'cottage', gValue: 0xef8a},
      {gLabel: 'countertops', gValue: 0xef8b},
      {gLabel: 'create', gValue: 0xef8d},
      {gLabel: 'create_new_folder', gValue: 0xef8c},
      {gLabel: 'credit_card', gValue: 0xef8f},
      {gLabel: 'credit_card_off', gValue: 0xef8e},
      {gLabel: 'credit_score', gValue: 0xef90},
      {gLabel: 'crib', gValue: 0xef91},
      {gLabel: 'crisis_alert', gValue: 0xf06e4},
      {gLabel: 'crop', gValue: 0xef9a},
      {gLabel: 'crop_16_9', gValue: 0xef92},
      {gLabel: 'crop_3_2', gValue: 0xef93},
      {gLabel: 'crop_5_4', gValue: 0xef94},
      {gLabel: 'crop_7_5', gValue: 0xef95},
      {gLabel: 'crop_din', gValue: 0xef96},
      {gLabel: 'crop_free', gValue: 0xef97},
      {gLabel: 'crop_landscape', gValue: 0xef98},
      {gLabel: 'crop_original', gValue: 0xef99},
      {gLabel: 'crop_portrait', gValue: 0xef9b},
      {gLabel: 'crop_rotate', gValue: 0xef9c},
      {gLabel: 'crop_square', gValue: 0xef9d},
      {gLabel: 'cruelty_free', gValue: 0xf05d4},
      {gLabel: 'css', gValue: 0xf05d5},
      {gLabel: 'currency_bitcoin', gValue: 0xf054a},
      {gLabel: 'currency_exchange', gValue: 0xf05d6},
      {gLabel: 'currency_franc', gValue: 0xf05d7},
      {gLabel: 'currency_lira', gValue: 0xf05d8},
      {gLabel: 'currency_pound', gValue: 0xf05d9},
      {gLabel: 'currency_ruble', gValue: 0xf05da},
      {gLabel: 'currency_rupee', gValue: 0xf05db},
      {gLabel: 'currency_yen', gValue: 0xf05dc},
      {gLabel: 'currency_yuan', gValue: 0xf05dd},
      {gLabel: 'curtains', gValue: 0xf06e6},
      {gLabel: 'curtains_closed', gValue: 0xf06e5},
      {gLabel: 'cut', gValue: 0xef80},
      {gLabel: 'cyclone', gValue: 0xf06e7},
      {gLabel: 'dangerous', gValue: 0xef9e},
      {gLabel: 'dark_mode', gValue: 0xef9f},
      {gLabel: 'dashboard', gValue: 0xefa1},
      {gLabel: 'dashboard_customize', gValue: 0xefa0},
      {gLabel: 'data_array', gValue: 0xf05de},
      {gLabel: 'data_exploration', gValue: 0xf05df},
      {gLabel: 'data_object', gValue: 0xf05e0},
      {gLabel: 'data_saver_off', gValue: 0xefa2},
      {gLabel: 'data_saver_on', gValue: 0xefa3},
      {gLabel: 'data_thresholding', gValue: 0xf05e1},
      {gLabel: 'data_usage', gValue: 0xefa4},
      {gLabel: 'dataset', gValue: 0xf06e9},
      {gLabel: 'dataset_linked', gValue: 0xf06e8},
      {gLabel: 'date_range', gValue: 0xefa5},
      {gLabel: 'deblur', gValue: 0xf05e2},
      {gLabel: 'deck', gValue: 0xefa6},
      {gLabel: 'dehaze', gValue: 0xefa7},
      {gLabel: 'delete', gValue: 0xefaa},
      {gLabel: 'delete_forever', gValue: 0xefa8},
      {gLabel: 'delete_outline', gValue: 0xefa9},
      {gLabel: 'delete_sweep', gValue: 0xefab},
      {gLabel: 'delivery_dining', gValue: 0xefac},
      {gLabel: 'density_large', gValue: 0xf05e3},
      {gLabel: 'density_medium', gValue: 0xf05e4},
      {gLabel: 'density_small', gValue: 0xf05e5},
      {gLabel: 'departure_board', gValue: 0xefad},
      {gLabel: 'description', gValue: 0xefae},
      {gLabel: 'deselect', gValue: 0xf05e6},
      {gLabel: 'design_services', gValue: 0xefaf},
      {gLabel: 'desk', gValue: 0xf06ea},
      {gLabel: 'desktop_access_disabled', gValue: 0xefb0},
      {gLabel: 'desktop_mac', gValue: 0xefb1},
      {gLabel: 'desktop_windows', gValue: 0xefb2},
      {gLabel: 'details', gValue: 0xefb3},
      {gLabel: 'developer_board', gValue: 0xefb5},
      {gLabel: 'developer_board_off', gValue: 0xefb4},
      {gLabel: 'developer_mode', gValue: 0xefb6},
      {gLabel: 'device_hub', gValue: 0xefb7},
      {gLabel: 'device_thermostat', gValue: 0xefb8},
      {gLabel: 'device_unknown', gValue: 0xefb9},
      {gLabel: 'devices', gValue: 0xefbb},
      {gLabel: 'devices_fold', gValue: 0xf06eb},
      {gLabel: 'devices_other', gValue: 0xefba},
      {gLabel: 'dialer_sip', gValue: 0xefbc},
      {gLabel: 'dialpad', gValue: 0xefbd},
      {gLabel: 'diamond', gValue: 0xf05e7},
      {gLabel: 'difference', gValue: 0xf05e8},
      {gLabel: 'dining', gValue: 0xefbe},
      {gLabel: 'dinner_dining', gValue: 0xefbf},
      {gLabel: 'directions', gValue: 0xefc8},
      {gLabel: 'directions_bike', gValue: 0xefc0},
      {gLabel: 'directions_boat', gValue: 0xefc2},
      {gLabel: 'directions_boat_filled', gValue: 0xefc1},
      {gLabel: 'directions_bus', gValue: 0xefc4},
      {gLabel: 'directions_bus_filled', gValue: 0xefc3},
      {gLabel: 'directions_car', gValue: 0xefc6},
      {gLabel: 'directions_car_filled', gValue: 0xefc5},
      {gLabel: 'directions_ferry', gValue: 0xefc2},
      {gLabel: 'directions_off', gValue: 0xefc7},
      {gLabel: 'directions_railway', gValue: 0xefca},
      {gLabel: 'directions_railway_filled', gValue: 0xefc9},
      {gLabel: 'directions_run', gValue: 0xefcb},
      {gLabel: 'directions_subway', gValue: 0xefcd},
      {gLabel: 'directions_subway_filled', gValue: 0xefcc},
      {gLabel: 'directions_train', gValue: 0xefca},
      {gLabel: 'directions_transit', gValue: 0xefcf},
      {gLabel: 'directions_transit_filled', gValue: 0xefce},
      {gLabel: 'directions_walk', gValue: 0xefd0},
      {gLabel: 'dirty_lens', gValue: 0xefd1},
      {gLabel: 'disabled_by_default', gValue: 0xefd2},
      {gLabel: 'disabled_visible', gValue: 0xf05e9},
      {gLabel: 'disc_full', gValue: 0xefd3},
      {gLabel: 'discord', gValue: 0xf05ea},
      {gLabel: 'discount', gValue: 0xf06a3},
      {gLabel: 'display_settings', gValue: 0xf05eb},
      {gLabel: 'diversity_1', gValue: 0xf089f},
      {gLabel: 'diversity_2', gValue: 0xf08a0},
      {gLabel: 'diversity_3', gValue: 0xf08a1},
      {gLabel: 'dnd_forwardslash', gValue: 0xefd9},
      {gLabel: 'dns', gValue: 0xefd4},
      {gLabel: 'do_disturb', gValue: 0xefd8},
      {gLabel: 'do_disturb_alt', gValue: 0xefd5},
      {gLabel: 'do_disturb_off', gValue: 0xefd6},
      {gLabel: 'do_disturb_on', gValue: 0xefd7},
      {gLabel: 'do_not_disturb', gValue: 0xefdd},
      {gLabel: 'do_not_disturb_alt', gValue: 0xefd9},
      {gLabel: 'do_not_disturb_off', gValue: 0xefda},
      {gLabel: 'do_not_disturb_on', gValue: 0xefdb},
      {gLabel: 'do_not_disturb_on_total_silence', gValue: 0xefdc},
      {gLabel: 'do_not_step', gValue: 0xefde},
      {gLabel: 'do_not_touch', gValue: 0xefdf},
      {gLabel: 'dock', gValue: 0xefe0},
      {gLabel: 'document_scanner', gValue: 0xefe1},
      {gLabel: 'domain', gValue: 0xefe3},
      {gLabel: 'domain_add', gValue: 0xf05ec},
      {gLabel: 'domain_disabled', gValue: 0xefe2},
      {gLabel: 'domain_verification', gValue: 0xefe4},
      {gLabel: 'done', gValue: 0xefe7},
      {gLabel: 'done_all', gValue: 0xefe5},
      {gLabel: 'done_outline', gValue: 0xefe6},
      {gLabel: 'donut_large', gValue: 0xefe8},
      {gLabel: 'donut_small', gValue: 0xefe9},
      {gLabel: 'door_back_door', gValue: 0xefea},
      {gLabel: 'door_front_door', gValue: 0xefeb},
      {gLabel: 'door_sliding', gValue: 0xefec},
      {gLabel: 'doorbell', gValue: 0xefed},
      {gLabel: 'double_arrow', gValue: 0xefee},
      {gLabel: 'downhill_skiing', gValue: 0xefef},
      {gLabel: 'download', gValue: 0xeff2},
      {gLabel: 'download_done', gValue: 0xeff0},
      {gLabel: 'download_for_offline', gValue: 0xeff1},
      {gLabel: 'downloading', gValue: 0xeff3},
      {gLabel: 'drafts', gValue: 0xeff4},
      {gLabel: 'drag_handle', gValue: 0xeff5},
      {gLabel: 'drag_indicator', gValue: 0xeff6},
      {gLabel: 'draw', gValue: 0xf05ed},
      {gLabel: 'drive_eta', gValue: 0xeff7},
      {gLabel: 'drive_file_move', gValue: 0xeff8},
      {gLabel: 'drive_file_move_rtl', gValue: 0xf05ee},
      {gLabel: 'drive_file_rename_outline', gValue: 0xeff9},
      {gLabel: 'drive_folder_upload', gValue: 0xeffa},
      {gLabel: 'dry', gValue: 0xeffc},
      {gLabel: 'dry_cleaning', gValue: 0xeffb},
      {gLabel: 'duo', gValue: 0xeffd},
      {gLabel: 'dvr', gValue: 0xeffe},
      {gLabel: 'dynamic_feed', gValue: 0xefff},
      {gLabel: 'dynamic_form', gValue: 0xf000},
      {gLabel: 'e_mobiledata', gValue: 0xf001},
      {gLabel: 'earbuds', gValue: 0xf003},
      {gLabel: 'earbuds_battery', gValue: 0xf002},
      {gLabel: 'east', gValue: 0xf004},
      {gLabel: 'eco', gValue: 0xf005},
      {gLabel: 'edgesensor_high', gValue: 0xf006},
      {gLabel: 'edgesensor_low', gValue: 0xf007},
      {gLabel: 'edit', gValue: 0xf00d},
      {gLabel: 'edit_attributes', gValue: 0xf008},
      {gLabel: 'edit_calendar', gValue: 0xf05ef},
      {gLabel: 'edit_location', gValue: 0xf00a},
      {gLabel: 'edit_location_alt', gValue: 0xf009},
      {gLabel: 'edit_note', gValue: 0xf05f0},
      {gLabel: 'edit_notifications', gValue: 0xf00b},
      {gLabel: 'edit_off', gValue: 0xf00c},
      {gLabel: 'edit_road', gValue: 0xf00e},
      {gLabel: 'egg', gValue: 0xf05f2},
      {gLabel: 'egg_alt', gValue: 0xf05f1},
      {gLabel: 'eject', gValue: 0xf00f},
      {gLabel: 'elderly', gValue: 0xf010},
      {gLabel: 'elderly_woman', gValue: 0xf05f3},
      {gLabel: 'electric_bike', gValue: 0xf011},
      {gLabel: 'electric_bolt', gValue: 0xf06ec},
      {gLabel: 'electric_car', gValue: 0xf012},
      {gLabel: 'electric_meter', gValue: 0xf06ed},
      {gLabel: 'electric_moped', gValue: 0xf013},
      {gLabel: 'electric_rickshaw', gValue: 0xf014},
      {gLabel: 'electric_scooter', gValue: 0xf015},
      {gLabel: 'electrical_services', gValue: 0xf016},
      {gLabel: 'elevator', gValue: 0xf017},
      {gLabel: 'email', gValue: 0xf018},
      {gLabel: 'emergency', gValue: 0xf05f4},
      {gLabel: 'emergency_recording', gValue: 0xf06ee},
      {gLabel: 'emergency_share', gValue: 0xf06ef},
      {gLabel: 'emoji_emotions', gValue: 0xf019},
      {gLabel: 'emoji_events', gValue: 0xf01a},
      {gLabel: 'emoji_flags', gValue: 0xf01b},
      {gLabel: 'emoji_food_beverage', gValue: 0xf01c},
      {gLabel: 'emoji_nature', gValue: 0xf01d},
      {gLabel: 'emoji_objects', gValue: 0xf01e},
      {gLabel: 'emoji_people', gValue: 0xf01f},
      {gLabel: 'emoji_symbols', gValue: 0xf020},
      {gLabel: 'emoji_transportation', gValue: 0xf021},
      {gLabel: 'energy_savings_leaf', gValue: 0xf06f0},
      {gLabel: 'engineering', gValue: 0xf022},
      {gLabel: 'enhance_photo_translate', gValue: 0xef1f},
      {gLabel: 'enhanced_encryption', gValue: 0xf023},
      {gLabel: 'equalizer', gValue: 0xf024},
      {gLabel: 'error', gValue: 0xf026},
      {gLabel: 'error_outline', gValue: 0xf025},
      {gLabel: 'escalator', gValue: 0xf027},
      {gLabel: 'escalator_warning', gValue: 0xf028},
      {gLabel: 'euro', gValue: 0xf029},
      {gLabel: 'euro_symbol', gValue: 0xf02a},
      {gLabel: 'ev_station', gValue: 0xf02b},
      {gLabel: 'event', gValue: 0xf02f},
      {gLabel: 'event_available', gValue: 0xf02c},
      {gLabel: 'event_busy', gValue: 0xf02d},
      {gLabel: 'event_note', gValue: 0xf02e},
      {gLabel: 'event_repeat', gValue: 0xf05f5},
      {gLabel: 'event_seat', gValue: 0xf030},
      {gLabel: 'exit_to_app', gValue: 0xf031},
      {gLabel: 'expand', gValue: 0xf034},
      {gLabel: 'expand_circle_down', gValue: 0xf05f6},
      {gLabel: 'expand_less', gValue: 0xf032},
      {gLabel: 'expand_more', gValue: 0xf033},
      {gLabel: 'explicit', gValue: 0xf035},
      {gLabel: 'explore', gValue: 0xf037},
      {gLabel: 'explore_off', gValue: 0xf036},
      {gLabel: 'exposure', gValue: 0xf03a},
      {gLabel: 'exposure_minus_1', gValue: 0xf038},
      {gLabel: 'exposure_minus_2', gValue: 0xf039},
      {gLabel: 'exposure_neg_1', gValue: 0xf038},
      {gLabel: 'exposure_neg_2', gValue: 0xf039},
      {gLabel: 'exposure_plus_1', gValue: 0xf03b},
      {gLabel: 'exposure_plus_2', gValue: 0xf03c},
      {gLabel: 'exposure_zero', gValue: 0xf03d},
      {gLabel: 'extension', gValue: 0xf03f},
      {gLabel: 'extension_off', gValue: 0xf03e},
      {gLabel: 'face', gValue: 0xf040},
      {gLabel: 'face_2', gValue: 0xf08a2},
      {gLabel: 'face_3', gValue: 0xf08a3},
      {gLabel: 'face_4', gValue: 0xf08a4},
      {gLabel: 'face_5', gValue: 0xf08a5},
      {gLabel: 'face_6', gValue: 0xf08a6},
      {gLabel: 'face_retouching_natural', gValue: 0xf041},
      {gLabel: 'face_retouching_off', gValue: 0xf042},
      {gLabel: 'face_unlock', gValue: 0xf043},
      {gLabel: 'facebook', gValue: 0xf044},
      {gLabel: 'fact_check', gValue: 0xf045},
      {gLabel: 'factory', gValue: 0xf05f7},
      {gLabel: 'family_restroom', gValue: 0xf046},
      {gLabel: 'fast_forward', gValue: 0xf047},
      {gLabel: 'fast_rewind', gValue: 0xf048},
      {gLabel: 'fastfood', gValue: 0xf049},
      {gLabel: 'favorite', gValue: 0xf04b},
      {gLabel: 'favorite_border', gValue: 0xf04a},
      {gLabel: 'favorite_outline', gValue: 0xf04a},
      {gLabel: 'fax', gValue: 0xf05f8},
      {gLabel: 'featured_play_list', gValue: 0xf04c},
      {gLabel: 'featured_video', gValue: 0xf04d},
      {gLabel: 'feed', gValue: 0xf04e},
      {gLabel: 'feedback', gValue: 0xf04f},
      {gLabel: 'female', gValue: 0xf050},
      {gLabel: 'fence', gValue: 0xf051},
      {gLabel: 'festival', gValue: 0xf052},
      {gLabel: 'fiber_dvr', gValue: 0xf053},
      {gLabel: 'fiber_manual_record', gValue: 0xf054},
      {gLabel: 'fiber_new', gValue: 0xf055},
      {gLabel: 'fiber_pin', gValue: 0xf056},
      {gLabel: 'fiber_smart_record', gValue: 0xf057},
      {gLabel: 'file_copy', gValue: 0xf058},
      {gLabel: 'file_download', gValue: 0xf05b},
      {gLabel: 'file_download_done', gValue: 0xf059},
      {gLabel: 'file_download_off', gValue: 0xf05a},
      {gLabel: 'file_open', gValue: 0xf05f9},
      {gLabel: 'file_present', gValue: 0xf05c},
      {gLabel: 'file_upload', gValue: 0xf05d},
      {gLabel: 'filter', gValue: 0xf070},
      {gLabel: 'filter_1', gValue: 0xf05e},
      {gLabel: 'filter_2', gValue: 0xf05f},
      {gLabel: 'filter_3', gValue: 0xf060},
      {gLabel: 'filter_4', gValue: 0xf061},
      {gLabel: 'filter_5', gValue: 0xf062},
      {gLabel: 'filter_6', gValue: 0xf063},
      {gLabel: 'filter_7', gValue: 0xf064},
      {gLabel: 'filter_8', gValue: 0xf065},
      {gLabel: 'filter_9', gValue: 0xf066},
      {gLabel: 'filter_9_plus', gValue: 0xf067},
      {gLabel: 'filter_alt', gValue: 0xf068},
      {gLabel: 'filter_alt_off', gValue: 0xf05fa},
      {gLabel: 'filter_b_and_w', gValue: 0xf069},
      {gLabel: 'filter_center_focus', gValue: 0xf06a},
      {gLabel: 'filter_drama', gValue: 0xf06b},
      {gLabel: 'filter_frames', gValue: 0xf06c},
      {gLabel: 'filter_hdr', gValue: 0xf06d},
      {gLabel: 'filter_list', gValue: 0xf06e},
      {gLabel: 'filter_list_off', gValue: 0xf05fb},
      {gLabel: 'filter_none', gValue: 0xf06f},
      {gLabel: 'filter_tilt_shift', gValue: 0xf071},
      {gLabel: 'filter_vintage', gValue: 0xf072},
      {gLabel: 'find_in_page', gValue: 0xf073},
      {gLabel: 'find_replace', gValue: 0xf074},
      {gLabel: 'fingerprint', gValue: 0xf075},
      {gLabel: 'fire_extinguisher', gValue: 0xf076},
      {gLabel: 'fire_hydrant_alt', gValue: 0xf06f1},
      {gLabel: 'fire_truck', gValue: 0xf06f2},
      {gLabel: 'fireplace', gValue: 0xf077},
      {gLabel: 'first_page', gValue: 0xf078},
      {gLabel: 'fit_screen', gValue: 0xf079},
      {gLabel: 'fitbit', gValue: 0xf05fc},
      {gLabel: 'fitness_center', gValue: 0xf07a},
      {gLabel: 'flag', gValue: 0xf07b},
      {gLabel: 'flag_circle', gValue: 0xf05fd},
      {gLabel: 'flaky', gValue: 0xf07c},
      {gLabel: 'flare', gValue: 0xf07d},
      {gLabel: 'flash_auto', gValue: 0xf07e},
      {gLabel: 'flash_off', gValue: 0xf07f},
      {gLabel: 'flash_on', gValue: 0xf080},
      {gLabel: 'flashlight_off', gValue: 0xf081},
      {gLabel: 'flashlight_on', gValue: 0xf082},
      {gLabel: 'flatware', gValue: 0xf083},
      {gLabel: 'flight', gValue: 0xf085},
      {gLabel: 'flight_class', gValue: 0xf05fe},
      {gLabel: 'flight_land', gValue: 0xf084},
      {gLabel: 'flight_takeoff', gValue: 0xf086},
      {gLabel: 'flip', gValue: 0xf089},
      {gLabel: 'flip_camera_android', gValue: 0xf087},
      {gLabel: 'flip_camera_ios', gValue: 0xf088},
      {gLabel: 'flip_to_back', gValue: 0xf08a},
      {gLabel: 'flip_to_front', gValue: 0xf08b},
      {gLabel: 'flood', gValue: 0xf06f3},
      {gLabel: 'flourescent', gValue: 0xf08a7},
      {gLabel: 'fluorescent', gValue: 0xf08a7},
      {gLabel: 'flutter_dash', gValue: 0xf08d},
      {gLabel: 'fmd_bad', gValue: 0xf08e},
      {gLabel: 'fmd_good', gValue: 0xf08f},
      {gLabel: 'folder', gValue: 0xf091},
      {gLabel: 'folder_copy', gValue: 0xf05ff},
      {gLabel: 'folder_delete', gValue: 0xf0600},
      {gLabel: 'folder_off', gValue: 0xf0601},
      {gLabel: 'folder_open', gValue: 0xf090},
      {gLabel: 'folder_shared', gValue: 0xf092},
      {gLabel: 'folder_special', gValue: 0xf093},
      {gLabel: 'folder_zip', gValue: 0xf0602},
      {gLabel: 'follow_the_signs', gValue: 0xf094},
      {gLabel: 'font_download', gValue: 0xf096},
      {gLabel: 'font_download_off', gValue: 0xf095},
      {gLabel: 'food_bank', gValue: 0xf097},
      {gLabel: 'forest', gValue: 0xf0603},
      {gLabel: 'fork_left', gValue: 0xf0604},
      {gLabel: 'fork_right', gValue: 0xf0605},
      {gLabel: 'format_align_center', gValue: 0xf098},
      {gLabel: 'format_align_justify', gValue: 0xf099},
      {gLabel: 'format_align_left', gValue: 0xf09a},
      {gLabel: 'format_align_right', gValue: 0xf09b},
      {gLabel: 'format_bold', gValue: 0xf09c},
      {gLabel: 'format_clear', gValue: 0xf09d},
      {gLabel: 'format_color_fill', gValue: 0xf09e},
      {gLabel: 'format_color_reset', gValue: 0xf09f},
      {gLabel: 'format_color_text', gValue: 0xf0a0},
      {gLabel: 'format_indent_decrease', gValue: 0xf0a1},
      {gLabel: 'format_indent_increase', gValue: 0xf0a2},
      {gLabel: 'format_italic', gValue: 0xf0a3},
      {gLabel: 'format_line_spacing', gValue: 0xf0a4},
      {gLabel: 'format_list_bulleted', gValue: 0xf0a5},
      {gLabel: 'format_list_numbered', gValue: 0xf0a6},
      {gLabel: 'format_list_numbered_rtl', gValue: 0xf0a7},
      {gLabel: 'format_overline', gValue: 0xf0606},
      {gLabel: 'format_paint', gValue: 0xf0a8},
      {gLabel: 'format_quote', gValue: 0xf0a9},
      {gLabel: 'format_shapes', gValue: 0xf0aa},
      {gLabel: 'format_size', gValue: 0xf0ab},
      {gLabel: 'format_strikethrough', gValue: 0xf0ac},
      {gLabel: 'format_textdirection_l_to_r', gValue: 0xf0ad},
      {gLabel: 'format_textdirection_r_to_l', gValue: 0xf0ae},
      {gLabel: 'format_underline', gValue: 0xf0af},
      {gLabel: 'format_underlined', gValue: 0xf0af},
      {gLabel: 'fort', gValue: 0xf0607},
      {gLabel: 'forum', gValue: 0xf0b0},
      {gLabel: 'forward', gValue: 0xf0b4},
      {gLabel: 'forward_10', gValue: 0xf0b1},
      {gLabel: 'forward_30', gValue: 0xf0b2},
      {gLabel: 'forward_5', gValue: 0xf0b3},
      {gLabel: 'forward_to_inbox', gValue: 0xf0b5},
      {gLabel: 'foundation', gValue: 0xf0b6},
      {gLabel: 'free_breakfast', gValue: 0xf0b7},
      {gLabel: 'free_cancellation', gValue: 0xf0608},
      {gLabel: 'front_hand', gValue: 0xf0609},
      {gLabel: 'fullscreen', gValue: 0xf0b9},
      {gLabel: 'fullscreen_exit', gValue: 0xf0b8},
      {gLabel: 'functions', gValue: 0xf0ba},
      {gLabel: 'g_mobiledata', gValue: 0xf0bb},
      {gLabel: 'g_translate', gValue: 0xf0bc},
      {gLabel: 'gamepad', gValue: 0xf0bd},
      {gLabel: 'games', gValue: 0xf0be},
      {gLabel: 'garage', gValue: 0xf0bf},
      {gLabel: 'gas_meter', gValue: 0xf06f4},
      {gLabel: 'gavel', gValue: 0xf0c0},
      {gLabel: 'generating_tokens', gValue: 0xf060a},
      {gLabel: 'gesture', gValue: 0xf0c1},
      {gLabel: 'get_app', gValue: 0xf0c2},
      {gLabel: 'gif', gValue: 0xf0c3},
      {gLabel: 'gif_box', gValue: 0xf060b},
      {gLabel: 'girl', gValue: 0xf060c},
      {gLabel: 'gite', gValue: 0xf0c4},
      {gLabel: 'golf_course', gValue: 0xf0c5},
      {gLabel: 'gpp_bad', gValue: 0xf0c6},
      {gLabel: 'gpp_good', gValue: 0xf0c7},
      {gLabel: 'gpp_maybe', gValue: 0xf0c8},
      {gLabel: 'gps_fixed', gValue: 0xf0c9},
      {gLabel: 'gps_not_fixed', gValue: 0xf0ca},
      {gLabel: 'gps_off', gValue: 0xf0cb},
      {gLabel: 'grade', gValue: 0xf0cc},
      {gLabel: 'gradient', gValue: 0xf0cd},
      {gLabel: 'grading', gValue: 0xf0ce},
      {gLabel: 'grain', gValue: 0xf0cf},
      {gLabel: 'graphic_eq', gValue: 0xf0d0},
      {gLabel: 'grass', gValue: 0xf0d1},
      {gLabel: 'grid_3x3', gValue: 0xf0d2},
      {gLabel: 'grid_4x4', gValue: 0xf0d3},
      {gLabel: 'grid_goldenratio', gValue: 0xf0d4},
      {gLabel: 'grid_off', gValue: 0xf0d5},
      {gLabel: 'grid_on', gValue: 0xf0d6},
      {gLabel: 'grid_view', gValue: 0xf0d7},
      {gLabel: 'group', gValue: 0xf0d9},
      {gLabel: 'group_add', gValue: 0xf0d8},
      {gLabel: 'group_off', gValue: 0xf060d},
      {gLabel: 'group_remove', gValue: 0xf060e},
      {gLabel: 'group_work', gValue: 0xf0da},
      {gLabel: 'groups', gValue: 0xf0db},
      {gLabel: 'groups_2', gValue: 0xf08a8},
      {gLabel: 'groups_3', gValue: 0xf08a9},
      {gLabel: 'h_mobiledata', gValue: 0xf0dc},
      {gLabel: 'h_plus_mobiledata', gValue: 0xf0dd},
      {gLabel: 'hail', gValue: 0xf0de},
      {gLabel: 'handshake', gValue: 0xf06a4},
      {gLabel: 'handyman', gValue: 0xf0df},
      {gLabel: 'hardware', gValue: 0xf0e0},
      {gLabel: 'hd', gValue: 0xf0e1},
      {gLabel: 'hdr_auto', gValue: 0xf0e2},
      {gLabel: 'hdr_auto_select', gValue: 0xf0e3},
      {gLabel: 'hdr_enhanced_select', gValue: 0xf0e4},
      {gLabel: 'hdr_off', gValue: 0xf0e5},
      {gLabel: 'hdr_off_select', gValue: 0xf0e6},
      {gLabel: 'hdr_on', gValue: 0xf0e7},
      {gLabel: 'hdr_on_select', gValue: 0xf0e8},
      {gLabel: 'hdr_plus', gValue: 0xf0e9},
      {gLabel: 'hdr_strong', gValue: 0xf0ea},
      {gLabel: 'hdr_weak', gValue: 0xf0eb},
      {gLabel: 'headphones', gValue: 0xf0ed},
      {gLabel: 'headphones_battery', gValue: 0xf0ec},
      {gLabel: 'headset', gValue: 0xf0f0},
      {gLabel: 'headset_mic', gValue: 0xf0ee},
      {gLabel: 'headset_off', gValue: 0xf0ef},
      {gLabel: 'healing', gValue: 0xf0f1},
      {gLabel: 'health_and_safety', gValue: 0xf0f2},
      {gLabel: 'hearing', gValue: 0xf0f4},
      {gLabel: 'hearing_disabled', gValue: 0xf0f3},
      {gLabel: 'heart_broken', gValue: 0xf060f},
      {gLabel: 'heat_pump', gValue: 0xf06f5},
      {gLabel: 'height', gValue: 0xf0f5},
      {gLabel: 'help', gValue: 0xf0f8},
      {gLabel: 'help_center', gValue: 0xf0f6},
      {gLabel: 'help_outline', gValue: 0xf0f7},
      {gLabel: 'hevc', gValue: 0xf0f9},
      {gLabel: 'hexagon', gValue: 0xf0610},
      {gLabel: 'hide_image', gValue: 0xf0fa},
      {gLabel: 'hide_source', gValue: 0xf0fb},
      {gLabel: 'high_quality', gValue: 0xf0fc},
      {gLabel: 'highlight', gValue: 0xf0ff},
      {gLabel: 'highlight_alt', gValue: 0xf0fd},
      {gLabel: 'highlight_off', gValue: 0xf0fe},
      {gLabel: 'highlight_remove', gValue: 0xf0fe},
      {gLabel: 'hiking', gValue: 0xf100},
      {gLabel: 'history', gValue: 0xf102},
      {gLabel: 'history_edu', gValue: 0xf101},
      {gLabel: 'history_toggle_off', gValue: 0xf103},
      {gLabel: 'hive', gValue: 0xf0611},
      {gLabel: 'hls', gValue: 0xf0613},
      {gLabel: 'hls_off', gValue: 0xf0612},
      {gLabel: 'holiday_village', gValue: 0xf104},
      {gLabel: 'home', gValue: 0xf107},
      {gLabel: 'home_max', gValue: 0xf105},
      {gLabel: 'home_mini', gValue: 0xf106},
      {gLabel: 'home_repair_service', gValue: 0xf108},
      {gLabel: 'home_work', gValue: 0xf109},
      {gLabel: 'horizontal_distribute', gValue: 0xf10a},
      {gLabel: 'horizontal_rule', gValue: 0xf10b},
      {gLabel: 'horizontal_split', gValue: 0xf10c},
      {gLabel: 'hot_tub', gValue: 0xf10d},
      {gLabel: 'hotel', gValue: 0xf10e},
      {gLabel: 'hotel_class', gValue: 0xf0614},
      {gLabel: 'hourglass_bottom', gValue: 0xf10f},
      {gLabel: 'hourglass_disabled', gValue: 0xf110},
      {gLabel: 'hourglass_empty', gValue: 0xf111},
      {gLabel: 'hourglass_full', gValue: 0xf112},
      {gLabel: 'hourglass_top', gValue: 0xf113},
      {gLabel: 'house', gValue: 0xf114},
      {gLabel: 'house_siding', gValue: 0xf115},
      {gLabel: 'houseboat', gValue: 0xf116},
      {gLabel: 'how_to_reg', gValue: 0xf117},
      {gLabel: 'how_to_vote', gValue: 0xf118},
      {gLabel: 'html', gValue: 0xf0615},
      {gLabel: 'http', gValue: 0xf119},
      {gLabel: 'https', gValue: 0xf11a},
      {gLabel: 'hub', gValue: 0xf0616},
      {gLabel: 'hvac', gValue: 0xf11b},
      {gLabel: 'ice_skating', gValue: 0xf11c},
      {gLabel: 'icecream', gValue: 0xf11d},
      {gLabel: 'image', gValue: 0xf120},
      {gLabel: 'image_aspect_ratio', gValue: 0xf11e},
      {gLabel: 'image_not_supported', gValue: 0xf11f},
      {gLabel: 'image_search', gValue: 0xf121},
      {gLabel: 'imagesearch_roller', gValue: 0xf122},
      {gLabel: 'import_contacts', gValue: 0xf123},
      {gLabel: 'import_export', gValue: 0xf124},
      {gLabel: 'important_devices', gValue: 0xf125},
      {gLabel: 'inbox', gValue: 0xf126},
      {gLabel: 'incomplete_circle', gValue: 0xf0617},
      {gLabel: 'indeterminate_check_box', gValue: 0xf127},
      {gLabel: 'info', gValue: 0xf128},
      {gLabel: 'input', gValue: 0xf129},
      {gLabel: 'insert_chart', gValue: 0xf12a},
      {gLabel: 'insert_chart_outlined', gValue: 0xf12b},
      {gLabel: 'insert_comment', gValue: 0xf12c},
      {gLabel: 'insert_drive_file', gValue: 0xf12d},
      {gLabel: 'insert_emoticon', gValue: 0xf12e},
      {gLabel: 'insert_invitation', gValue: 0xf12f},
      {gLabel: 'insert_link', gValue: 0xf130},
      {gLabel: 'insert_page_break', gValue: 0xf0618},
      {gLabel: 'insert_photo', gValue: 0xf131},
      {gLabel: 'insights', gValue: 0xf132},
      {gLabel: 'install_desktop', gValue: 0xf0619},
      {gLabel: 'install_mobile', gValue: 0xf061a},
      {gLabel: 'integration_instructions', gValue: 0xf133},
      {gLabel: 'interests', gValue: 0xf061b},
      {gLabel: 'interpreter_mode', gValue: 0xf061c},
      {gLabel: 'inventory', gValue: 0xf135},
      {gLabel: 'inventory_2', gValue: 0xf134},
      {gLabel: 'invert_colors', gValue: 0xf137},
      {gLabel: 'invert_colors_off', gValue: 0xf136},
      {gLabel: 'invert_colors_on', gValue: 0xf137},
      {gLabel: 'ios_share', gValue: 0xf138},
      {gLabel: 'iron', gValue: 0xf139},
      {gLabel: 'iso', gValue: 0xf13a},
      {gLabel: 'javascript', gValue: 0xf061d},
      {gLabel: 'join_full', gValue: 0xf061e},
      {gLabel: 'join_inner', gValue: 0xf061f},
      {gLabel: 'join_left', gValue: 0xf0620},
      {gLabel: 'join_right', gValue: 0xf0621},
      {gLabel: 'kayaking', gValue: 0xf13b},
      {gLabel: 'kebab_dining', gValue: 0xf0622},
      {gLabel: 'key', gValue: 0xf0624},
      {gLabel: 'key_off', gValue: 0xf0623},
      {gLabel: 'keyboard', gValue: 0xf144},
      {gLabel: 'keyboard_alt', gValue: 0xf13c},
      {gLabel: 'keyboard_arrow_down', gValue: 0xf13d},
      {gLabel: 'keyboard_arrow_left', gValue: 0xf13e},
      {gLabel: 'keyboard_arrow_right', gValue: 0xf13f},
      {gLabel: 'keyboard_arrow_up', gValue: 0xf140},
      {gLabel: 'keyboard_backspace', gValue: 0xf141},
      {gLabel: 'keyboard_capslock', gValue: 0xf142},
      {gLabel: 'keyboard_command_key', gValue: 0xf0625},
      {gLabel: 'keyboard_control', gValue: 0xf1e7},
      {gLabel: 'keyboard_control_key', gValue: 0xf0626},
      {gLabel: 'keyboard_double_arrow_down', gValue: 0xf0627},
      {gLabel: 'keyboard_double_arrow_left', gValue: 0xf0628},
      {gLabel: 'keyboard_double_arrow_right', gValue: 0xf0629},
      {gLabel: 'keyboard_double_arrow_up', gValue: 0xf062a},
      {gLabel: 'keyboard_hide', gValue: 0xf143},
      {gLabel: 'keyboard_option_key', gValue: 0xf062b},
      {gLabel: 'keyboard_return', gValue: 0xf145},
      {gLabel: 'keyboard_tab', gValue: 0xf146},
      {gLabel: 'keyboard_voice', gValue: 0xf147},
      {gLabel: 'king_bed', gValue: 0xf148},
      {gLabel: 'kitchen', gValue: 0xf149},
      {gLabel: 'kitesurfing', gValue: 0xf14a},
      {gLabel: 'label', gValue: 0xf14d},
      {gLabel: 'label_important', gValue: 0xf14b},
      {gLabel: 'label_off', gValue: 0xf14c},
      {gLabel: 'lan', gValue: 0xf062c},
      {gLabel: 'landscape', gValue: 0xf14e},
      {gLabel: 'landslide', gValue: 0xf06f6},
      {gLabel: 'language', gValue: 0xf14f},
      {gLabel: 'laptop', gValue: 0xf152},
      {gLabel: 'laptop_chromebook', gValue: 0xf150},
      {gLabel: 'laptop_mac', gValue: 0xf151},
      {gLabel: 'laptop_windows', gValue: 0xf153},
      {gLabel: 'last_page', gValue: 0xf154},
      {gLabel: 'launch', gValue: 0xf155},
      {gLabel: 'layers', gValue: 0xf157},
      {gLabel: 'layers_clear', gValue: 0xf156},
      {gLabel: 'leaderboard', gValue: 0xf158},
      {gLabel: 'leak_add', gValue: 0xf159},
      {gLabel: 'leak_remove', gValue: 0xf15a},
      {gLabel: 'leave_bags_at_home', gValue: 0xf21f},
      {gLabel: 'legend_toggle', gValue: 0xf15b},
      {gLabel: 'lens', gValue: 0xf15d},
      {gLabel: 'lens_blur', gValue: 0xf15c},
      {gLabel: 'library_add', gValue: 0xf15f},
      {gLabel: 'library_add_check', gValue: 0xf15e},
      {gLabel: 'library_books', gValue: 0xf160},
      {gLabel: 'library_music', gValue: 0xf161},
      {gLabel: 'light', gValue: 0xf163},
      {gLabel: 'light_mode', gValue: 0xf162},
      {gLabel: 'lightbulb', gValue: 0xf164},
      {gLabel: 'lightbulb_circle', gValue: 0xf06f7},
      {gLabel: 'line_axis', gValue: 0xf062d},
      {gLabel: 'line_style', gValue: 0xf165},
      {gLabel: 'line_weight', gValue: 0xf166},
      {gLabel: 'linear_scale', gValue: 0xf167},
      {gLabel: 'link', gValue: 0xf169},
      {gLabel: 'link_off', gValue: 0xf168},
      {gLabel: 'linked_camera', gValue: 0xf16a},
      {gLabel: 'liquor', gValue: 0xf16b},
      {gLabel: 'list', gValue: 0xf16d},
      {gLabel: 'list_alt', gValue: 0xf16c},
      {gLabel: 'live_help', gValue: 0xf16e},
      {gLabel: 'live_tv', gValue: 0xf16f},
      {gLabel: 'living', gValue: 0xf170},
      {gLabel: 'local_activity', gValue: 0xf171},
      {gLabel: 'local_airport', gValue: 0xf172},
      {gLabel: 'local_atm', gValue: 0xf173},
      {gLabel: 'local_attraction', gValue: 0xf171},
      {gLabel: 'local_bar', gValue: 0xf174},
      {gLabel: 'local_cafe', gValue: 0xf175},
      {gLabel: 'local_car_wash', gValue: 0xf176},
      {gLabel: 'local_convenience_store', gValue: 0xf177},
      {gLabel: 'local_dining', gValue: 0xf178},
      {gLabel: 'local_drink', gValue: 0xf179},
      {gLabel: 'local_fire_department', gValue: 0xf17a},
      {gLabel: 'local_florist', gValue: 0xf17b},
      {gLabel: 'local_gas_station', gValue: 0xf17c},
      {gLabel: 'local_grocery_store', gValue: 0xf17d},
      {gLabel: 'local_hospital', gValue: 0xf17e},
      {gLabel: 'local_hotel', gValue: 0xf17f},
      {gLabel: 'local_laundry_service', gValue: 0xf180},
      {gLabel: 'local_library', gValue: 0xf181},
      {gLabel: 'local_mall', gValue: 0xf182},
      {gLabel: 'local_movies', gValue: 0xf183},
      {gLabel: 'local_offer', gValue: 0xf184},
      {gLabel: 'local_parking', gValue: 0xf185},
      {gLabel: 'local_pharmacy', gValue: 0xf186},
      {gLabel: 'local_phone', gValue: 0xf187},
      {gLabel: 'local_pizza', gValue: 0xf188},
      {gLabel: 'local_play', gValue: 0xf189},
      {gLabel: 'local_police', gValue: 0xf18a},
      {gLabel: 'local_post_office', gValue: 0xf18b},
      {gLabel: 'local_print_shop', gValue: 0xf18c},
      {gLabel: 'local_printshop', gValue: 0xf18c},
      {gLabel: 'local_restaurant', gValue: 0xf178},
      {gLabel: 'local_see', gValue: 0xf18d},
      {gLabel: 'local_shipping', gValue: 0xf18e},
      {gLabel: 'local_taxi', gValue: 0xf18f},
      {gLabel: 'location_city', gValue: 0xf190},
      {gLabel: 'location_disabled', gValue: 0xf191},
      {gLabel: 'location_history', gValue: 0xf27d},
      {gLabel: 'location_off', gValue: 0xf192},
      {gLabel: 'location_on', gValue: 0xf193},
      {gLabel: 'location_searching', gValue: 0xf194},
      {gLabel: 'lock', gValue: 0xf197},
      {gLabel: 'lock_clock', gValue: 0xf195},
      {gLabel: 'lock_open', gValue: 0xf196},
      {gLabel: 'lock_person', gValue: 0xf06f8},
      {gLabel: 'lock_reset', gValue: 0xf062e},
      {gLabel: 'login', gValue: 0xf198},
      {gLabel: 'logo_dev', gValue: 0xf062f},
      {gLabel: 'logout', gValue: 0xf199},
      {gLabel: 'looks', gValue: 0xf19f},
      {gLabel: 'looks_3', gValue: 0xf19a},
      {gLabel: 'looks_4', gValue: 0xf19b},
      {gLabel: 'looks_5', gValue: 0xf19c},
      {gLabel: 'looks_6', gValue: 0xf19d},
      {gLabel: 'looks_one', gValue: 0xf19e},
      {gLabel: 'looks_two', gValue: 0xf1a0},
      {gLabel: 'loop', gValue: 0xf1a1},
      {gLabel: 'loupe', gValue: 0xf1a2},
      {gLabel: 'low_priority', gValue: 0xf1a3},
      {gLabel: 'loyalty', gValue: 0xf1a4},
      {gLabel: 'lte_mobiledata', gValue: 0xf1a5},
      {gLabel: 'lte_plus_mobiledata', gValue: 0xf1a6},
      {gLabel: 'luggage', gValue: 0xf1a7},
      {gLabel: 'lunch_dining', gValue: 0xf1a8},
      {gLabel: 'lyrics', gValue: 0xf06f9},
      {gLabel: 'macro_off', gValue: 0xf08aa},
      {gLabel: 'mail', gValue: 0xf1aa},
      {gLabel: 'mail_lock', gValue: 0xf06fa},
      {gLabel: 'mail_outline', gValue: 0xf1a9},
      {gLabel: 'male', gValue: 0xf1ab},
      {gLabel: 'man', gValue: 0xf0630},
      {gLabel: 'man_2', gValue: 0xf08ab},
      {gLabel: 'man_3', gValue: 0xf08ac},
      {gLabel: 'man_4', gValue: 0xf08ad},
      {gLabel: 'manage_accounts', gValue: 0xf1ac},
      {gLabel: 'manage_history', gValue: 0xf06fb},
      {gLabel: 'manage_search', gValue: 0xf1ad},
      {gLabel: 'map', gValue: 0xf1ae},
      {gLabel: 'maps_home_work', gValue: 0xf1af},
      {gLabel: 'maps_ugc', gValue: 0xf1b0},
      {gLabel: 'margin', gValue: 0xf1b1},
      {gLabel: 'mark_as_unread', gValue: 0xf1b2},
      {gLabel: 'mark_chat_read', gValue: 0xf1b3},
      {gLabel: 'mark_chat_unread', gValue: 0xf1b4},
      {gLabel: 'mark_email_read', gValue: 0xf1b5},
      {gLabel: 'mark_email_unread', gValue: 0xf1b6},
      {gLabel: 'mark_unread_chat_alt', gValue: 0xf0631},
      {gLabel: 'markunread', gValue: 0xf1b8},
      {gLabel: 'markunread_mailbox', gValue: 0xf1b7},
      {gLabel: 'masks', gValue: 0xf1b9},
      {gLabel: 'maximize', gValue: 0xf1ba},
      {gLabel: 'media_bluetooth_off', gValue: 0xf1bb},
      {gLabel: 'media_bluetooth_on', gValue: 0xf1bc},
      {gLabel: 'mediation', gValue: 0xf1bd},
      {gLabel: 'medical_information', gValue: 0xf06fc},
      {gLabel: 'medical_services', gValue: 0xf1be},
      {gLabel: 'medication', gValue: 0xf1bf},
      {gLabel: 'medication_liquid', gValue: 0xf0632},
      {gLabel: 'meeting_room', gValue: 0xf1c0},
      {gLabel: 'memory', gValue: 0xf1c1},
      {gLabel: 'menu', gValue: 0xf1c4},
      {gLabel: 'menu_book', gValue: 0xf1c2},
      {gLabel: 'menu_open', gValue: 0xf1c3},
      {gLabel: 'merge', gValue: 0xf0633},
      {gLabel: 'merge_type', gValue: 0xf1c5},
      {gLabel: 'message', gValue: 0xf1c6},
      {gLabel: 'messenger', gValue: 0xef43},
      {gLabel: 'messenger_outline', gValue: 0xef42},
      {gLabel: 'mic', gValue: 0xf1cb},
      {gLabel: 'mic_external_off', gValue: 0xf1c7},
      {gLabel: 'mic_external_on', gValue: 0xf1c8},
      {gLabel: 'mic_none', gValue: 0xf1c9},
      {gLabel: 'mic_off', gValue: 0xf1ca},
      {gLabel: 'microwave', gValue: 0xf1cc},
      {gLabel: 'military_tech', gValue: 0xf1cd},
      {gLabel: 'minimize', gValue: 0xf1ce},
      {gLabel: 'minor_crash', gValue: 0xf06fd},
      {gLabel: 'miscellaneous_services', gValue: 0xf1cf},
      {gLabel: 'missed_video_call', gValue: 0xf1d0},
      {gLabel: 'mms', gValue: 0xf1d1},
      {gLabel: 'mobile_friendly', gValue: 0xf1d2},
      {gLabel: 'mobile_off', gValue: 0xf1d3},
      {gLabel: 'mobile_screen_share', gValue: 0xf1d4},
      {gLabel: 'mobiledata_off', gValue: 0xf1d5},
      {gLabel: 'mode', gValue: 0xf1da},
      {gLabel: 'mode_comment', gValue: 0xf1d6},
      {gLabel: 'mode_edit', gValue: 0xf1d8},
      {gLabel: 'mode_edit_outline', gValue: 0xf1d7},
      {gLabel: 'mode_fan_off', gValue: 0xf06fe},
      {gLabel: 'mode_night', gValue: 0xf1d9},
      {gLabel: 'mode_of_travel', gValue: 0xf0634},
      {gLabel: 'mode_standby', gValue: 0xf1db},
      {gLabel: 'model_training', gValue: 0xf1dc},
      {gLabel: 'monetization_on', gValue: 0xf1dd},
      {gLabel: 'money', gValue: 0xf1e0},
      {gLabel: 'money_off', gValue: 0xf1df},
      {gLabel: 'money_off_csred', gValue: 0xf1de},
      {gLabel: 'monitor', gValue: 0xf1e1},
      {gLabel: 'monitor_heart', gValue: 0xf0635},
      {gLabel: 'monitor_weight', gValue: 0xf1e2},
      {gLabel: 'monochrome_photos', gValue: 0xf1e3},
      {gLabel: 'mood', gValue: 0xf1e5},
      {gLabel: 'mood_bad', gValue: 0xf1e4},
      {gLabel: 'moped', gValue: 0xf1e6},
      {gLabel: 'more', gValue: 0xf1e8},
      {gLabel: 'more_horiz', gValue: 0xf1e7},
      {gLabel: 'more_time', gValue: 0xf1e9},
      {gLabel: 'more_vert', gValue: 0xf1ea},
      {gLabel: 'mosque', gValue: 0xf0636},
      {gLabel: 'motion_photos_auto', gValue: 0xf1eb},
      {gLabel: 'motion_photos_off', gValue: 0xf1ec},
      {gLabel: 'motion_photos_on', gValue: 0xf1ed},
      {gLabel: 'motion_photos_pause', gValue: 0xf1ee},
      {gLabel: 'motion_photos_paused', gValue: 0xf1ef},
      {gLabel: 'motorcycle', gValue: 0xf1f0},
      {gLabel: 'mouse', gValue: 0xf1f1},
      {gLabel: 'move_down', gValue: 0xf0637},
      {gLabel: 'move_to_inbox', gValue: 0xf1f2},
      {gLabel: 'move_up', gValue: 0xf0638},
      {gLabel: 'movie', gValue: 0xf1f5},
      {gLabel: 'movie_creation', gValue: 0xf1f3},
      {gLabel: 'movie_filter', gValue: 0xf1f4},
      {gLabel: 'moving', gValue: 0xf1f6},
      {gLabel: 'mp', gValue: 0xf1f7},
      {gLabel: 'multiline_chart', gValue: 0xf1f8},
      {gLabel: 'multiple_stop', gValue: 0xf1f9},
      {gLabel: 'multitrack_audio', gValue: 0xf0d0},
      {gLabel: 'museum', gValue: 0xf1fa},
      {gLabel: 'music_note', gValue: 0xf1fb},
      {gLabel: 'music_off', gValue: 0xf1fc},
      {gLabel: 'music_video', gValue: 0xf1fd},
      {gLabel: 'my_library_add', gValue: 0xf15f},
      {gLabel: 'my_library_books', gValue: 0xf160},
      {gLabel: 'my_library_music', gValue: 0xf161},
      {gLabel: 'my_location', gValue: 0xf1fe},
      {gLabel: 'nat', gValue: 0xf1ff},
      {gLabel: 'nature', gValue: 0xf200},
      {gLabel: 'nature_people', gValue: 0xf201},
      {gLabel: 'navigate_before', gValue: 0xf202},
      {gLabel: 'navigate_next', gValue: 0xf203},
      {gLabel: 'navigation', gValue: 0xf204},
      {gLabel: 'near_me', gValue: 0xf206},
      {gLabel: 'near_me_disabled', gValue: 0xf205},
      {gLabel: 'nearby_error', gValue: 0xf207},
      {gLabel: 'nearby_off', gValue: 0xf208},
      {gLabel: 'nest_cam_wired_stand', gValue: 0xf06ff},
      {gLabel: 'network_cell', gValue: 0xf209},
      {gLabel: 'network_check', gValue: 0xf20a},
      {gLabel: 'network_locked', gValue: 0xf20b},
      {gLabel: 'network_ping', gValue: 0xf06a5},
      {gLabel: 'network_wifi', gValue: 0xf20c},
      {gLabel: 'network_wifi_1_bar', gValue: 0xf0700},
      {gLabel: 'network_wifi_2_bar', gValue: 0xf0701},
      {gLabel: 'network_wifi_3_bar', gValue: 0xf0702},
      {gLabel: 'new_label', gValue: 0xf20d},
      {gLabel: 'new_releases', gValue: 0xf20e},
      {gLabel: 'newspaper', gValue: 0xf0639},
      {gLabel: 'next_plan', gValue: 0xf20f},
      {gLabel: 'next_week', gValue: 0xf210},
      {gLabel: 'nfc', gValue: 0xf211},
      {gLabel: 'night_shelter', gValue: 0xf212},
      {gLabel: 'nightlife', gValue: 0xf213},
      {gLabel: 'nightlight', gValue: 0xf214},
      {gLabel: 'nightlight_round', gValue: 0xf215},
      {gLabel: 'nights_stay', gValue: 0xf216},
      {gLabel: 'no_accounts', gValue: 0xf217},
      {gLabel: 'no_adult_content', gValue: 0xf0703},
      {gLabel: 'no_backpack', gValue: 0xf218},
      {gLabel: 'no_cell', gValue: 0xf219},
      {gLabel: 'no_crash', gValue: 0xf0704},
      {gLabel: 'no_drinks', gValue: 0xf21a},
      {gLabel: 'no_encryption', gValue: 0xf21c},
      {gLabel: 'no_encryption_gmailerrorred', gValue: 0xf21b},
      {gLabel: 'no_flash', gValue: 0xf21d},
      {gLabel: 'no_food', gValue: 0xf21e},
      {gLabel: 'no_luggage', gValue: 0xf21f},
      {gLabel: 'no_meals', gValue: 0xf220},
      {gLabel: 'no_meeting_room', gValue: 0xf221},
      {gLabel: 'no_photography', gValue: 0xf222},
      {gLabel: 'no_sim', gValue: 0xf223},
      {gLabel: 'no_stroller', gValue: 0xf224},
      {gLabel: 'no_transfer', gValue: 0xf225},
      {gLabel: 'noise_aware', gValue: 0xf0705},
      {gLabel: 'noise_control_off', gValue: 0xf0706},
      {gLabel: 'nordic_walking', gValue: 0xf226},
      {gLabel: 'north', gValue: 0xf228},
      {gLabel: 'north_east', gValue: 0xf227},
      {gLabel: 'north_west', gValue: 0xf229},
      {gLabel: 'not_accessible', gValue: 0xf22a},
      {gLabel: 'not_interested', gValue: 0xf22b},
      {gLabel: 'not_listed_location', gValue: 0xf22c},
      {gLabel: 'not_started', gValue: 0xf22d},
      {gLabel: 'note', gValue: 0xf230},
      {gLabel: 'note_add', gValue: 0xf22e},
      {gLabel: 'note_alt', gValue: 0xf22f},
      {gLabel: 'notes', gValue: 0xf231},
      {gLabel: 'notification_add', gValue: 0xf232},
      {gLabel: 'notification_important', gValue: 0xf233},
      {gLabel: 'notifications', gValue: 0xf237},
      {gLabel: 'notifications_active', gValue: 0xf234},
      {gLabel: 'notifications_none', gValue: 0xf235},
      {gLabel: 'notifications_off', gValue: 0xf236},
      {gLabel: 'notifications_on', gValue: 0xf234},
      {gLabel: 'notifications_paused', gValue: 0xf238},
      {gLabel: 'now_wallpaper', gValue: 0xf4ad},
      {gLabel: 'now_widgets', gValue: 0xf4c7},
      {gLabel: 'numbers', gValue: 0xf063a},
      {gLabel: 'offline_bolt', gValue: 0xf239},
      {gLabel: 'offline_pin', gValue: 0xf23a},
      {gLabel: 'offline_share', gValue: 0xf23b},
      {gLabel: 'oil_barrel', gValue: 0xf0707},
      {gLabel: 'on_device_training', gValue: 0xf0708},
      {gLabel: 'ondemand_video', gValue: 0xf23c},
      {gLabel: 'online_prediction', gValue: 0xf23d},
      {gLabel: 'opacity', gValue: 0xf23e},
      {gLabel: 'open_in_browser', gValue: 0xf23f},
      {gLabel: 'open_in_full', gValue: 0xf240},
      {gLabel: 'open_in_new', gValue: 0xf242},
      {gLabel: 'open_in_new_off', gValue: 0xf241},
      {gLabel: 'open_with', gValue: 0xf243},
      {gLabel: 'other_houses', gValue: 0xf244},
      {gLabel: 'outbond', gValue: 0xf245},
      {gLabel: 'outbound', gValue: 0xf246},
      {gLabel: 'outbox', gValue: 0xf247},
      {gLabel: 'outdoor_grill', gValue: 0xf248},
      {gLabel: 'outlet', gValue: 0xf249},
      {gLabel: 'outlined_flag', gValue: 0xf24a},
      {gLabel: 'output', gValue: 0xf063b},
      {gLabel: 'padding', gValue: 0xf24b},
      {gLabel: 'pages', gValue: 0xf24c},
      {gLabel: 'pageview', gValue: 0xf24d},
      {gLabel: 'paid', gValue: 0xf24e},
      {gLabel: 'palette', gValue: 0xf24f},
      {gLabel: 'pan_tool', gValue: 0xf250},
      {gLabel: 'pan_tool_alt', gValue: 0xf063c},
      {gLabel: 'panorama', gValue: 0xf254},
      {gLabel: 'panorama_fish_eye', gValue: 0xf251},
      {gLabel: 'panorama_fisheye', gValue: 0xf251},
      {gLabel: 'panorama_horizontal', gValue: 0xf252},
      {gLabel: 'panorama_horizontal_select', gValue: 0xf253},
      {gLabel: 'panorama_photosphere', gValue: 0xf255},
      {gLabel: 'panorama_photosphere_select', gValue: 0xf256},
      {gLabel: 'panorama_vertical', gValue: 0xf257},
      {gLabel: 'panorama_vertical_select', gValue: 0xf258},
      {gLabel: 'panorama_wide_angle', gValue: 0xf259},
      {gLabel: 'panorama_wide_angle_select', gValue: 0xf25a},
      {gLabel: 'paragliding', gValue: 0xf25b},
      {gLabel: 'park', gValue: 0xf25c},
      {gLabel: 'party_mode', gValue: 0xf25d},
      {gLabel: 'password', gValue: 0xf25e},
      {gLabel: 'paste', gValue: 0xef82},
      {gLabel: 'pattern', gValue: 0xf25f},
      {gLabel: 'pause', gValue: 0xf263},
      {gLabel: 'pause_circle', gValue: 0xf262},
      {gLabel: 'pause_circle_filled', gValue: 0xf260},
      {gLabel: 'pause_circle_outline', gValue: 0xf261},
      {gLabel: 'pause_presentation', gValue: 0xf264},
      {gLabel: 'payment', gValue: 0xf265},
      {gLabel: 'payments', gValue: 0xf266},
      {gLabel: 'paypal', gValue: 0xf063d},
      {gLabel: 'pedal_bike', gValue: 0xf267},
      {gLabel: 'pending', gValue: 0xf269},
      {gLabel: 'pending_actions', gValue: 0xf268},
      {gLabel: 'pentagon', gValue: 0xf063e},
      {gLabel: 'people', gValue: 0xf26c},
      {gLabel: 'people_alt', gValue: 0xf26a},
      {gLabel: 'people_outline', gValue: 0xf26b},
      {gLabel: 'percent', gValue: 0xf063f},
      {gLabel: 'perm_camera_mic', gValue: 0xf26d},
      {gLabel: 'perm_contact_cal', gValue: 0xf26e},
      {gLabel: 'perm_contact_calendar', gValue: 0xf26e},
      {gLabel: 'perm_data_setting', gValue: 0xf26f},
      {gLabel: 'perm_device_info', gValue: 0xf270},
      {gLabel: 'perm_device_information', gValue: 0xf270},
      {gLabel: 'perm_identity', gValue: 0xf271},
      {gLabel: 'perm_media', gValue: 0xf272},
      {gLabel: 'perm_phone_msg', gValue: 0xf273},
      {gLabel: 'perm_scan_wifi', gValue: 0xf274},
      {gLabel: 'person', gValue: 0xf27b},
      {gLabel: 'person_2', gValue: 0xf08ae},
      {gLabel: 'person_3', gValue: 0xf08af},
      {gLabel: 'person_4', gValue: 0xf08b0},
      {gLabel: 'person_add', gValue: 0xf278},
      {gLabel: 'person_add_alt', gValue: 0xf276},
      {gLabel: 'person_add_alt_1', gValue: 0xf275},
      {gLabel: 'person_add_disabled', gValue: 0xf277},
      {gLabel: 'person_off', gValue: 0xf279},
      {gLabel: 'person_outline', gValue: 0xf27a},
      {gLabel: 'person_pin', gValue: 0xf27d},
      {gLabel: 'person_pin_circle', gValue: 0xf27c},
      {gLabel: 'person_remove', gValue: 0xf27f},
      {gLabel: 'person_remove_alt_1', gValue: 0xf27e},
      {gLabel: 'person_search', gValue: 0xf280},
      {gLabel: 'personal_injury', gValue: 0xf281},
      {gLabel: 'personal_video', gValue: 0xf282},
      {gLabel: 'pest_control', gValue: 0xf283},
      {gLabel: 'pest_control_rodent', gValue: 0xf284},
      {gLabel: 'pets', gValue: 0xf285},
      {gLabel: 'phishing', gValue: 0xf0640},
      {gLabel: 'phone', gValue: 0xf290},
      {gLabel: 'phone_android', gValue: 0xf286},
      {gLabel: 'phone_bluetooth_speaker', gValue: 0xf287},
      {gLabel: 'phone_callback', gValue: 0xf288},
      {gLabel: 'phone_disabled', gValue: 0xf289},
      {gLabel: 'phone_enabled', gValue: 0xf28a},
      {gLabel: 'phone_forwarded', gValue: 0xf28b},
      {gLabel: 'phone_in_talk', gValue: 0xf28c},
      {gLabel: 'phone_iphone', gValue: 0xf28d},
      {gLabel: 'phone_locked', gValue: 0xf28e},
      {gLabel: 'phone_missed', gValue: 0xf28f},
      {gLabel: 'phone_paused', gValue: 0xf291},
      {gLabel: 'phonelink', gValue: 0xf295},
      {gLabel: 'phonelink_erase', gValue: 0xf292},
      {gLabel: 'phonelink_lock', gValue: 0xf293},
      {gLabel: 'phonelink_off', gValue: 0xf294},
      {gLabel: 'phonelink_ring', gValue: 0xf296},
      {gLabel: 'phonelink_setup', gValue: 0xf297},
      {gLabel: 'photo', gValue: 0xf29e},
      {gLabel: 'photo_album', gValue: 0xf298},
      {gLabel: 'photo_camera', gValue: 0xf29b},
      {gLabel: 'photo_camera_back', gValue: 0xf299},
      {gLabel: 'photo_camera_front', gValue: 0xf29a},
      {gLabel: 'photo_filter', gValue: 0xf29c},
      {gLabel: 'photo_library', gValue: 0xf29d},
      {gLabel: 'photo_size_select_actual', gValue: 0xf29f},
      {gLabel: 'photo_size_select_large', gValue: 0xf2a0},
      {gLabel: 'photo_size_select_small', gValue: 0xf2a1},
      {gLabel: 'php', gValue: 0xf0641},
      {gLabel: 'piano', gValue: 0xf2a3},
      {gLabel: 'piano_off', gValue: 0xf2a2},
      {gLabel: 'picture_as_pdf', gValue: 0xf2a4},
      {gLabel: 'picture_in_picture', gValue: 0xf2a6},
      {gLabel: 'picture_in_picture_alt', gValue: 0xf2a5},
      {gLabel: 'pie_chart_outline', gValue: 0xf2a7},
      {gLabel: 'pin', gValue: 0xf2aa},
      {gLabel: 'pin_drop', gValue: 0xf2a9},
      {gLabel: 'pin_end', gValue: 0xf0642},
      {gLabel: 'pin_invoke', gValue: 0xf0643},
      {gLabel: 'pinch', gValue: 0xf0644},
      {gLabel: 'pivot_table_chart', gValue: 0xf2ab},
      {gLabel: 'pix', gValue: 0xf0645},
      {gLabel: 'place', gValue: 0xf2ac},
      {gLabel: 'plagiarism', gValue: 0xf2ad},
      {gLabel: 'play_arrow', gValue: 0xf2ae},
      {gLabel: 'play_circle', gValue: 0xf2b1},
      {gLabel: 'play_circle_fill', gValue: 0xf2af},
      {gLabel: 'play_circle_filled', gValue: 0xf2af},
      {gLabel: 'play_circle_outline', gValue: 0xf2b0},
      {gLabel: 'play_disabled', gValue: 0xf2b2},
      {gLabel: 'play_for_work', gValue: 0xf2b3},
      {gLabel: 'play_lesson', gValue: 0xf2b4},
      {gLabel: 'playlist_add', gValue: 0xf2b6},
      {gLabel: 'playlist_add_check', gValue: 0xf2b5},
      {gLabel: 'playlist_add_check_circle', gValue: 0xf0646},
      {gLabel: 'playlist_add_circle', gValue: 0xf0647},
      {gLabel: 'playlist_play', gValue: 0xf2b7},
      {gLabel: 'playlist_remove', gValue: 0xf0648},
      {gLabel: 'plumbing', gValue: 0xf2b8},
      {gLabel: 'plus_one', gValue: 0xf2b9},
      {gLabel: 'podcasts', gValue: 0xf2ba},
      {gLabel: 'point_of_sale', gValue: 0xf2bb},
      {gLabel: 'policy', gValue: 0xf2bc},
      {gLabel: 'poll', gValue: 0xf2bd},
      {gLabel: 'polyline', gValue: 0xf0649},
      {gLabel: 'polymer', gValue: 0xf2be},
      {gLabel: 'pool', gValue: 0xf2bf},
      {gLabel: 'portable_wifi_off', gValue: 0xf2c0},
      {gLabel: 'portrait', gValue: 0xf2c1},
      {gLabel: 'post_add', gValue: 0xf2c2},
      {gLabel: 'power', gValue: 0xf2c5},
      {gLabel: 'power_input', gValue: 0xf2c3},
      {gLabel: 'power_off', gValue: 0xf2c4},
      {gLabel: 'power_settings_new', gValue: 0xf2c6},
      {gLabel: 'precision_manufacturing', gValue: 0xf2c7},
      {gLabel: 'pregnant_woman', gValue: 0xf2c8},
      {gLabel: 'present_to_all', gValue: 0xf2c9},
      {gLabel: 'preview', gValue: 0xf2ca},
      {gLabel: 'price_change', gValue: 0xf2cb},
      {gLabel: 'price_check', gValue: 0xf2cc},
      {gLabel: 'print', gValue: 0xf2ce},
      {gLabel: 'print_disabled', gValue: 0xf2cd},
      {gLabel: 'priority_high', gValue: 0xf2cf},
      {gLabel: 'privacy_tip', gValue: 0xf2d0},
      {gLabel: 'private_connectivity', gValue: 0xf064a},
      {gLabel: 'production_quantity_limits', gValue: 0xf2d1},
      {gLabel: 'propane', gValue: 0xf0709},
      {gLabel: 'propane_tank', gValue: 0xf070a},
      {gLabel: 'psychology', gValue: 0xf2d2},
      {gLabel: 'psychology_alt', gValue: 0xf08b1},
      {gLabel: 'public', gValue: 0xf2d4},
      {gLabel: 'public_off', gValue: 0xf2d3},
      {gLabel: 'publish', gValue: 0xf2d5},
      {gLabel: 'published_with_changes', gValue: 0xf2d6},
      {gLabel: 'punch_clock', gValue: 0xf064b},
      {gLabel: 'push_pin', gValue: 0xf2d7},
      {gLabel: 'qr_code', gValue: 0xf2d9},
      {gLabel: 'qr_code_2', gValue: 0xf2d8},
      {gLabel: 'qr_code_scanner', gValue: 0xf2da},
      {gLabel: 'query_builder', gValue: 0xf2db},
      {gLabel: 'query_stats', gValue: 0xf2dc},
      {gLabel: 'question_answer', gValue: 0xf2dd},
      {gLabel: 'question_mark', gValue: 0xf064c},
      {gLabel: 'queue', gValue: 0xf2df},
      {gLabel: 'queue_music', gValue: 0xf2de},
      {gLabel: 'queue_play_next', gValue: 0xf2e0},
      {gLabel: 'quick_contacts_dialer', gValue: 0xef7b},
      {gLabel: 'quick_contacts_mail', gValue: 0xef79},
      {gLabel: 'quickreply', gValue: 0xf2e1},
      {gLabel: 'quiz', gValue: 0xf2e2},
      {gLabel: 'quora', gValue: 0xf064d},
      {gLabel: 'r_mobiledata', gValue: 0xf2e3},
      {gLabel: 'radar', gValue: 0xf2e4},
      {gLabel: 'radio', gValue: 0xf2e7},
      {gLabel: 'radio_button_checked', gValue: 0xf2e5},
      {gLabel: 'radio_button_off', gValue: 0xf2e6},
      {gLabel: 'radio_button_on', gValue: 0xf2e5},
      {gLabel: 'radio_button_unchecked', gValue: 0xf2e6},
      {gLabel: 'railway_alert', gValue: 0xf2e8},
      {gLabel: 'ramen_dining', gValue: 0xf2e9},
      {gLabel: 'ramp_left', gValue: 0xf064e},
      {gLabel: 'ramp_right', gValue: 0xf064f},
      {gLabel: 'rate_review', gValue: 0xf2ea},
      {gLabel: 'raw_off', gValue: 0xf2eb},
      {gLabel: 'raw_on', gValue: 0xf2ec},
      {gLabel: 'read_more', gValue: 0xf2ed},
      {gLabel: 'real_estate_agent', gValue: 0xf2ee},
      {gLabel: 'receipt', gValue: 0xf2f0},
      {gLabel: 'receipt_long', gValue: 0xf2ef},
      {gLabel: 'recent_actors', gValue: 0xf2f1},
      {gLabel: 'recommend', gValue: 0xf2f2},
      {gLabel: 'record_voice_over', gValue: 0xf2f3},
      {gLabel: 'rectangle', gValue: 0xf0650},
      {gLabel: 'recycling', gValue: 0xf0651},
      {gLabel: 'reddit', gValue: 0xf0652},
      {gLabel: 'redeem', gValue: 0xf2f4},
      {gLabel: 'redo', gValue: 0xf2f5},
      {gLabel: 'reduce_capacity', gValue: 0xf2f6},
      {gLabel: 'refresh', gValue: 0xf2f7},
      {gLabel: 'remember_me', gValue: 0xf2f8},
      {gLabel: 'remove', gValue: 0xf2fe},
      {gLabel: 'remove_circle', gValue: 0xf2fa},
      {gLabel: 'remove_circle_outline', gValue: 0xf2f9},
      {gLabel: 'remove_done', gValue: 0xf2fb},
      {gLabel: 'remove_from_queue', gValue: 0xf2fc},
      {gLabel: 'remove_moderator', gValue: 0xf2fd},
      {gLabel: 'remove_red_eye', gValue: 0xf2ff},
      {gLabel: 'remove_road', gValue: 0xf070b},
      {gLabel: 'remove_shopping_cart', gValue: 0xf300},
      {gLabel: 'reorder', gValue: 0xf301},
      {gLabel: 'repartition', gValue: 0xf08b2},
      {gLabel: 'repeat', gValue: 0xf305},
      {gLabel: 'repeat_on', gValue: 0xf302},
      {gLabel: 'repeat_one', gValue: 0xf304},
      {gLabel: 'repeat_one_on', gValue: 0xf303},
      {gLabel: 'replay', gValue: 0xf30a},
      {gLabel: 'replay_10', gValue: 0xf306},
      {gLabel: 'replay_30', gValue: 0xf307},
      {gLabel: 'replay_5', gValue: 0xf308},
      {gLabel: 'replay_circle_filled', gValue: 0xf309},
      {gLabel: 'reply', gValue: 0xf30c},
      {gLabel: 'reply_all', gValue: 0xf30b},
      {gLabel: 'report', gValue: 0xf30f},
      {gLabel: 'report_gmailerrorred', gValue: 0xf30d},
      {gLabel: 'report_off', gValue: 0xf30e},
      {gLabel: 'report_problem', gValue: 0xf310},
      {gLabel: 'request_page', gValue: 0xf311},
      {gLabel: 'request_quote', gValue: 0xf312},
      {gLabel: 'reset_tv', gValue: 0xf313},
      {gLabel: 'restart_alt', gValue: 0xf314},
      {gLabel: 'restaurant', gValue: 0xf316},
      {gLabel: 'restaurant_menu', gValue: 0xf315},
      {gLabel: 'restore', gValue: 0xf318},
      {gLabel: 'restore_from_trash', gValue: 0xf317},
      {gLabel: 'restore_page', gValue: 0xf319},
      {gLabel: 'reviews', gValue: 0xf31a},
      {gLabel: 'rice_bowl', gValue: 0xf31b},
      {gLabel: 'ring_volume', gValue: 0xf31c},
      {gLabel: 'rocket', gValue: 0xf0654},
      {gLabel: 'rocket_launch', gValue: 0xf0653},
      {gLabel: 'roller_shades', gValue: 0xf070d},
      {gLabel: 'roller_shades_closed', gValue: 0xf070c},
      {gLabel: 'roller_skating', gValue: 0xf06a6},
      {gLabel: 'roofing', gValue: 0xf31d},
      {gLabel: 'room', gValue: 0xf31e},
      {gLabel: 'room_preferences', gValue: 0xf31f},
      {gLabel: 'room_service', gValue: 0xf320},
      {gLabel: 'rotate_90_degrees_ccw', gValue: 0xf321},
      {gLabel: 'rotate_90_degrees_cw', gValue: 0xf0655},
      {gLabel: 'rotate_left', gValue: 0xf322},
      {gLabel: 'rotate_right', gValue: 0xf323},
      {gLabel: 'roundabout_left', gValue: 0xf0656},
      {gLabel: 'roundabout_right', gValue: 0xf0657},
      {gLabel: 'rounded_corner', gValue: 0xf324},
      {gLabel: 'route', gValue: 0xf0658},
      {gLabel: 'router', gValue: 0xf325},
      {gLabel: 'rowing', gValue: 0xf326},
      {gLabel: 'rss_feed', gValue: 0xf327},
      {gLabel: 'rsvp', gValue: 0xf328},
      {gLabel: 'rtt', gValue: 0xf329},
      {gLabel: 'rule', gValue: 0xf32b},
      {gLabel: 'rule_folder', gValue: 0xf32a},
      {gLabel: 'run_circle', gValue: 0xf32c},
      {gLabel: 'running_with_errors', gValue: 0xf32d},
      {gLabel: 'rv_hookup', gValue: 0xf32e},
      {gLabel: 'safety_check', gValue: 0xf070e},
      {gLabel: 'safety_divider', gValue: 0xf32f},
      {gLabel: 'sailing', gValue: 0xf330},
      {gLabel: 'sanitizer', gValue: 0xf331},
      {gLabel: 'satellite', gValue: 0xf332},
      {gLabel: 'satellite_alt', gValue: 0xf0659},
      {gLabel: 'save', gValue: 0xf334},
      {gLabel: 'save_alt', gValue: 0xf333},
      {gLabel: 'save_as', gValue: 0xf065a},
      {gLabel: 'saved_search', gValue: 0xf335},
      {gLabel: 'savings', gValue: 0xf336},
      {gLabel: 'scale', gValue: 0xf065b},
      {gLabel: 'scanner', gValue: 0xf337},
      {gLabel: 'scatter_plot', gValue: 0xf338},
      {gLabel: 'schedule', gValue: 0xf339},
      {gLabel: 'schedule_send', gValue: 0xf33a},
      {gLabel: 'schema', gValue: 0xf33b},
      {gLabel: 'school', gValue: 0xf33c},
      {gLabel: 'science', gValue: 0xf33d},
      {gLabel: 'score', gValue: 0xf33e},
      {gLabel: 'scoreboard', gValue: 0xf06a7},
      {gLabel: 'screen_lock_landscape', gValue: 0xf33f},
      {gLabel: 'screen_lock_portrait', gValue: 0xf340},
      {gLabel: 'screen_lock_rotation', gValue: 0xf341},
      {gLabel: 'screen_rotation', gValue: 0xf342},
      {gLabel: 'screen_rotation_alt', gValue: 0xf070f},
      {gLabel: 'screen_search_desktop', gValue: 0xf343},
      {gLabel: 'screen_share', gValue: 0xf344},
      {gLabel: 'screenshot', gValue: 0xf345},
      {gLabel: 'screenshot_monitor', gValue: 0xf0710},
      {gLabel: 'scuba_diving', gValue: 0xf06a8},
      {gLabel: 'sd', gValue: 0xf348},
      {gLabel: 'sd_card', gValue: 0xf347},
      {gLabel: 'sd_card_alert', gValue: 0xf346},
      {gLabel: 'sd_storage', gValue: 0xf349},
      {gLabel: 'search', gValue: 0xf34b},
      {gLabel: 'search_off', gValue: 0xf34a},
      {gLabel: 'security', gValue: 0xf34c},
      {gLabel: 'security_update', gValue: 0xf34e},
      {gLabel: 'security_update_good', gValue: 0xf34d},
      {gLabel: 'security_update_warning', gValue: 0xf34f},
      {gLabel: 'segment', gValue: 0xf350},
      {gLabel: 'select_all', gValue: 0xf351},
      {gLabel: 'self_improvement', gValue: 0xf352},
      {gLabel: 'sell', gValue: 0xf353},
      {gLabel: 'send', gValue: 0xf355},
      {gLabel: 'send_and_archive', gValue: 0xf354},
      {gLabel: 'send_time_extension', gValue: 0xf065c},
      {gLabel: 'send_to_mobile', gValue: 0xf356},
      {gLabel: 'sensor_door', gValue: 0xf357},
      {gLabel: 'sensor_occupied', gValue: 0xf0711},
      {gLabel: 'sensor_window', gValue: 0xf358},
      {gLabel: 'sensors', gValue: 0xf35a},
      {gLabel: 'sensors_off', gValue: 0xf359},
      {gLabel: 'sentiment_dissatisfied', gValue: 0xf35b},
      {gLabel: 'sentiment_neutral', gValue: 0xf35c},
      {gLabel: 'sentiment_satisfied', gValue: 0xf35e},
      {gLabel: 'sentiment_satisfied_alt', gValue: 0xf35d},
      {gLabel: 'sentiment_very_dissatisfied', gValue: 0xf35f},
      {gLabel: 'sentiment_very_satisfied', gValue: 0xf360},
      {gLabel: 'set_meal', gValue: 0xf361},
      {gLabel: 'settings', gValue: 0xf36e},
      {gLabel: 'settings_accessibility', gValue: 0xf362},
      {gLabel: 'settings_applications', gValue: 0xf363},
      {gLabel: 'settings_backup_restore', gValue: 0xf364},
      {gLabel: 'settings_bluetooth', gValue: 0xf365},
      {gLabel: 'settings_brightness', gValue: 0xf366},
      {gLabel: 'settings_cell', gValue: 0xf367},
      {gLabel: 'settings_display', gValue: 0xf366},
      {gLabel: 'settings_ethernet', gValue: 0xf368},
      {gLabel: 'settings_input_antenna', gValue: 0xf369},
      {gLabel: 'settings_input_component', gValue: 0xf36a},
      {gLabel: 'settings_input_composite', gValue: 0xf36b},
      {gLabel: 'settings_input_hdmi', gValue: 0xf36c},
      {gLabel: 'settings_input_svideo', gValue: 0xf36d},
      {gLabel: 'settings_overscan', gValue: 0xf36f},
      {gLabel: 'settings_phone', gValue: 0xf370},
      {gLabel: 'settings_power', gValue: 0xf371},
      {gLabel: 'settings_remote', gValue: 0xf372},
      {gLabel: 'settings_suggest', gValue: 0xf373},
      {gLabel: 'settings_system_daydream', gValue: 0xf374},
      {gLabel: 'settings_voice', gValue: 0xf375},
      {gLabel: 'severe_cold', gValue: 0xf0712},
      {gLabel: 'shape_line', gValue: 0xf08b3},
      {gLabel: 'share', gValue: 0xf378},
      {gLabel: 'share_arrival_time', gValue: 0xf376},
      {gLabel: 'share_location', gValue: 0xf377},
      {gLabel: 'shield', gValue: 0xf379},
      {gLabel: 'shield_moon', gValue: 0xf065d},
      {gLabel: 'shop', gValue: 0xf37b},
      {gLabel: 'shop_2', gValue: 0xf37a},
      {gLabel: 'shop_two', gValue: 0xf37c},
      {gLabel: 'shopify', gValue: 0xf065e},
      {gLabel: 'shopping_bag', gValue: 0xf37d},
      {gLabel: 'shopping_basket', gValue: 0xf37e},
      {gLabel: 'shopping_cart', gValue: 0xf37f},
      {gLabel: 'shopping_cart_checkout', gValue: 0xf065f},
      {gLabel: 'short_text', gValue: 0xf380},
      {gLabel: 'shortcut', gValue: 0xf381},
      {gLabel: 'show_chart', gValue: 0xf382},
      {gLabel: 'shower', gValue: 0xf383},
      {gLabel: 'shuffle', gValue: 0xf385},
      {gLabel: 'shuffle_on', gValue: 0xf384},
      {gLabel: 'shutter_speed', gValue: 0xf386},
      {gLabel: 'sick', gValue: 0xf387},
      {gLabel: 'sign_language', gValue: 0xf0713},
      {gLabel: 'signal_cellular_0_bar', gValue: 0xf388},
      {gLabel: 'signal_cellular_4_bar', gValue: 0xf389},
      {gLabel: 'signal_cellular_alt', gValue: 0xf38a},
      {gLabel: 'signal_cellular_alt_1_bar', gValue: 0xf0714},
      {gLabel: 'signal_cellular_alt_2_bar', gValue: 0xf0715},
      {gLabel: 'signal_cellular_connected_no_internet_0_bar', gValue: 0xf38b},
      {gLabel: 'signal_cellular_connected_no_internet_4_bar', gValue: 0xf38c},
      {gLabel: 'signal_cellular_no_sim', gValue: 0xf38d},
      {gLabel: 'signal_cellular_nodata', gValue: 0xf38e},
      {gLabel: 'signal_cellular_null', gValue: 0xf38f},
      {gLabel: 'signal_cellular_off', gValue: 0xf390},
      {gLabel: 'signal_wifi_0_bar', gValue: 0xf391},
      {gLabel: 'signal_wifi_4_bar', gValue: 0xf393},
      {gLabel: 'signal_wifi_4_bar_lock', gValue: 0xf392},
      {gLabel: 'signal_wifi_bad', gValue: 0xf394},
      {gLabel: 'signal_wifi_connected_no_internet_4', gValue: 0xf395},
      {gLabel: 'signal_wifi_off', gValue: 0xf396},
      {gLabel: 'signal_wifi_statusbar_4_bar', gValue: 0xf397},
      {gLabel: 'signal_wifi_statusbar_connected_no_internet_4', gValue: 0xf398},
      {gLabel: 'signal_wifi_statusbar_null', gValue: 0xf399},
      {gLabel: 'signpost', gValue: 0xf0660},
      {gLabel: 'sim_card', gValue: 0xf39c},
      {gLabel: 'sim_card_alert', gValue: 0xf39a},
      {gLabel: 'sim_card_download', gValue: 0xf39b},
      {gLabel: 'single_bed', gValue: 0xf39d},
      {gLabel: 'sip', gValue: 0xf39e},
      {gLabel: 'skateboarding', gValue: 0xf39f},
      {gLabel: 'skip_next', gValue: 0xf3a0},
      {gLabel: 'skip_previous', gValue: 0xf3a1},
      {gLabel: 'sledding', gValue: 0xf3a2},
      {gLabel: 'slideshow', gValue: 0xf3a3},
      {gLabel: 'slow_motion_video', gValue: 0xf3a4},
      {gLabel: 'smart_button', gValue: 0xf3a5},
      {gLabel: 'smart_display', gValue: 0xf3a6},
      {gLabel: 'smart_screen', gValue: 0xf3a7},
      {gLabel: 'smart_toy', gValue: 0xf3a8},
      {gLabel: 'smartphone', gValue: 0xf3a9},
      {gLabel: 'smoke_free', gValue: 0xf3aa},
      {gLabel: 'smoking_rooms', gValue: 0xf3ab},
      {gLabel: 'sms', gValue: 0xf3ad},
      {gLabel: 'sms_failed', gValue: 0xf3ac},
      {gLabel: 'snapchat', gValue: 0xf0661},
      {gLabel: 'snippet_folder', gValue: 0xf3ae},
      {gLabel: 'snooze', gValue: 0xf3af},
      {gLabel: 'snowboarding', gValue: 0xf3b0},
      {gLabel: 'snowmobile', gValue: 0xf3b1},
      {gLabel: 'snowshoeing', gValue: 0xf3b2},
      {gLabel: 'soap', gValue: 0xf3b3},
      {gLabel: 'social_distance', gValue: 0xf3b4},
      {gLabel: 'solar_power', gValue: 0xf0716},
      {gLabel: 'sort', gValue: 0xf3b6},
      {gLabel: 'sort_by_alpha', gValue: 0xf3b5},
      {gLabel: 'sos', gValue: 0xf0717},
      {gLabel: 'soup_kitchen', gValue: 0xf0662},
      {gLabel: 'source', gValue: 0xf3b7},
      {gLabel: 'south', gValue: 0xf3b9},
      {gLabel: 'south_america', gValue: 0xf0663},
      {gLabel: 'south_east', gValue: 0xf3b8},
      {gLabel: 'south_west', gValue: 0xf3ba},
      {gLabel: 'spa', gValue: 0xf3bb},
      {gLabel: 'space_bar', gValue: 0xf3bc},
      {gLabel: 'space_dashboard', gValue: 0xf3bd},
      {gLabel: 'spatial_audio', gValue: 0xf0719},
      {gLabel: 'spatial_audio_off', gValue: 0xf0718},
      {gLabel: 'spatial_tracking', gValue: 0xf071a},
      {gLabel: 'speaker', gValue: 0xf3c1},
      {gLabel: 'speaker_group', gValue: 0xf3be},
      {gLabel: 'speaker_notes', gValue: 0xf3c0},
      {gLabel: 'speaker_notes_off', gValue: 0xf3bf},
      {gLabel: 'speaker_phone', gValue: 0xf3c2},
      {gLabel: 'speed', gValue: 0xf3c3},
      {gLabel: 'spellcheck', gValue: 0xf3c4},
      {gLabel: 'splitscreen', gValue: 0xf3c5},
      {gLabel: 'spoke', gValue: 0xf0664},
      {gLabel: 'sports', gValue: 0xf3d2},
      {gLabel: 'sports_bar', gValue: 0xf3c6},
      {gLabel: 'sports_baseball', gValue: 0xf3c7},
      {gLabel: 'sports_basketball', gValue: 0xf3c8},
      {gLabel: 'sports_cricket', gValue: 0xf3c9},
      {gLabel: 'sports_esports', gValue: 0xf3ca},
      {gLabel: 'sports_football', gValue: 0xf3cb},
      {gLabel: 'sports_golf', gValue: 0xf3cc},
      {gLabel: 'sports_gymnastics', gValue: 0xf06a9},
      {gLabel: 'sports_handball', gValue: 0xf3cd},
      {gLabel: 'sports_hockey', gValue: 0xf3ce},
      {gLabel: 'sports_kabaddi', gValue: 0xf3cf},
      {gLabel: 'sports_martial_arts', gValue: 0xf0665},
      {gLabel: 'sports_mma', gValue: 0xf3d0},
      {gLabel: 'sports_motorsports', gValue: 0xf3d1},
      {gLabel: 'sports_rugby', gValue: 0xf3d3},
      {gLabel: 'sports_score', gValue: 0xf3d4},
      {gLabel: 'sports_soccer', gValue: 0xf3d5},
      {gLabel: 'sports_tennis', gValue: 0xf3d6},
      {gLabel: 'sports_volleyball', gValue: 0xf3d7},
      {gLabel: 'square', gValue: 0xf0666},
      {gLabel: 'square_foot', gValue: 0xf3d8},
      {gLabel: 'ssid_chart', gValue: 0xf0667},
      {gLabel: 'stacked_bar_chart', gValue: 0xf3d9},
      {gLabel: 'stacked_line_chart', gValue: 0xf3da},
      {gLabel: 'stadium', gValue: 0xf0668},
      {gLabel: 'stairs', gValue: 0xf3db},
      {gLabel: 'star', gValue: 0xf3e0},
      {gLabel: 'star_border', gValue: 0xf3dc},
      {gLabel: 'star_border_purple500', gValue: 0xf3dd},
      {gLabel: 'star_half', gValue: 0xf3de},
      {gLabel: 'star_outline', gValue: 0xf3df},
      {gLabel: 'star_purple500', gValue: 0xf3e1},
      {gLabel: 'star_rate', gValue: 0xf3e2},
      {gLabel: 'stars', gValue: 0xf3e3},
      {gLabel: 'start', gValue: 0xf0669},
      {gLabel: 'stay_current_landscape', gValue: 0xf3e4},
      {gLabel: 'stay_current_portrait', gValue: 0xf3e5},
      {gLabel: 'stay_primary_landscape', gValue: 0xf3e6},
      {gLabel: 'stay_primary_portrait', gValue: 0xf3e7},
      {gLabel: 'sticky_note_2', gValue: 0xf3e8},
      {gLabel: 'stop', gValue: 0xf3ea},
      {gLabel: 'stop_circle', gValue: 0xf3e9},
      {gLabel: 'stop_screen_share', gValue: 0xf3eb},
      {gLabel: 'storage', gValue: 0xf3ec},
      {gLabel: 'store', gValue: 0xf3ee},
      {gLabel: 'store_mall_directory', gValue: 0xf3ed},
      {gLabel: 'storefront', gValue: 0xf3ef},
      {gLabel: 'storm', gValue: 0xf3f0},
      {gLabel: 'straight', gValue: 0xf066a},
      {gLabel: 'straighten', gValue: 0xf3f1},
      {gLabel: 'stream', gValue: 0xf3f2},
      {gLabel: 'streetview', gValue: 0xf3f3},
      {gLabel: 'strikethrough_s', gValue: 0xf3f4},
      {gLabel: 'stroller', gValue: 0xf3f5},
      {gLabel: 'style', gValue: 0xf3f6},
      {gLabel: 'subdirectory_arrow_left', gValue: 0xf3f7},
      {gLabel: 'subdirectory_arrow_right', gValue: 0xf3f8},
      {gLabel: 'subject', gValue: 0xf3f9},
      {gLabel: 'subscript', gValue: 0xf3fa},
      {gLabel: 'subscriptions', gValue: 0xf3fb},
      {gLabel: 'subtitles', gValue: 0xf3fd},
      {gLabel: 'subtitles_off', gValue: 0xf3fc},
      {gLabel: 'subway', gValue: 0xf3fe},
      {gLabel: 'summarize', gValue: 0xf3ff},
      {gLabel: 'superscript', gValue: 0xf400},
      {gLabel: 'supervised_user_circle', gValue: 0xf401},
      {gLabel: 'supervisor_account', gValue: 0xf402},
      {gLabel: 'support', gValue: 0xf404},
      {gLabel: 'support_agent', gValue: 0xf403},
      {gLabel: 'surfing', gValue: 0xf405},
      {gLabel: 'surround_sound', gValue: 0xf406},
      {gLabel: 'swap_calls', gValue: 0xf407},
      {gLabel: 'swap_horiz', gValue: 0xf408},
      {gLabel: 'swap_horizontal_circle', gValue: 0xf409},
      {gLabel: 'swap_vert', gValue: 0xf40a},
      {gLabel: 'swap_vert_circle', gValue: 0xf40b},
      {gLabel: 'swap_vertical_circle', gValue: 0xf40b},
      {gLabel: 'swipe', gValue: 0xf40c},
      {gLabel: 'swipe_down', gValue: 0xf066c},
      {gLabel: 'swipe_down_alt', gValue: 0xf066b},
      {gLabel: 'swipe_left', gValue: 0xf066e},
      {gLabel: 'swipe_left_alt', gValue: 0xf066d},
      {gLabel: 'swipe_right', gValue: 0xf0670},
      {gLabel: 'swipe_right_alt', gValue: 0xf066f},
      {gLabel: 'swipe_up', gValue: 0xf0672},
      {gLabel: 'swipe_up_alt', gValue: 0xf0671},
      {gLabel: 'swipe_vertical', gValue: 0xf0673},
      {gLabel: 'switch_access_shortcut', gValue: 0xf0675},
      {gLabel: 'switch_access_shortcut_add', gValue: 0xf0674},
      {gLabel: 'switch_account', gValue: 0xf40d},
      {gLabel: 'switch_camera', gValue: 0xf40e},
      {gLabel: 'switch_left', gValue: 0xf40f},
      {gLabel: 'switch_right', gValue: 0xf410},
      {gLabel: 'switch_video', gValue: 0xf411},
      {gLabel: 'synagogue', gValue: 0xf0676},
      {gLabel: 'sync', gValue: 0xf414},
      {gLabel: 'sync_alt', gValue: 0xf412},
      {gLabel: 'sync_disabled', gValue: 0xf413},
      {gLabel: 'sync_lock', gValue: 0xf0677},
      {gLabel: 'sync_problem', gValue: 0xf415},
      {gLabel: 'system_security_update', gValue: 0xf417},
      {gLabel: 'system_security_update_good', gValue: 0xf416},
      {gLabel: 'system_security_update_warning', gValue: 0xf418},
      {gLabel: 'system_update', gValue: 0xf41a},
      {gLabel: 'system_update_alt', gValue: 0xf419},
      {gLabel: 'system_update_tv', gValue: 0xf419},
      {gLabel: 'tab', gValue: 0xf41b},
      {gLabel: 'tab_unselected', gValue: 0xf41c},
      {gLabel: 'table_bar', gValue: 0xf0678},
      {gLabel: 'table_chart', gValue: 0xf41d},
      {gLabel: 'table_restaurant', gValue: 0xf0679},
      {gLabel: 'table_rows', gValue: 0xf41e},
      {gLabel: 'table_view', gValue: 0xf41f},
      {gLabel: 'tablet', gValue: 0xf422},
      {gLabel: 'tablet_android', gValue: 0xf420},
      {gLabel: 'tablet_mac', gValue: 0xf421},
      {gLabel: 'tag', gValue: 0xf424},
      {gLabel: 'tag_faces', gValue: 0xf423},
      {gLabel: 'takeout_dining', gValue: 0xf425},
      {gLabel: 'tap_and_play', gValue: 0xf426},
      {gLabel: 'tapas', gValue: 0xf427},
      {gLabel: 'task', gValue: 0xf429},
      {gLabel: 'task_alt', gValue: 0xf428},
      {gLabel: 'taxi_alert', gValue: 0xf42a},
      {gLabel: 'telegram', gValue: 0xf067a},
      {gLabel: 'temple_buddhist', gValue: 0xf067b},
      {gLabel: 'temple_hindu', gValue: 0xf067c},
      {gLabel: 'terminal', gValue: 0xf067d},
      {gLabel: 'terrain', gValue: 0xf42b},
      {gLabel: 'text_decrease', gValue: 0xf067e},
      {gLabel: 'text_fields', gValue: 0xf42c},
      {gLabel: 'text_format', gValue: 0xf42d},
      {gLabel: 'text_increase', gValue: 0xf067f},
      {gLabel: 'text_rotate_up', gValue: 0xf42e},
      {gLabel: 'text_rotate_vertical', gValue: 0xf42f},
      {gLabel: 'text_rotation_angledown', gValue: 0xf430},
      {gLabel: 'text_rotation_angleup', gValue: 0xf431},
      {gLabel: 'text_rotation_down', gValue: 0xf432},
      {gLabel: 'text_rotation_none', gValue: 0xf433},
      {gLabel: 'text_snippet', gValue: 0xf434},
      {gLabel: 'textsms', gValue: 0xf435},
      {gLabel: 'texture', gValue: 0xf436},
      {gLabel: 'theater_comedy', gValue: 0xf437},
      {gLabel: 'theaters', gValue: 0xf438},
      {gLabel: 'thermostat', gValue: 0xf43a},
      {gLabel: 'thermostat_auto', gValue: 0xf439},
      {gLabel: 'thumb_down', gValue: 0xf43d},
      {gLabel: 'thumb_down_alt', gValue: 0xf43b},
      {gLabel: 'thumb_down_off_alt', gValue: 0xf43c},
      {gLabel: 'thumb_up', gValue: 0xf440},
      {gLabel: 'thumb_up_alt', gValue: 0xf43e},
      {gLabel: 'thumb_up_off_alt', gValue: 0xf43f},
      {gLabel: 'thumbs_up_down', gValue: 0xf441},
      {gLabel: 'thunderstorm', gValue: 0xf071b},
      {gLabel: 'tiktok', gValue: 0xf0680},
      {gLabel: 'time_to_leave', gValue: 0xf442},
      {gLabel: 'timelapse', gValue: 0xf443},
      {gLabel: 'timeline', gValue: 0xf444},
      {gLabel: 'timer', gValue: 0xf44a},
      {gLabel: 'timer_10', gValue: 0xf445},
      {gLabel: 'timer_10_select', gValue: 0xf446},
      {gLabel: 'timer_3', gValue: 0xf447},
      {gLabel: 'timer_3_select', gValue: 0xf448},
      {gLabel: 'timer_off', gValue: 0xf449},
      {gLabel: 'tips_and_updates', gValue: 0xf0681},
      {gLabel: 'tire_repair', gValue: 0xf06aa},
      {gLabel: 'title', gValue: 0xf44b},
      {gLabel: 'toc', gValue: 0xf44c},
      {gLabel: 'today', gValue: 0xf44d},
      {gLabel: 'toggle_off', gValue: 0xf44e},
      {gLabel: 'toggle_on', gValue: 0xf44f},
      {gLabel: 'token', gValue: 0xf0682},
      {gLabel: 'toll', gValue: 0xf450},
      {gLabel: 'tonality', gValue: 0xf451},
      {gLabel: 'topic', gValue: 0xf452},
      {gLabel: 'tornado', gValue: 0xf071c},
      {gLabel: 'touch_app', gValue: 0xf453},
      {gLabel: 'tour', gValue: 0xf454},
      {gLabel: 'toys', gValue: 0xf455},
      {gLabel: 'track_changes', gValue: 0xf456},
      {gLabel: 'traffic', gValue: 0xf457},
      {gLabel: 'train', gValue: 0xf458},
      {gLabel: 'tram', gValue: 0xf459},
      {gLabel: 'transcribe', gValue: 0xf071d},
      {gLabel: 'transfer_within_a_station', gValue: 0xf45a},
      {gLabel: 'transform', gValue: 0xf45b},
      {gLabel: 'transgender', gValue: 0xf45c},
      {gLabel: 'transit_enterexit', gValue: 0xf45d},
      {gLabel: 'translate', gValue: 0xf45e},
      {gLabel: 'travel_explore', gValue: 0xf45f},
      {gLabel: 'trending_down', gValue: 0xf460},
      {gLabel: 'trending_flat', gValue: 0xf461},
      {gLabel: 'trending_neutral', gValue: 0xf461},
      {gLabel: 'trending_up', gValue: 0xf462},
      {gLabel: 'trip_origin', gValue: 0xf463},
      {gLabel: 'troubleshoot', gValue: 0xf071e},
      {gLabel: 'try_sms_star', gValue: 0xf464},
      {gLabel: 'tsunami', gValue: 0xf071f},
      {gLabel: 'tty', gValue: 0xf465},
      {gLabel: 'tune', gValue: 0xf466},
      {gLabel: 'tungsten', gValue: 0xf467},
      {gLabel: 'turn_left', gValue: 0xf0683},
      {gLabel: 'turn_right', gValue: 0xf0684},
      {gLabel: 'turn_sharp_left', gValue: 0xf0685},
      {gLabel: 'turn_sharp_right', gValue: 0xf0686},
      {gLabel: 'turn_slight_left', gValue: 0xf0687},
      {gLabel: 'turn_slight_right', gValue: 0xf0688},
      {gLabel: 'turned_in', gValue: 0xf469},
      {gLabel: 'turned_in_not', gValue: 0xf468},
      {gLabel: 'tv', gValue: 0xf46b},
      {gLabel: 'tv_off', gValue: 0xf46a},
      {gLabel: 'two_wheeler', gValue: 0xf46c},
      {gLabel: 'type_specimen', gValue: 0xf0720},
      {gLabel: 'u_turn_left', gValue: 0xf0689},
      {gLabel: 'u_turn_right', gValue: 0xf068a},
      {gLabel: 'umbrella', gValue: 0xf46d},
      {gLabel: 'unarchive', gValue: 0xf46e},
      {gLabel: 'undo', gValue: 0xf46f},
      {gLabel: 'unfold_less', gValue: 0xf470},
      {gLabel: 'unfold_less_double', gValue: 0xf08b4},
      {gLabel: 'unfold_more', gValue: 0xf471},
      {gLabel: 'unfold_more_double', gValue: 0xf08b5},
      {gLabel: 'unpublished', gValue: 0xf472},
      {gLabel: 'unsubscribe', gValue: 0xf473},
      {gLabel: 'upcoming', gValue: 0xf474},
      {gLabel: 'update', gValue: 0xf476},
      {gLabel: 'update_disabled', gValue: 0xf475},
      {gLabel: 'upgrade', gValue: 0xf477},
      {gLabel: 'upload', gValue: 0xf479},
      {gLabel: 'upload_file', gValue: 0xf478},
      {gLabel: 'usb', gValue: 0xf47b},
      {gLabel: 'usb_off', gValue: 0xf47a},
      {gLabel: 'vaccines', gValue: 0xf068b},
      {gLabel: 'vape_free', gValue: 0xf06ab},
      {gLabel: 'vaping_rooms', gValue: 0xf06ac},
      {gLabel: 'verified', gValue: 0xf47c},
      {gLabel: 'verified_user', gValue: 0xf47d},
      {gLabel: 'vertical_align_bottom', gValue: 0xf47e},
      {gLabel: 'vertical_align_center', gValue: 0xf47f},
      {gLabel: 'vertical_align_top', gValue: 0xf480},
      {gLabel: 'vertical_distribute', gValue: 0xf481},
      {gLabel: 'vertical_shades', gValue: 0xf0722},
      {gLabel: 'vertical_shades_closed', gValue: 0xf0721},
      {gLabel: 'vertical_split', gValue: 0xf482},
      {gLabel: 'vibration', gValue: 0xf483},
      {gLabel: 'video_call', gValue: 0xf484},
      {gLabel: 'video_camera_back', gValue: 0xf485},
      {gLabel: 'video_camera_front', gValue: 0xf486},
      {gLabel: 'video_chat', gValue: 0xf08b6},
      {gLabel: 'video_collection', gValue: 0xf488},
      {gLabel: 'video_file', gValue: 0xf068c},
      {gLabel: 'video_label', gValue: 0xf487},
      {gLabel: 'video_library', gValue: 0xf488},
      {gLabel: 'video_settings', gValue: 0xf489},
      {gLabel: 'video_stable', gValue: 0xf48a},
      {gLabel: 'videocam', gValue: 0xf48c},
      {gLabel: 'videocam_off', gValue: 0xf48b},
      {gLabel: 'videogame_asset', gValue: 0xf48e},
      {gLabel: 'videogame_asset_off', gValue: 0xf48d},
      {gLabel: 'view_agenda', gValue: 0xf48f},
      {gLabel: 'view_array', gValue: 0xf490},
      {gLabel: 'view_carousel', gValue: 0xf491},
      {gLabel: 'view_column', gValue: 0xf492},
      {gLabel: 'view_comfortable', gValue: 0xf493},
      {gLabel: 'view_comfy', gValue: 0xf493},
      {gLabel: 'view_comfy_alt', gValue: 0xf068d},
      {gLabel: 'view_compact', gValue: 0xf494},
      {gLabel: 'view_compact_alt', gValue: 0xf068e},
      {gLabel: 'view_cozy', gValue: 0xf068f},
      {gLabel: 'view_day', gValue: 0xf495},
      {gLabel: 'view_headline', gValue: 0xf496},
      {gLabel: 'view_in_ar', gValue: 0xf497},
      {gLabel: 'view_kanban', gValue: 0xf0690},
      {gLabel: 'view_list', gValue: 0xf498},
      {gLabel: 'view_module', gValue: 0xf499},
      {gLabel: 'view_quilt', gValue: 0xf49a},
      {gLabel: 'view_sidebar', gValue: 0xf49b},
      {gLabel: 'view_stream', gValue: 0xf49c},
      {gLabel: 'view_timeline', gValue: 0xf0691},
      {gLabel: 'view_week', gValue: 0xf49d},
      {gLabel: 'vignette', gValue: 0xf49e},
      {gLabel: 'villa', gValue: 0xf49f},
      {gLabel: 'visibility', gValue: 0xf4a1},
      {gLabel: 'visibility_off', gValue: 0xf4a0},
      {gLabel: 'voice_chat', gValue: 0xf4a2},
      {gLabel: 'voice_over_off', gValue: 0xf4a3},
      {gLabel: 'voicemail', gValue: 0xf4a4},
      {gLabel: 'volcano', gValue: 0xf0723},
      {gLabel: 'volume_down', gValue: 0xf4a5},
      {gLabel: 'volume_mute', gValue: 0xf4a6},
      {gLabel: 'volume_off', gValue: 0xf4a7},
      {gLabel: 'volume_up', gValue: 0xf4a8},
      {gLabel: 'volunteer_activism', gValue: 0xf4a9},
      {gLabel: 'vpn_key', gValue: 0xf4aa},
      {gLabel: 'vpn_key_off', gValue: 0xf0692},
      {gLabel: 'vpn_lock', gValue: 0xf4ab},
      {gLabel: 'vrpano', gValue: 0xf4ac},
      {gLabel: 'wallet', gValue: 0xf0724},
      {gLabel: 'wallet_giftcard', gValue: 0xef2d},
      {gLabel: 'wallet_membership', gValue: 0xef2e},
      {gLabel: 'wallet_travel', gValue: 0xef2f},
      {gLabel: 'wallpaper', gValue: 0xf4ad},
      {gLabel: 'warehouse', gValue: 0xf0693},
      {gLabel: 'warning', gValue: 0xf4af},
      {gLabel: 'warning_amber', gValue: 0xf4ae},
      {gLabel: 'wash', gValue: 0xf4b0},
      {gLabel: 'watch', gValue: 0xf4b2},
      {gLabel: 'watch_later', gValue: 0xf4b1},
      {gLabel: 'watch_off', gValue: 0xf0694},
      {gLabel: 'water', gValue: 0xf4b4},
      {gLabel: 'water_damage', gValue: 0xf4b3},
      {gLabel: 'water_drop', gValue: 0xf0695},
      {gLabel: 'waterfall_chart', gValue: 0xf4b5},
      {gLabel: 'waves', gValue: 0xf4b6},
      {gLabel: 'waving_hand', gValue: 0xf0696},
      {gLabel: 'wb_auto', gValue: 0xf4b7},
      {gLabel: 'wb_cloudy', gValue: 0xf4b8},
      {gLabel: 'wb_incandescent', gValue: 0xf4b9},
      {gLabel: 'wb_iridescent', gValue: 0xf4ba},
      {gLabel: 'wb_shade', gValue: 0xf4bb},
      {gLabel: 'wb_sunny', gValue: 0xf4bc},
      {gLabel: 'wb_twilight', gValue: 0xf4bd},
      {gLabel: 'wc', gValue: 0xf4be},
      {gLabel: 'web', gValue: 0xf4c1},
      {gLabel: 'web_asset', gValue: 0xf4c0},
      {gLabel: 'web_asset_off', gValue: 0xf4bf},
      {gLabel: 'web_stories', gValue: 0xf08b7},
      {gLabel: 'webhook', gValue: 0xf0697},
      {gLabel: 'wechat', gValue: 0xf0698},
      {gLabel: 'weekend', gValue: 0xf4c2},
      {gLabel: 'west', gValue: 0xf4c3},
      {gLabel: 'whatshot', gValue: 0xf4c4},
      {gLabel: 'wheelchair_pickup', gValue: 0xf4c5},
      {gLabel: 'where_to_vote', gValue: 0xf4c6},
      {gLabel: 'widgets', gValue: 0xf4c7},
      {gLabel: 'width_full', gValue: 0xf0725},
      {gLabel: 'width_normal', gValue: 0xf0726},
      {gLabel: 'width_wide', gValue: 0xf0727},
      {gLabel: 'wifi', gValue: 0xf4cc},
      {gLabel: 'wifi_1_bar', gValue: 0xf0728},
      {gLabel: 'wifi_2_bar', gValue: 0xf0729},
      {gLabel: 'wifi_calling', gValue: 0xf4c9},
      {gLabel: 'wifi_calling_3', gValue: 0xf4c8},
      {gLabel: 'wifi_channel', gValue: 0xf069a},
      {gLabel: 'wifi_find', gValue: 0xf069b},
      {gLabel: 'wifi_lock', gValue: 0xf4ca},
      {gLabel: 'wifi_off', gValue: 0xf4cb},
      {gLabel: 'wifi_password', gValue: 0xf069c},
      {gLabel: 'wifi_protected_setup', gValue: 0xf4cd},
      {gLabel: 'wifi_tethering', gValue: 0xf4d0},
      {gLabel: 'wifi_tethering_error', gValue: 0xf069d},
      {gLabel: 'wifi_tethering_error_rounded', gValue: 0xf069d},
      {gLabel: 'wifi_tethering_off', gValue: 0xf4cf},
      {gLabel: 'wind_power', gValue: 0xf072a},
      {gLabel: 'window', gValue: 0xf4d1},
      {gLabel: 'wine_bar', gValue: 0xf4d2},
      {gLabel: 'woman', gValue: 0xf069e},
      {gLabel: 'woman_2', gValue: 0xf08b8},
      {gLabel: 'woo_commerce', gValue: 0xf069f},
      {gLabel: 'wordpress', gValue: 0xf06a0},
      {gLabel: 'work', gValue: 0xf4d5},
      {gLabel: 'work_history', gValue: 0xf072b},
      {gLabel: 'work_off', gValue: 0xf4d3},
      {gLabel: 'work_outline', gValue: 0xf4d4},
      {gLabel: 'workspace_premium', gValue: 0xf06a1},
      {gLabel: 'workspaces', gValue: 0xf4d6},
      {gLabel: 'wrap_text', gValue: 0xf4d7},
      {gLabel: 'wrong_location', gValue: 0xf4d8},
      {gLabel: 'wysiwyg', gValue: 0xf4d9},
      {gLabel: 'yard', gValue: 0xf4da},
      {gLabel: 'youtube_searched_for', gValue: 0xf4db},
      {gLabel: 'zoom_in', gValue: 0xf4dc},
      {gLabel: 'zoom_in_map', gValue: 0xf06a2},
      {gLabel: 'zoom_out', gValue: 0xf4de},
      {gLabel: 'zoom_out_map', gValue: 0xf4dd}
    ];
    result.sort((e1, e2) => e1[gLabel].compareTo(e2[gLabel]));
    _dpList[gDpIcon] = result;
  }

  setDplistYear() {
    if ((_dpList[gYear] ?? []).length < 1) {
      int iYear = new DateTime.now().year;
      //int iYearMiddle = iYear - 49;
      List result = [];
      for (int i = 100; i >= -5; i--) {
        result.add((iYear - i).toString());
      }
      /*result.add((iYear - 100).toString() + '~' + (iYearMiddle - 1).toString());
      result.add(iYearMiddle.toString());
      result.add((iYearMiddle + 1).toString() + '~' + (iYear + 2).toString());*/

      _dpList[gYear] = result;
      List resultMonth = [];
      List resultDay31 = [];
      for (int i = 1; i < 10; i++) {
        resultMonth.add('0' + i.toString());
        resultDay31.add('0' + i.toString());
      }
      for (int i = 10; i < 13; i++) {
        resultMonth.add(i.toString());
      }
      _dpList[gMonth] = resultMonth;

      for (int i = 10; i < 32; i++) {
        resultDay31.add(i.toString());
      }

      _dpList[gDay] = resultDay31;
    }
  }

  setDroplist() {
    dynamic tabledata = _tableList[gZzydictionary];
    List tabledataList = tabledata[gData];
    dynamic tabledataItem = _tableList[gZzydictionaryitem];
    List tabledataListItem = tabledataItem[gData];
    tabledataList.forEach((element) {
      var parentid = element[gId];
      var label = element[gLabel];
      List result = [''];
      tabledataListItem.forEach((elementItem) {
        if (elementItem[gParentid] == parentid) {
          dynamic value = elementItem[gLabel];
          result.add(value);
        }
      });
      _dpList[label] = result;
    });
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

  setFormList(actionData, context) async {
    List<dynamic> thisList = actionData;
    for (int i = 0; i < thisList.length; i++) {
      Map<dynamic, dynamic> thisListI = thisList[i];
      var formID = thisListI[gFormName];
      //print('=========== setFormList formID is ' + formID);

      await setFormListOne(formID, thisListI);
      //print('=========== setFormList 0 ');
      if (formID == gVerifycode) {
        //print('=========== setFormList 00 ');
        //setFormAllFocusFalse(gLogin);
        setValue(gLogin, gPassword, null, 'smilesmart');

        //myNotifyListeners();

        var email = getValue(gLogin, gEmail, null)[gValue];
        //getFormValue(gLogin, gEmail);
        setValue(gVerifycode, gEmail, null, email);
        _myId = email;
        //setFormFocus(formID, gCode);
      } else if (formID == gChangepassword) {
        //print('=========== setFormList 01 ');
        var email = getValue(gLogin, gEmail, null)[gValue];
        setValue(gLogin, gPassword, null, 'smilesmart');
        setValue(formID, gEmail, null, email);
        setFocus(formID, gPassword1, null, true, context);
        _myId = email;
      }
    }
    myNotifyListeners();
  }

  //setFormListOne(formID, param) {
  setFormListOne(name, formDetail) async {
    if (_formLists[name] != null) {
      return;
    }
    //var formDetail = param[gFormdetail];
    // var btns = param[gBtns];
    Map<dynamic, dynamic> formValue = Map.from(formDetail);

    Map<dynamic, dynamic> itemList = formValue[gItems];
    itemList.entries.forEach((elementItemList) {
      Map<dynamic, dynamic> valueItemList = elementItemList.value;

      valueItemList[gTextFontColor] = fromBdckcolor(_lastBackGroundColor);

      valueItemList = Map.from(valueItemList);
    });
    Map dataMap = Map.from(itemList);
    /* formValue[gItems] = Map.from(itemList);
    formValue[gItems].forEach((key, value) {
      formValue[gItems][key] = Map.of(value);
    });*/
    dataMap.forEach((key, value) {
      dataMap[key] = Map.of(value);
    });
    formValue[gItems] = Map.fromEntries(dataMap.entries.toList()
      ..sort((e1, e2) => e1.value['seq'] - e2.value['seq']));

    _formLists[name] = formValue;
    if (name == gLogin) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setValue(name, gEmail, null, prefs.getString('myid') ?? '');
      //setFormValue(name, gEmail, prefs.getString('myid') ?? '');
    }

    //print(jsonEncode(_formLists[formID]));
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

  setItemAferDPClick(item, value, typeOwner, name, id, context) {
    if (!isItemValueValid(item, value)) {
      return false;
    }
    value = getFormatter(value, item[gType]);
    setValue(name, item[gId], id, value);
    setFocusNext(name, item[gId], null, ((typeOwner ?? '') == gForm), context);
    myNotifyListeners();
    return true;
  }

  setFocus(name, colId, id, isForm, context) {
    clearActionBtnMap(name);
    var typeOwner = gForm;
    if (_tableList[name] != null) {
      typeOwner = gTable;
    }

    if (!isNull(colId)) {
      setFocusNode({
        gType: typeOwner,
        gName: name,
        gCol: colId,
        gId: id,
        gIsForm: isForm,
      }, context);

      return;
    }

    //如要已有焦点，退出
    if (!isNull(_mFocusNode[gType] ?? '')) {
      return;
      /*if (_mFocusNode[gType] != gForm) {
        return;
      }
      if (!isNull(_mFocusNode[gName] ?? '') && _mFocusNode[gName] != formid) {
        return;
      }else if()*/
    }

    if (typeOwner != gForm && !isNull(id)) {
      return;
    }
    //if (typeOwner == gForm) {
    Map<dynamic, dynamic> items = _formLists[name]![gItems];
    bool findFocus = false;
    items.entries.forEach((itemOne) {
      Map item = itemOne.value;
      if ((item[gIsHidden] ?? "false") != gTrue &&
          (item[gType] ?? "") != gHidden) {
        colId = item[gId];
        var value = getValue(name, colId, id)[gValue];
        if (isNull(value) && !findFocus) {
          setFocusNode(
              {gType: typeOwner, gName: name, gCol: colId, gId: id ?? ''},
              context);
          findFocus = true;
          return;
        }
      }
    });
    /*} else if (typeOwner == gTable) {
      List columns = tableList[name][gColumns];
      for (int i = 0; i < columns.length; i++) {
        if (columns[i][gInputType] == gHidden) {
          continue;
        }
        if (columns[i][gType] == gLabel) {
          continue;
        }
        colId = columns[i][gId];
      }

      colId = _mFocusNode = {gType: typeOwner, gName: name, gCol: colId};*/
  }

  setFocusNext(name, colId, id, isForm, context) {
    //print('============    0');
    if (isNull(colId) || isNull(name)) {
      return;
    }
    //print('============    1');

    //print('============    2');
    var type = isNullID(id) ? gForm : gTable;
    bool findItem = false;
    if (type == gForm) {
      Map<dynamic, dynamic> itemsMap = _formLists[name]![gItems];

      itemsMap.entries.forEach((itemOne) {
        Map item = itemOne.value;
        if (findItem) {
          if (item[gInputType] != gHidden && item[gType] != gLabel) {
            setFocusNode(
                {gType: type, gName: name, gCol: item[gId], gIsForm: isForm},
                context);
            return;
          }
        }
        if (item[gId] == colId) {
          findItem = true;
        }
      });
    } else {
      List columns = tableList[name]![gColumns];
      for (int i = 0; i < columns.length; i++) {
        if (findItem) {
          if (columns[i][gInputType] == gHidden) {
            continue;
          }
          if (columns[i][gType] == gLabel) {
            continue;
          }
          setFocusNode(
              {gType: type, gName: name, gCol: columns[i][gId], gId: id},
              context);
          return;
        }
        if (columns[i][gId] == colId) {
          findItem = true;
        }
      }
    }
  }

  setFocusNode(map, context) {
    Map lastFocusNode = Map.of(_mFocusNode);
    if (lastFocusNode[gType] == map[gType] &&
        (lastFocusNode[gName] ?? '') == (map[gName] ?? '') &&
        (lastFocusNode[gCol] ?? '') == (map[gCol] ?? '') &&
        (lastFocusNode[gId] == map[gId])) {
      return;
    }

    //addnewcheck
    /*
    检查是否table
      检查上一项是否addnewcheck
        检查上一项是否修改
          检查上一项与本项是否相同
            向后台发addnewcheck验证
    后台如果发现新值已存在，执行操作（将值传回）
    前端： 
    */
    if (lastFocusNode[gType] == gTable) {
      if (!isNull(lastFocusNode[gCol]) && !isNull(lastFocusNode[gName])) {
        dynamic item = getTableCol(lastFocusNode[gName], lastFocusNode[gCol]);
        var value = getValue(
            lastFocusNode[gName], lastFocusNode[gCol], lastFocusNode[gId]);
        if (value[gType] != gOriginalValue) {
          var valueModified = value[gValue];
          bool isItemValid = isItemValueValid(item, valueModified);
          if (!isItemValid) {
            return;
          }
          if ((item[gAddnewcheck] ?? false)) {
            //send request
            lastFocusNode[gValue] = valueModified;
            sendRequestOne(gAddnewcheck, lastFocusNode, context);
          }
        }
      }
    }
    _mFocusNode = map;
    if (isNull(_mFocusNode[gErrMsg])) {
      return;
    }
    //var msg = _mFocusNode[gErrMsg];
    _mFocusNode[gErrMsg] = '';
    _mFocusNode[gId] = '';
    //showMsg(context, msg, null);
  }

  setFormDefaultValue(formid, colId, value) {
    _formLists[formid]![gItems][colId][gDefaultValue] = value;
  }

  setFormValueItemModified(item, value) {
    bool isItemVaid = isItemValueValid(item, value);
    if (isItemVaid) {
      item[gDataModified] = value;
      item[gDataModifiedInvalid] = null;
    } else {
      item[gDataModified] = null;
      item[gDataModifiedInvalid] = value;
    }
    //item[gTxtEditingController]..text = value;
  }

  /* setFormValueShow(formid, colId) {
    var item = _formLists[formid][gItems][colId];
    setFormValueShowValue(formid, colId, !(item[gShowDetail] ?? false));
  }

  setFormValueShowValue(formid, colId, value) {
    var item = _formLists[formid][gItems][colId];
    item[gShowDetail] = value;
  }*/

  /*setI10n(actionData) {
    for (int i = 0; i < actionData.length; i++) {
      Map<dynamic, dynamic> ai = Map.of(actionData[i]);
      ai.entries.forEach((element) {
        Map mValue = Map.of(element.value);
        _i10nMap[element.key] = mValue;
      });
    }
    myNotifyListeners();
  }*/

  setImgList(data) {
    for (int i = 0; i < data.length; i++) {
      Map dataMap = Map.of(data[i]);
      dataMap.entries.forEach((element) {
        _imgList[element.key] = element.value;
      });
    }
    myNotifyListeners();
  }

  setInitForm(actionData) {
    //_firstFormName = actionData[0][gName];
    myNotifyListeners();
  }

  setLocale(value) async {
    _locale = value;
    //S.load(_locale);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('locallan', value);
    myNotifyListeners();
  }

  setMyAction(data) {
    _actionLists[gMain] = data;
  }

  setMyInfo(data, context) async {
    //_myInfo = data;
    //setFormValue(gLogin, gEmail, data[gEmail]);
    //_formLists[gLogin][gItems][gEmail][gValue] = data[gEmail];
    setValue(gLogin, gEmail, null, data[gEmail]);
    //_formLists[gLogin][gItems][gEmail][gDefaultValue] = data[gEmail];
    _token = data[gToken];
    _myId = data[gEmail];
    _myDBId = data[gId];

    _globalCompanyid = data[gParentid];
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
    });

    myNotifyListeners();
  }

  setRowsPerPage(tableInfo, cnt) {
    tableInfo[gRowsPerPage] = cnt;
    myNotifyListeners();
  }

  setScreenSize(Size size) {
    _sceenSize = size;
  }

  setSessionkey(data) {
    int key = getInt(data);
    dynamic sessionkey = getMod(key, _arandomsession, _zzyprime).toString();
    _sessionkey = hash(sessionkey);
    //myNotifyListeners();
  }

  setTab(List data, context) {
    int i = 0;
    dynamic tabname = "";
    dynamic title = "";

    data.forEach((element) {
      List databodyNew = [];
      Map data0 = Map.of(element);
      tabname = data0[gTabid];
      title = data0[gLabel] ?? '';
      tabList[tabname] = {};
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
    });
    Map items = {};
    int index = 0;
    if (!isNull(title)) {
      items[index] = {
        gItem: jsonEncode({gType: gLabel, gValue: title, gFontSize: 20.0})
      };
      index = index + 10;
      items[index] = {
        gItem: jsonEncode({gType: gSizedbox, gValue: 20.0})
      };
      index = index + 10;
    }
    items[index] = {
      gItem: jsonEncode({gType: gTab, gValue: tabname})
    };

    List actionData = [
      {
        gName: tabname,
        gType: gScreen,
        gItems: items,
      }
    ];
    //print('==========  showScreenPage: ' + actionData.toString());
    showScreenPage(actionData, context, Colors.black.value);
    myNotifyListeners();
  }

  setTabBasic(List data, context, tabname) {
    tabList[tabname] = {};
    //data0[gIsselected] = true;
    for (int i = 0; i < data.length; i++) {
      data[i][gCanClose] = "false";
    }
    _tabList[tabname][gData] = data;
    _tabList[tabname][gTabIndex] = 0;
    _tabList[tabname][gFontSize] = 20.0;
  }

  setTableDataSearch(tableName, context, paramother) {
    dynamic tableInfo = _tableList[tableName];
    List tableData = tableInfo[gData];
    List columns = tableInfo[gColumns];
    dynamic searchValue = tableInfo[gSearch] ?? '';
    List newData = [];

//get where
    var aWhere = '';
    dynamic value0 = '';
    dynamic value1 = '';
    List param = [];
    dynamic other = paramother ?? null;
    if (other != null) {
      other = Map.of(other);
      dynamic aTitle = other[gOther] ?? null;
      if (aTitle != null) {
        dynamic data0 = whereList[aTitle] ?? null;
        if (data0 != null) {
          aWhere = data0[gWhere] ?? '';
          if (aWhere.indexOf("=") > 0) {
            param = aWhere.split('=');
            value0 = param[1];
            value1 = value0;
            if (value0[0] == "'") {
              value1 = value1.substring(1, value1.length - 1);
            }

            //newData = getDataWhere(newData, aWhere);
          }
        }
      }
    }

    for (int i = 0; i < tableData.length; i++) {
      Map dataRow = tableData[i];
      dynamic ti = getTableRowShowValueFilter(
          tableName, dataRow, columns, context, searchValue);
      if (ti != null) {
        if (param.length > 1) {
          if (ti[param[0]] == value1 || ti[param[0]] == value0) {
            newData.add(ti[gId]);
          }
        } else {
          newData.add(ti[gId]);
        }
      }
    }

    tableInfo[gDataSearch] = newData;
  }

  setTableList(List<dynamic> data, context) {
    data.forEach((element) {
      element = Map.of(element);
      addTable(element, context);
      /*element.entries.forEach((element1) {
        addTable(element1, context);
      });*/
    });
    //myNotifyListeners();
  }

  setTextController(actionData, context) {
    List<dynamic> thisList = actionData;
    for (int i = 0; i < thisList.length; i++) {
      Map<dynamic, dynamic> thisListI = thisList[i];
      var formID = thisListI[gFormName];
      var colId = thisListI[gCol];
      var value = thisListI[gValue];
      Map item = _formLists[formID]![gItems][colId];
      item[gTextController].text = value;
    }
  }

  setValue(name, colId, originalId, value) {
    /*
    找到修改值，
      如果找到，比较是否相同，
        如果相同，退出
        否则找原值
          如果找到原值，并相同，删除修改值，退出
          否则，更新修改值，退出

    未找到修改值
        找原值如果相等， 退出
        添加修改值
    */
    dynamic item;
    dynamic owner;
    var typeOwner = gForm;
    if (_tableList[name] != null) {
      typeOwner = gTable;
    }
    if (typeOwner == gTable) {
      item = getTableCol(name, colId);
      owner = _tableList[name];
    } else if (typeOwner == gForm) {
      item = _formLists[name]![gItems][colId];
      owner = _formLists[name];
    }

    bool isItemValid = isItemValueValid(item, value);
    if (isNull(owner[gDataModified])) {
      owner[gDataModified] = {};
    }
    if (isNull(owner[gDataModifiedInvalid])) {
      owner[gDataModifiedInvalid] = {};
    }
    Map dataModified = owner[gDataModified];
    Map dataModifiedInvalid = owner[gDataModifiedInvalid];
    dynamic mValue;
    bool isValidZone = true;
    var id = originalId ?? gFakeId;
    if (dataModified.containsKey(id)) {
      mValue = dataModified[id];
    } else if (dataModifiedInvalid.containsKey(id)) {
      mValue = dataModifiedInvalid[id];
      isValidZone = false;
    }
    dynamic originalValue = getValueOriginal(name, colId, id);

    //找到修改值
    if (!isNull(mValue) && !isNull(mValue[colId])) {
      //修改值未改变，退出
      if (mValue[colId] == value) {
        return;
      }

      //新值与原值相同，删除修改值，退出
      if (!isNull(originalValue) && !isNull(value) && originalValue == value) {
        mValue.remove(colId);
        if (mValue.length < 1) {
          dataModified.remove(id);
        }
        return;
      }
      //更新
      mValue[colId] = value;
      if (isItemValid) {
        //如值值合法，却在非法区，移到合法区
        if (!isValidZone) {
          moveItemBetweenMaps(id, dataModifiedInvalid, dataModified);
        }
      } else {
        //如值值非法，却在合法区，移到非法区
        if (isValidZone) {
          moveItemBetweenMaps(id, dataModified, dataModifiedInvalid);
        }
      }
    } else {
      //修改值与源值同，退出
      if (!isNull(originalValue) && !isNull(value) && originalValue == value) {
        return;
      }
      //添加修改值
      if (isItemValid) {
        if (isNull(dataModified[id])) {
          dataModified[id] = {};
        }
        dataModified[id][colId] = value;
      } else {
        if (isNull(dataModifiedInvalid[id])) {
          dataModifiedInvalid[id] = {};
        }
        dataModifiedInvalid[id][colId] = value;
      }
    }
  }

  setTreeNode(data, context) {}

  showFormEdit(data, context) {
    clearMFocusNode(context);
    var tableName = data[gActionid] ?? data[gTableID];
    dynamic formDefine = _formLists[tableName];
    Map<dynamic, dynamic> items = formDefine[gItems];
    dynamic dataRow = data[gRow];
    items.entries.forEach((itemOne) {
      Map item = itemOne.value;
      //item[gShowDetail] = false;

      item[gValue] = (dataRow == null) ? null : dataRow[item[gId]];
      //item[gTxtEditingController]..text = (dataRow == null) ? null : dataRow[item[gId]].toString();
    });
  }

  showFormTableEdit(data, context) {
    var tableName = data[gActionid] ?? data[gTableID];
    dynamic dataRow = data[gRow];
    showFormTableEditTableID(context, tableName, dataRow);
  }

  showFormTableEditTableID(context, tableName, dataRow) {
    dynamic dataRowModified =
        _tableList[tableName]![gDataModified][dataRow[gId]];
    dynamic formDefine = _formLists[tableName];
    Map<dynamic, dynamic> items = formDefine[gItems];

    items.entries.forEach((itemOne) {
      Map item = itemOne.value;
      var colId = item[gId];
      item[gValue] = isNull(dataRowModified[colId])
          ? dataRow[colId]
          : dataRowModified[colId];
    });
  }

  showMsg(context, dynamic result, backcolor) {
    if (result.toString().indexOf(gAction) == 0) {
/*List actions = [];
    actions.add({
      gType: gIcon,
      gValue: 0xef49,
      gLabel: gConfirm,
      gAction: gLocalAction,
      gItem: item,
      gTypeOwner: typeOwner,
      gName: name,
      gId: id,
    });
    Widget w = await getItemSubWidget(
        item, typeOwner, name, context, id, backcolor, actions);

    //}
    showPopup(context, w, null, actions, false);*/
      return;
    }
    if (backcolor == null) {
      backcolor = Colors.black.value;
    }
    Widget w = MyLabel({
      gLabel: result.toString(),
    }, backcolor);
    showPopup(context, w, null, null, false);
  }

  showMyDetail(param, msg, context, backcolor) {
    Map<dynamic, dynamic> focusNodeClone =
        new Map<dynamic, dynamic>.of(_mFocusNode);

    _myDetailID = _myDetailID + 1;
    int lastDetailID = _myDetailIDCurrent;
    _myDetailIDCurrent = _myDetailID;
    navigatorPush(
        context,
        MyDetail(param, backcolor, focusNodeClone, _myDetailID, lastDetailID),
        msg);
  }

  showPDF(actionData, context) async {
    dynamic filename = '';
    dynamic subject = '';
    for (int i = 0; i < actionData.length; i++) {
      Map<dynamic, dynamic> ai = Map.of(actionData[i]);
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
    } finally {}

    //sendRequestOne(gFiledownload, {gFilename: filename}, context);
  }

  showPopupBasic(context, Widget w) {
    /*Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);*/
    int backcolor = Colors.white.value;
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
                  ),
                  Divider(),
                  Container(
                    constraints: BoxConstraints(maxHeight: _scrollHeight),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: w,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showAlertDialog(BuildContext context, title, msg, requestFirst) {
    int backcolor = Colors.white.value;
    int frontcolor = Colors.black.value;
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: MyLabel({gLabel: gCancel}, frontcolor),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: MyLabel({gLabel: gContinue}, frontcolor),
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

  showPopup(context, w, h, actions, needSearch) {
    removeOverlay();
    overlayEntry = OverlayEntry(builder: (BuildContext context) {
      print('===== showPopup actions is ' + actions.toString());
      return MyPopup(
          {gWidget: w, gHeight: h, gActions: actions, gSearch: needSearch});
      /*return new Positioned(
          top: MediaQuery.of(context).size.height * 0.7,
          child: buildDraggable(context, MyPopup({gWidget: w, gHeight: h})));*/
    });
    Overlay.of(context).insert(overlayEntry!);
    myNotifyListeners();
  }

  showPopupItem(
      item, typeOwner, name, value, id, backcolor, context, needSearch) async {
    if (overlayEntry != null) {
      return;
    }

    List actions = [];
    actions.add({
      gType: gIcon,
      gValue: 0xef49,
      gLabel: gConfirm,
      gAction: gLocalAction,
      gItem: item,
      gTypeOwner: typeOwner,
      gName: name,
      gId: id,
    });
    Widget w = await getItemSubWidget(
        item, typeOwner, name, context, id, backcolor, actions);

    //}
    showPopup(context, w, null, actions, needSearch);
    //}
  }

  showScreenPage(actionData, context, backcolor) {
    for (int i = 0; i < actionData.length; i++) {
      Map<dynamic, dynamic> ai = actionData[i];
      dynamic name = '';
      dynamic type = '';
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
      Map map = Map.of(data);
      _screenLists[name] = Map.fromEntries(map.entries.toList()
        ..sort(
            (e1, e2) => getInt(e1.key.toString()) - getInt(e2.key.toString())));

      if (type == gScreen) {
        //print('============ showScreenPage name is ' + name.toString());
        //navigatorPush(context, FirstScreen(), 'showScreenPage');

        if (name == gFirstPage) {
          //_firstFormName = name;

          _firstPage = new FirstPage();
          //_firstPage = new FirstScreen();
        } else {
          if (name == gLogin) {
            //print('=========showScreenPage ' + name);
            clear(context);
          }
          //print('========= showScreenPage MyDeailNew ');

          showMyDetail(_screenLists[name], gShowScreenPage, context, backcolor);
        }
      } else {
        showScreenPageOne(name, context, backcolor, map);
      }
    }
    myNotifyListeners();
  }

  showScreenPageOne(name, context, backcolor, data) {
    MyScreen aScreen = MyScreen(_screenLists[name], backcolor);
    Map param = {gLabel: name, gScreen: aScreen, gData: data};

    showMyDetail(param, 'showScreenPageOne', context, backcolor);
  }

  showTab(label, context, tabName) {
    for (int i = 0; i < _tabList[tabName][gData].length; i++) {
      if (_tabList[tabName][gData][i][gLabel] == label) {
        _tabList[tabName][gData][i][gVisible] = true;
        if (_tabList[tabName][gTabIndex] != i) {
          _tabList[tabName][gTabIndex] = i;
        }
        clearMFocusNode(context);
        myNotifyListeners();
        return true;
      }
    }
    _tabList[tabName][gTabIndex] = 0;
    return false;
  }

  showTable(
      dynamic tableid, context, title, transpass, backcolor, other, where) {
    if (_tableList[tableid] == null) {
      retrieveTableFromDB(tableid, context);
    } else {
      showMyDetail(
          getTableBodyParam(
              {gTableID: tableid, gOther: other, gWhere: where}, context),
          'showTable',
          context,
          backcolor);

      if (strSubexists(transpass, gPopupnew)) {
        Map param = {
          gTableID: tableid,
          gType: gTable,
          gLabel: title,
          gTranspass: transpass,
          gWhere: where
        };
        //trigger add new
        newForm(param, context);
        showTableForm(param, context, backcolor);
      }
    }
  }

  showTableForm(data, context, backcolor) {
    //int index = data[gRow] ?? -1;
    var tableName = data[gActionid] ?? data[gTableID];

    var keyValue = getTableValueKey(tableName, data[gRow]);
    var id = '';
    if (data[gRow] != null) {
      id = data[gRow][gId] ?? '';
    }
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
            gItem: jsonEncode(
                {gType: gForm, gValue: tableName, gId: id, gTypeOwner: gTable})
          }
        }
      }
    ];

    showScreenPage(actionData, context, backcolor);
  }

  sms(sNum) {
    final anUri = Uri.parse('sms:' + sNum);
    _launch(anUri);
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

  tableInsert(tablename, rowData, context) {
    var tableInfo = _tableList[tablename];
    List tableData = tableInfo![gData];
    Map row = Map.of(rowData);
    tableData.insert(0, row);
    removeTableModified(tablename, row[gId]);
    if (_dpList.containsKey(tablename)) {
      dpListInsert(tablename, row, context);
    }
    afterTableInsert(tablename, row, context);
  }

  tableRemove(tablename, rowData, context) {
    var tableInfo = _tableList[tablename];
    List tableData = tableInfo![gData];
    Map row = Map.of(rowData);
    removeTableModified(tablename, row[gId]);
    tableData.removeWhere((element1) => element1[gId] == row[gId]);

    if (_dpList.containsKey(tablename)) {
      dpListRemove(tablename, row, context);
    }

    //myNotifyListeners();
  }

  toExcel(data, context) {
    toFile(data, context, 'excel');
  }

  tableSort(tableName, columnIndex, ascending, context) {
    //List data = tableList[tableName][gData];
    clearMFocusNode(context);
    clearTable(tableName);
    dynamic tableInfo = tableList[tableName];
    dynamic data = tableInfo[gData];
    if (data == null || data.length < 2) {
      return;
    }
    int dataColumnIndex = 0;
    List columns = tableList[tableName]![gColumns];
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
    tableList[tableName]![gAscending] = ascending;
    tableList[tableName]![gSortColumnIndex] = columnIndex;
  }

  tableSortCompare(a, b, columns, colindex, ascending, context) {
    dynamic inputType = columns[colindex][gInputType];
    var valueA =
        getTableCellValueFromDataRowIsRaw(a, columns, colindex, context, true);
    var valueB =
        getTableCellValueFromDataRowIsRaw(b, columns, colindex, context, true);

    if (ascending) {
      if (inputType == gDatetime) {
        return valueA - valueB;
      } else {
        //data.sort((a, b) => a[colName].compareTo(b[colName]));
        var result =
            valueA.toString().trim().compareTo(valueB.toString().trim());
        return result;
      }
    } else {
      if (inputType == gDatetime) {
        return valueB - valueA;
      } else {
        //data.sort((a, b) => a[colName].compareTo(b[colName]));
        var result = valueB.compareTo(valueA);
        return result;
      }
    }
  }

  textChange(text, Map item, BuildContext context, typeOwner, name, id) {
    if (item[gType] != gSearch) {
      //if (!isNullID(id) || (typeOwner == gForm && item[gType] != gSearch)) {
      //setTableValueItem(name, item[gId], id, text);
      setValue(name, item[gId], id, text);

      /*if ((typeOwner ?? '') == gForm) {
        bool canEdit = false,
            canDelete = true,
            hasDetail = false,
            isNotLog = false,
            canCancel = true;
        getTableFloatingBtnsDetail(
            name, context, canEdit, canDelete, hasDetail, isNotLog, canCancel);
      } else {
        getTableFloatingBtns(name, context);
      }*/
      return;
    }
    if ((typeOwner ?? '') == gDroplist) {
      dynamic dpid = name;
      _dpListSearch[dpid] = text;
      //myNotifyListeners();
      return;
    }
    if (item[gDroplist] == '') {
      item[gValue] = text;
    }
    item[gSearch] = text;
    if (item[gType] == gAddress) {
      return;
    }
    if ((item[gAction] ?? '') == '') {
      return;
    }

    sendRequestOne(item[gAction], item, item[gContext] ?? context);
  }

  toFile(data, context, label) {
    dynamic tableName = data[gTableID];
    List header = [];
    List body = [];

    dynamic tableInfo = _tableList[tableName];

    //tableInfo.[gData].length;
    //List tableData = tableInfo[gData];
    List columns = tableInfo[gColumns];
    dynamic subject = tableInfo[gAttr][gLabel] ?? '';

    for (int i = 0; i < columns.length; i++) {
      if (isHiddenColumn(columns, i)) {
        continue;
      }

      header.add(getSCurrentLan(columns[i][gLabel], 'en'));
    }

    List newData = getTableData(tableName);

    for (int i = 0; i < newData.length; i++) {
      Map dataRow = newData[i];
      //get updated value
      dynamic ti = getTableRowShowValueFilterMapOrList(
          tableName, dataRow, columns, context, '', false);
      if (ti != null) {
        body.add(ti);
      }
    }

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

  toPdf(data, context) {
    toFile(data, context, 'pdf');
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

  toLocalTime(atime) {
    try {
      DateTime dt =
          DateTime.fromMillisecondsSinceEpoch(getInt(atime)).toLocal();
      dynamic formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
      return formattedDate;
    } catch (e) {
      return "";
    }
  }

  wait(waitSeconds) async {
    await Future.delayed(Duration(seconds: waitSeconds));
  }

  waitDialog(context) {
    isProcessing = true;

    //showMsg(context, "Loading...", Colors.white.value);
  }

  waitDialogClose(context) {
    isProcessing = false;
    //removeOverlay();
  }

  waitmilliseconds(waitMilliSeconds) async {
    await Future.delayed(Duration(milliseconds: waitMilliSeconds));
  }
}

class Debouncer {
  int milliseconds;
  VoidCallback action;
  Timer? _timer;

  Debouncer({required this.milliseconds, required this.action});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class InternationalPhoneFormatter extends TextInputFormatter {
  InternationalPhoneFormatter();
  String internationalPhoneFormat(value) {
    return DataModel.getFormatter(value, gPhone);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    return newValue.copyWith(
        text: internationalPhoneFormat(text),
        selection: new TextSelection.collapsed(
            offset: internationalPhoneFormat(text).length));
  }
}

class DateFormatter extends TextInputFormatter {
  DateFormatter();
  String dateFormatter(value) {
    return DataModel.getFormatter(value, gDate);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    /*if (newValue.selection.baseOffset == 0) {
      return newValue;
    }*/

    return newValue.copyWith(
        text: dateFormatter(text),
        selection:
            new TextSelection.collapsed(offset: dateFormatter(text).length));
  }
}

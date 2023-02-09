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
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_treeview/flutter_treeview.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/pdfScreen.dart';

class DataModel extends ChangeNotifier {
  //dynamic _email;
  dynamic _token = '';
  dynamic _myId = '';
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

  //'https://ipt.imgix.net/201444/x/0/?auto=format%2Ccompress&crop=faces%2Cedges%2Ccenter&bg=%23fff&fit=crop&q=35&h=944&dpr=1'
  Map get imgList => _imgList;
  Map get imgCache => _imgCache;
  Map<dynamic, dynamic> _i10nMap = {};
  Queue _requestList = new Queue();
  Queue _requestListRunning = new Queue();
  //dynamic get email => _email;
  dynamic get token => _token;
  Map<dynamic, Map<dynamic, dynamic>> get formLists => _formLists;
  Map<dynamic, dynamic> get actionLists => _actionLists;
  Map<dynamic, dynamic> get menuLists => _menuLists;
  Map<dynamic, dynamic> get screenLists => _screenLists;

  Map<dynamic, Map<dynamic, dynamic>> get tableList => _tableList;
  Map<dynamic, dynamic> get tabList => _tabList;
  Map<dynamic, dynamic> get dpList => _dpList;
  Map<dynamic, dynamic> get whereList => _whereList;

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

  addTabSub(data, tabName) {
    _tabList[tabName][gData].add(
        {gLabel: data[gLabel], gType: data[gType], gActionid: data[gActionid]});
    _tabList[tabName][gTabIndex] = _tabList[tabName][gData].length - 1;
  }

  addToList(List sizeList, aValue) {
    int listLength = sizeList.length;
    List maxList = sizeList[listLength - 1].toString().split('~');
    List minList = sizeList[0].toString().split('~');
    int iMax =
        maxList.length > 1 ? int.parse(maxList[1]) : int.parse(maxList[0]);
    int iMin = int.parse(minList[0]);

    List resultList = [];
    List aValueList = aValue.toString().split('~');
    int iLeft = int.parse(aValueList[0]);
    int iRight = int.parse(aValueList[1]);
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
        List tableData = tableInfo[gData];
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
        List tableData = tableInfo[gData];
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
        tableInfo[gTimestamp] = timestamp;
        //tableData.removeWhere((element1) => element1[gId] == rowData[gId]);
        tableRemove(tablename, rowData, context);
      });
    }
  }

  afterTableInsert(tablename, row, context) {
    if (tablename == gZzyi10nitem) {
      var parentid = row[gParentid];
      var tableid = gZzyi10nlist;
      var result = getTableByTableID(tableid, gId + '=' + parentid, context);
      var langcode = row[gLangcode];
      var langcontent = row[gLangcontent];
      var sourceChck = result[0][gName];
      _i10nMap[sourceChck][langcode] = langcontent;
    }
  }

  tableInsert(tablename, rowData, context) {
    var tableInfo = _tableList[tablename];
    List tableData = tableInfo[gData];
    Map row = Map.of(rowData);
    tableData.insert(0, row);
    if (_dpList.containsKey(tablename)) {
      dpListInsert(tablename, row, context);
    }
    afterTableInsert(tablename, row, context);
  }

  tableRemove(tablename, rowData, context) {
    var tableInfo = _tableList[tablename];
    List tableData = tableInfo[gData];
    Map row = Map.of(rowData);
    tableData.removeWhere((element1) => element1[gId] == row[gId]);

    if (_dpList.containsKey(tablename)) {
      dpListRemove(tablename, row, context);
    }
  }

  dpListRemove(tablename, row, context) {
    _dpList[tablename].removeWhere((element1) => element1[gId] == row[gId]);
    _i10nMap.removeWhere((key, value) => key == row[gId]);
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

  addTable(data, context) {
    if (data[gBody] != null && data[gBody][gZzylog] != null) {
      addZzylog(Map.of(data[gBody][gZzylog]), context);
      return;
    }
    var isNew = false;
    if (_tableList[data[gActionid]] == null ||
        _tableList[data[gActionid]][gAttr][gLogmerge] != 'Y') {
      isNew = true;
    }
    if (isNew) {
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
      if (_tableList[data[gActionid]][gAttr][gOrderby] != null) {
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
        }
      }
    }

    _tableList[data[gActionid]][gTableID] = data[gActionid];

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
    if (data[gLabel] == gDroplist) {
      //add to droplist
      List tableData = _tableList[data[gActionid]][gData];
      if (tableData.length > 0) {
        tableData.forEach((element) {
          dpListInsert(data[gActionid], element, context);
        });
      }
    }
  }

  setDroplist() {
    Map tabledata = _tableList[gZzydictionary];
    List tabledataList = tabledata[gData];
    Map tabledataItem = _tableList[gZzydictionaryitem];
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
  afterSubmit(context, _formName, result) {
    Map<dynamic, dynamic> formDefine = _formLists[_formName];
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
    setFormValue(gLogin, gEmail, '');
    setFormValue(gLogin, gPassword, '');
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

  Future downloadFile(filename, context, needRemove, subject) async {
    dynamic filePath = '';

    try {
      dynamic myUrl = 'http://' +
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
        dynamic tempPath = dir.path;
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

  downloadAddress(searchTxt, context, haveNext) async {
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

  Future downloadAddressDetail(param, context) async {
    List result = [];
    try {
      dynamic myUrl = MyConfig.URLAddress.name + param;

      //Uri uri = new Uri.http(MyConfig.URL.name,MyConfig.DOWNLOAD.name + '?filename=$filename' + filename);
      Response response = (await httpClient.get(Uri.parse(myUrl)));
      //var response = await request;
      if (response.statusCode == 200) {
        Utf8Decoder decode = new Utf8Decoder();
        Map data = Map.of(jsonDecode(decode.convert(response.bodyBytes)));
        if (data == null) {
          return;
        }
        List itemList = data["Items"];
        if (itemList.length < 1) {
          return;
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
    Navigator.pop(context);
  }

  Widget firstWidget(context) {
    if (_sessionkey == '') {
      _requestCnt = 0;
      resetSessionKey(context);
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
    var email = getFormValue(gLogin, gEmail, gTxtEditingController);
    if (email != null && email.length > 0) {
      this.sendRequestOne(gForgetpassword, email, context);
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
        } else if (objI[gType] == gHidden) {
        } else if (objI[gDbid] != null && objI[gDbid] != '') {
          var value = objI[gValue];
          //data[objI[gDbid]] = value;
          if (objI[gHash] != null && objI[gHash]) {
            value = hash(value);
          }
          if (type == gDate && !isNull(value)) {
            //value = value.format(gDateformat);
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
        obj.entries.forEach((MapEntry<dynamic, dynamic> element) {
          //var key = element.entries.first.key;
          var objI = element.value;
          if (objI[gId] != '' &&
              //objI[gIsPrimary] != null &&
              //objI[gIsPrimary] &&
              (isNull(data[objI[gId]])) &&
              isNull(objI[gOldvalue]) &&
              !isNull(objI[gDefaultValue])) {
            data[objI[gId]] = objI[gDefaultValue];
          }
        });
        //send request;
        sendRequestFormChange(data, context); //refresh Form

        return;
      }
      alert(context, gNochange);
    } catch (e) {
      //print('======exception is ' + e.toString());
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

  static Color fromInt(dynamic strColor) {
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

  getMapSortByKey(Map map, bool isAsc) {
    final sortedKeys = SplayTreeMap.from(
        map,
        (keys1, keys2) =>
            isAsc ? keys1.compareTo(keys2) : keys2.compareTo(keys1));
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

  getDataWhere(List newData, aWhere) {
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
  }

  setDplistDay(sYear, sMonth) {
    if (sYear == '' || sMonth == '') {
      _dpList[gDay] = [];
      return;
    }
    if (sMonth == '01' ||
        sMonth == '03' ||
        sMonth == '05' ||
        sMonth == '07' ||
        sMonth == '08' ||
        sMonth == '10' ||
        sMonth == '12') {
      _dpList[gDay] = _dpList[gDay31];
      return;
    }
    if (sMonth == '04' || sMonth == '06' || sMonth == '09' || sMonth == '11') {
      _dpList[gDay] = _dpList[gDay30];
      return;
    }
    int iYear = int.parse(sYear);
    if (iYear % 4 == 0) {
      _dpList[gDay] = _dpList[gDay29];
      return;
    }
    _dpList[gDay] = _dpList[gDay28];
    return;
  }

  setDplistYear() {
    if ((_dpList[gYear] ?? []).length < 1) {
      int iYear = new DateTime.now().year;
      int iYearMiddle = iYear - 49;
      List result = [];
      result.add((iYear - 100).toString() + '~' + (iYearMiddle - 1).toString());
      result.add(iYearMiddle.toString());
      result.add((iYearMiddle + 1).toString() + '~' + (iYear + 2).toString());

      _dpList[gYear] = result;
      List resultMonth = [];
      List resultDay28 = [];
      List resultDay29 = [];
      List resultDay30 = [];
      List resultDay31 = [];
      for (int i = 1; i < 10; i++) {
        resultMonth.add('0' + i.toString());
        resultDay28.add('0' + i.toString());
        resultDay29.add('0' + i.toString());
        resultDay30.add('0' + i.toString());
        resultDay31.add('0' + i.toString());
      }
      for (int i = 10; i < 13; i++) {
        resultMonth.add(i.toString());
      }
      _dpList[gMonth] = resultMonth;

      for (int i = 10; i < 29; i++) {
        resultDay28.add(i.toString());
        resultDay29.add(i.toString());
        resultDay30.add(i.toString());
        resultDay31.add(i.toString());
      }
      resultDay29.add('29');
      resultDay30.add('29');
      resultDay31.add('29');
      resultDay30.add('30');
      resultDay31.add('30');
      resultDay31.add('31');
      _dpList[gDay28] = resultDay28;
      _dpList[gDay29] = resultDay29;
      _dpList[gDay30] = resultDay30;
      _dpList[gDay31] = resultDay31;
    }
  }

  getDatePickerItems(
      sizeList, sList, backcolor, selectedIndex, context, formname, id) {
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
                }, backcolor),
                onTap: () {
                  if (list[j].indexOf('~') > 0) {
                    _dpList[sList[i]] = addToList(list, list[j]);
                    myNotifyListeners();

                    return;
                  }
                  var data = getFormValue(formname, id, gTxtEditingController);
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
                        int iYear = int.parse(dateList[0]);
                        if (iYear % 4 > 0) {
                          dateList[2] = '';
                        }
                      }
                    }
                  }
                  setFormValue(formname, id,
                      dateList[0] + '-' + dateList[1] + '-' + dateList[2]);
                  if (dateList[2] != '') {
                    //close the detail
                    setFormValueShow(formname, id);
                    setFormNextFocus(formname, id);

                    myNotifyListeners();
                    return;
                  }
                  setDplistDay(dateList[0], dateList[1]);

                  myNotifyListeners();
                  //setItemI(item, anItem, datamodel);
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

  getDatePicker(aDate, backcolor, context, formname, id) {
    if (isNull(aDate)) {
      aDate = '';
      /*var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      aDate = formatter.format(now);*/
    }
    setDplistYear();
    /*List controller = [
      ScrollController(),
      ScrollController(),
      ScrollController()
    ];*/
    List selectedIndex = [-1, -1, -1];
    List sizeList = [200.0, 40.0, 40.0];
    List sList = [gYear, gMonth, gDay];
    for (int i = 0; i < sList.length; i++) {}
    List sListValue = aDate.split('-');
    if (sListValue.length < 2) {
      sListValue.add('');
    }
    if (sListValue.length < 3) {
      sListValue.add('');
    }
    setDplistDay(sListValue[0], sListValue[1]);
    for (int j = 0; j < sList.length; j++) {
      for (int i = 0; i < _dpList[sList[j]].length; i++) {
        if (_dpList[sList[j]][i] == sListValue[j]) {
          selectedIndex[j] = i;
          break;
        }
      }
    }

    Widget result = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //spacing: 20.0, //gap between adjacent items
        //runSpacing: 4.0, //gap between lines
        //direction: Axis.horizontal,
        //children: getDatePickerItems(controller, sizeList, sList, backcolor,
        //  selectedIndex, context)));
        children: getDatePickerItems(
            sizeList, sList, backcolor, selectedIndex, context, formname, id));

    //_debouncer.run(() => getDatePickerAfter(controller, selectedIndex, sList));
    return result;
  }

  getDPPicker(item, backcolor, context, formname, id) {
    List sList =
        getDpListByKey(item.value[gDroplist], context, item.value[gValue]);
    int selectedIndex = -1;
    for (int i = 0; i < sList.length; i++) {
      if (sList[i] == item.value[gValue]) {
        selectedIndex = i;
        break;
      }
    }

    Widget result = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //spacing: 20.0, //gap between adjacent items
        //runSpacing: 4.0, //gap between lines
        //direction: Axis.horizontal,
        //children: getDatePickerItems(controller, sizeList, sList, backcolor,
        //  selectedIndex, context)));
        children: getDPPickerItems(
            sList, backcolor, selectedIndex, context, formname, id));

    //_debouncer.run(() => getDatePickerAfter(controller, selectedIndex, sList));
    return result;
  }

  getDPPickerItems(list, backcolor, selectedIndex, context, formname, id) {
    List<Widget> result = [];

    List<Widget> subList = [];
    result.add(Text(''));
    for (int j = 0; j < list.length; j++) {
      bool isSelected = false;
      if (selectedIndex > -1 && selectedIndex == j) {
        isSelected = true;
      }
      subList.add(isSelected
          ? MyLabel({
              gLabel: list[j],
            }, Colors.white.value)
          : InkWell(
              child: MyLabel({
                gLabel: list[j],
              }, backcolor),
              onTap: () {
                setFormValue(formname, id, list[j]);
                //close the detail
                setFormValueShow(formname, id);
                setFormNextFocus(formname, id);
                myNotifyListeners();
              },
            ));
    }
    result.add(Wrap(
        spacing: 10.0, //gap between adjacent items
        runSpacing: 20.0, //gap between lines
        direction: Axis.horizontal,
        children: subList));

    return result;
  }

  /*getDatePickerAfter(List controller, selectedIndex, sList) {
    for (int i = 0; i < controller.length; i++) {
      int itemLength = _dpList[sList[i]].length;
      double contentSize = controller[i].position.viewportDimension +
          controller[i].position.maxScrollExtent;
      final target = contentSize * selectedIndex[i] / itemLength;
      controller[i].position.animateTo(
            target,
            duration: const Duration(milliseconds: 1),
            curve: Curves.easeInOut,
          );
    }
  }*/

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

  /*getDropdownMenuItem(dpid, filterStr, context, backcolor) {
    if (_dpList[dpid] != null) {
      return;
      // dplist exists
    }

    getTableByTableID(gZzydictionary, gLabel + "='" + dpid + "'", context);
  }*/
  getDpListByKey(key, context, value) {
    List result = [];
    if (_dpList.containsKey(key)) {
      result = _dpList[key];
    }
    if (result.length < 1) {
      result.add(value);
    }

    return result;
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
    Map<dynamic, dynamic> formDetail = _formLists[formid];
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

  getInputType(s) {
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

  getMyBody(name) {
    if (name == gMain) {
      if (initRequest == '') {
        List objList = [];
        objList.add({gType: gTab, gData: name});
      }
    }
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
    dynamic source0 = sourceOriginal + "";
    dynamic sourceLocase = source0.toLowerCase();
    dynamic source = sourceLocase;
    dynamic sourceChck = source;
    if (sourceChck.indexOf("{") > 0) {
      sourceChck = sourceChck.substring(0, sourceChck.indexOf("{"));
    }
    if (_i10nMap[sourceChck] != null) {
      dynamic result = _i10nMap[sourceChck][lancode];
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
  }

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
        result += str.length;
      }
    });
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
      //dynamic tableName = data[gActionid];
      data[gTabName] = tabname;
      return getTableBody(data, context, backcolor);
    } else if (data[gType] == gTabletree) {
      //dynamic tableName = data[gActionid];
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

    if (isNull(where)) {
      return tableData[gData];
    }

    return getTableDataFromWhere(tableData, where);
  }

  getTableDataFromWhere(tableData, where) {
    //filter the table data by where condition
    Map mapWhere = {};
    List whereList = where.toString().split(' and ');
    for (int i = 0; i < whereList.length; i++) {
      List keyValue = whereList[i].toString().split('=');
      mapWhere[keyValue[0]] = keyValue[1];
    }
    List result = [];
    if (tableData != null) {
      tableData[gData].forEach((dataRow) {
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

  getTableItemByName(tableInfo, itemName, value) {
    value = '';
    TextEditingController searchController = TextEditingController(text: value);
    /*TextEditingController searchController = TextEditingController.fromValue(
        TextEditingValue(
            text: value,
            selection: TextSelection.fromPosition(TextPosition(
                affinity: TextAffinity.downstream, offset: value.length))));*/

    MapEntry item = MapEntry(itemName, {
      gWidth: 150.0,
      gType: itemName,
      gLabel: itemName,
      gFocus: true,
      gValue: value,
      gInputType: itemName,
      gTxtEditingController: searchController
    });

    return item;
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
    dynamic tableName = data[gActionid] ?? data[gTableID];
    //dynamic tableName = _param[gData][gActionid] ?? _param[gData][gTableID];

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
      detail.add(
          {gLabel: gAddnew, gTableID: tableName, gWidth: 100, gData: data});
    }
    detail.add({gLabel: gPdf, gTableID: tableName, gWidth: 60, gData: data});
    detail.add({gLabel: gExcel, gTableID: tableName, gWidth: 60, gData: data});
    param[index++] = {
      gItem: jsonEncode(
          {gType: gBtns, gAction: gTable, gValue: tableName, gItems: detail})
    };

    param[index++] = {
      gItem: jsonEncode({gType: gTableEditor, gName: tableName, gOther: data})
    };
    return param;
  }

  getTableValue(row, colid) {
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
        return int.parse("$result");
      }
    }
    if (isRaw) {
      return result;
    }
    return getValueByType(result, col);
    //return result;
  }

  getValueByType(result, col) {
    dynamic inputType = col[gInputType];
    if (inputType == gDatetime) {
      return toLocalTime(result);
    }
    if (!isNull(col[gDroplist])) {
      return getSCurrent(result);
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
      var colIndex = i;
      //if (!isNull(item[ci[gId]])) {
      var oneValue =
          getTableCellValueFromDataRow(item, colList, colIndex, context) ?? '';
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
      bool isKeyword = element[gIsKeyword] ?? false;
      if (isKeyword) {
        var value = dataRow[element[gId]];
        if (!isNull(value)) {
          result += sep + value;
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
    dynamic formID = param[gFormdetail][gFormName];

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
      DateTime dt = DateTime.fromMillisecondsSinceEpoch(atime).toLocal();
      dynamic formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
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
    } else if (!isNull(data[gType]) && data[gType] == gAddress) {
      searchAddress(data, context);
    } else if (!isNull(data[gAction1])) {
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

  phonecall(sNum) {
    String nums = sNum.replaceAll(RegExp(r'[\D]'), '');
    final anUri = Uri.parse('tel:' + nums);
    _launch(anUri);
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

  sms(sNum) {
    final anUri = Uri.parse('sms:' + sNum);
    _launch(anUri);
  }

  pickFiles() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return result;
    }
    PlatformFile file = result.files.first;
    return file;
  }

  loadFile(formname, item) async {
    PlatformFile file = await pickFiles();
    var filename = file.name;
    dynamic myUrl = 'http://' + MyConfig.URL.name + '/' + MyConfig.UPLOAD.name;
    var request = http.MultipartRequest('POST', Uri.parse(myUrl));
    request.fields['param0'] = filename;
    request.fields['param1'] = _globalCompanyid;
    /*http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath("image", file.name);*/
    request.files.add(http.MultipartFile.fromBytes(_globalCompanyid, file.bytes,
        filename: filename));
    //upload file
    var res = await request.send();
    if (res.statusCode == 200) {
      setFormValue(formname, item.value[gId], filename);
      myNotifyListeners();
    }
  }

  loadUrl(url) {
    final anUri = Uri.parse(url);
    _launch(anUri);
  }

  void _launch(url) async {
    if (url != null) {
      await launchUrl(url);
    }
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
          /*} else if (action == gSetFormDefaultValue) {
          await setFormDefaultValue(actionData);*/
        } else if (action == gSetI10n) {
          await setI10n(actionData);
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
          await setFormList(actionData);
        } else if (action == gShowTable) {
          await showTable(actionData[0][gTableID], context,
              actionData[0][gLabel] ?? "", "", "", null, null);
        } else if (action == gSetDroplist) {
          await setDroplist();
        }
      });
    } catch (e) {
      throw e;
    }
  }

  processTab(List data, context) {
    data.forEach((element) {
      Map data0 = Map.of(element);
      if (data0[gType].toString().endsWith(gTable) ||
          data0[gType] == gTabletree) {
        addTable(data0, context);
        if (data0[gWhere] != null && data0[gWhere].indexOf("=") > 0) {
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
    });

    //myNotifyListeners();
  }

  processTap(context, element, tabName) {
    processTapBasic(context, element, tabName, false);
  }

  changeTabPos(tabName, tabLabel) {
    List tabData = _tabList[tabName][gData];
    int iLoc = 0;
    Map mLoc;
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
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    myNotifyListeners();
  }

  removeLastScreens(context) {
    Navigator.of(context).pop();

    myNotifyListeners();
  }

  requestListadd(data) {
    requestListaddCommon(data, false);
  }

  requestListaddCommon(data, isFirst) {
    if (data == null) {
      return;
    }

    /*bool dataExists = requestListExists(data);
    print('--------- requestList dataExists: ' +
        dataExists.toString() +
        ': ' +
        data.toString());
    if (dataExists) {
      return;
    }*/
    //print('--------- requestList add ' + data.toString());
    if (isFirst) {
      _requestList.addFirst(data);
    } else {
      _requestList.add(data);
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
    int length = _requestList
        .where((element) => element.toString() == item.toString())
        .length;
    bool exists = length > 0;

    /*print('------- request exists: ' +
        exists.toString() +
        ' [' +
        length.toString() +
        '] ' +
        item.toString());*/
    return exists;
    /*String sItem = item.toString();
    //print('--------------- requestListExists sItem' + sItem);
    if (_requestList != null) {
      _requestList.forEach((value) {
        String sValue = value.toString();
        //print('--------------- requestListExists sValue: ' + sValue);
        if (sItem == sValue) {
          //print('--------------- requestListExists is true:' + sValue);
          return true;
        }
        /*var objIaction = value[gAction];
        if (objIaction == item[gAction]) {
          var objIDataStr = value[gData].toString();
          var dataStr = item[gData].toString();
          if (objIDataStr == dataStr) {
            //duplicated, return
            // ignore: void_checks

            return true;
          }
        }*/
      });
    }

    return false;*/
  }

  requestListRemove(requestFirst) {
    _requestList.removeWhere(
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

  saveTableOne(data0, context) {
    //formid = data0[gFormid];
    var tablename = data0[gTableID];
    //List tableData = tableList[tablename][gData];

    if (data0[gActionid] == gTableAdd) {
      //tableData.insert(0, Map.of(data0[gBody]));
      finishme(context);
      tableInsert(tablename, data0[gBody], context);
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
      //var updateID = data0[gBody][gId];
      //tableData.removeWhere((element) => element[gId] == updateID);
      tableRemove(tablename, data0[gBody], context);
      //tableData.insert(0, Map.of(data0[gBody]));
      tableInsert(tablename, data0[gBody], context);
    } else if (data0[gActionid] == gTableDelete) {
      //var deletedID = data0[gBody][gId];
      //tableData.removeWhere((element) => element[gId] == deletedID);
      tableRemove(tablename, data0[gBody], context);
    }

    myNotifyListeners();
  }

  searchAddress(data, context) async {
    var searchTxt = data[gSearch];
    if ((searchTxt + "").length < 3) {
      return;
    }
    _dpList[gAddress + '_' + data[gFormName] + '_' + data[gId]] = [];
    //
    List result = await downloadAddress(searchTxt, context, false);
    List resultSort = getArrayMatch(result, searchTxt);
    _dpList[gAddress + '_' + data[gFormName] + '_' + data[gId]] = resultSort;
    //_dpList[gAddress + '_' + data[gFormName] + '_' + data[gId]] = result;
    myNotifyListeners();
  }

  searchTable(data, context) {
    var tableId = data[gTableID];
    var searchTxt = data[gSearch];
    _tableList[tableId][gSearch] = searchTxt;
    myNotifyListeners();
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
      if (_requestList.isEmpty) {
        return;
      }
      if (_requestList.length < 1) {
        return;
      }
      //while (_requestList.length > 0)
      for (int i = 0; i < _requestList.length; i++) {
        //Map requestFirst = _requestList.first;
        Map requestFirst = _requestList.elementAt(i);
        //Map requestFirst = _requestList.removeFirst();
        //print('----------request list remove ' + requestFirst.toString());

        if (_requestListRunning != null &&
            _requestListRunning
                    .where((element) =>
                        element.toString() == requestFirst.toString())
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
                timestamp = _tableList[tablename][gTimestamp];
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
    }
  }

  setDropdownMenuItem(_param, newValue, context, _formName) {
    setFormValueItem(_param, newValue);

    myNotifyListeners();
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

  setFormList(actionData) async {
    List<dynamic> thisList = actionData;
    for (int i = 0; i < thisList.length; i++) {
      Map<dynamic, dynamic> thisListI = thisList[i];
      var formID = thisListI[gFormName];
      await setFormListOne(formID, thisListI);
      if (formID == gVerifycode) {
        var email = getFormValue(gLogin, gEmail, gTxtEditingController);
        setFormValue(gVerifycode, gEmail, email);
        _myId = email;
      } else if (formID == gChangepassword) {
        var email = getFormValue(gLogin, gEmail, gTxtEditingController);
        setFormValue(gChangepassword, gEmail, email);
        _myId = email;
      }
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
    Map<dynamic, dynamic> formValue = Map.from(formDetail);

    Map<dynamic, dynamic> itemList = formValue[gItems];
    itemList.entries.forEach((elementItemList) {
      Map<dynamic, dynamic> valueItemList = elementItemList.value;

      //valueItemList[gInputType] = valueItemList[gInputType];
      valueItemList[gTxtEditingController] =
          TextEditingController(text: valueItemList[gDefaultValue]);
      valueItemList[gValue] = '';

      valueItemList[gOldvalue] = '';
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

    _formLists[formID] = formValue;
    if (formID == gLogin) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setFormValue(gLogin, gEmail, prefs.getString('myid') ?? '');
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

  setAddressForItem(oneAddress, item, context) {
    var address = oneAddress["Text"] + " " + oneAddress["Description"];
    setFormValueItem(item, address);
  }

  /*setFormDefaultValue(actionData) {
    for (int i = 0; i < actionData.length; i++) {
      Map<dynamic, dynamic> ai = actionData[i];
      dynamic formname = '';
      dynamic itemname = '';
      dynamic value = '';
      ai.entries.forEach((element) {
        if (element.key == gForm) {
          formname = element.value;
        } else if (element.key == gItem) {
          itemname = element.value;
        } else if (element.key == gValue) {
          value = element.value;
        }
      });
      if (_formLists[formname] != null) {
        _formLists[formname][gItems][itemname][gDefaultValue] = value;
      }
    }
  }*/

  showDropList(dpid, item, context) {}

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
    Map<dynamic, dynamic> formDefine = _formLists[tableName];
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
    items.entries.forEach((item) {
      item.value[gOldvalue] = null;
      if (mapWhereList.containsKey(item.value[gId])) {
        if (isNull(item.value[gDefaultValue]))
          item.value[gDefaultValue] = mapWhereList[item.value[gId]];
      }
      item.value[gValue] = item.value[gDefaultValue];
      item.value[gTxtEditingController]..text = item.value[gDefaultValue];
    });
  }

  showFormEdit(data, context) {
    var tableName = data[gActionid] ?? data[gTableID];
    Map<dynamic, dynamic> formDefine = _formLists[tableName];
    Map<dynamic, dynamic> items = formDefine[gItems];
    dynamic dataRow = data[gRow];
    items.entries.forEach((item) {
      item.value[gOldvalue] =
          (dataRow == null) ? null : dataRow[item.value[gId]];
      item.value[gShowDetail] = false;
      //if is address
      if (item.value[gType] == gAddress) {
        dpList[gAddress + '_' + tableName + '_' + item.value[gId]] = null;
      }

      item.value[gValue] = item.value[gOldvalue];
      item.value[gTxtEditingController]
        ..text = (dataRow == null) ? null : dataRow[item.value[gId]].toString();
    });
  }

  showTableForm(data, context, backcolor) {
    //int index = data[gRow] ?? -1;
    var tableName = data[gActionid] ?? data[gTableID];

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
      Map<dynamic, dynamic> ai = Map.of(actionData[i]);
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
        setFormFocusItem(item);
      });
    }
  }

  setFormFocusItem(item) {
    if ((item.value[gIsHidden] ?? "false") != gTrue &&
        (item.value[gType] ?? "") != gHidden) {
      bool isValueNull = isNull(item.value[gValue]);
      var txtValue = item.value[gTxtEditingController].value.text;
      bool isTxtNull = isNull(txtValue);
      if (isValueNull && isTxtNull) {
        item.value[gFocus] = true;
        return true;
      }
    }
    return false;
  }

  setFormNextFocus(formid, colId) {
    if (isNull(colId)) {
      return;
    }
    Map<dynamic, dynamic> items = _formLists[formid][gItems];
    items.entries.forEach((item) {
      item.value[gFocus] = false;
    });

    bool beginFocus = false;
    items.entries.forEach((item) {
      if (beginFocus) {
        if (setFormFocusItem(item)) {
          return;
        }
      }

      if (item.value[gId] == colId) {
        beginFocus = true;
      }
    });
  }

  setFormValue(formid, colId, value) {
    setFormValueItem(_formLists[formid][gItems][colId], value);
  }

  setFormValueItem(item, value) {
    item[gValue] = value;
    item[gTxtEditingController]..text = value;

    //
  }

  setFormValueShow(formid, colId) {
    var item = _formLists[formid][gItems][colId];
    setFormValueShowValue(formid, colId, !(item[gShowDetail] ?? false));
  }

  setFormValueShowValue(formid, colId, value) {
    var item = _formLists[formid][gItems][colId];
    item[gShowDetail] = value;
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

  setSessionkey(data) {
    int key = int.parse(data);
    dynamic sessionkey = getMod(key, _arandomsession, _zzyprime).toString();
    _sessionkey = hash(sessionkey);
    //myNotifyListeners();
  }

  setTab(List data, context) {
    int i = 0;
    dynamic tabname = "";
    data.forEach((element) {
      List databodyNew = [];
      Map data0 = Map.of(element);
      tabname = data0[gTabid];
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

    List actionData = [
      {
        gName: tabname,
        gType: gScreen,
        gItems: {
          0: {
            gItem: jsonEncode({gType: gTab, gValue: tabname})
          }
        },
      }
    ];

    showScreenPage(actionData, context, Colors.black.value);
    myNotifyListeners();
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

  setTreeNode(data, context) {
    /*List<Node> nodes = [];
    if (data[gType] == gTabletree) {
      dynamic tableName = data[gActionid];
      nodes = getTreeNodesFromTable(tableName, context, 0);
    }
    data[gNode] = nodes;*/
  }

  showMsg(context, dynamic result, backcolor) {
    /*Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);*/
    backcolor = Colors.white.value;
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
                      child: MyLabel({
                        gLabel: result.toString(),
                      }, backcolor),
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
        }
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyDetailNew(
                  getTableBodyParam(
                      {gTableID: tableid, gOther: other, gWhere: where},
                      context),
                  backcolor)));
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
    dynamic tableName = data[gTableID];
    List header = [];
    List body = [];

    Map tableInfo = _tableList[tableName];

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

    List newData = tableInfo[gDataSearch] ?? tableInfo[gData];

    for (int i = 0; i < newData.length; i++) {
      Map dataRow = newData[i];
      //get updated value
      List ti = getTableRowShowValueFilterMapOrList(
          dataRow, columns, context, '', false);
      if (ti != null) {
        body.add(ti);
      }
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
    //List data = tableList[tableName][gData];
    Map tableInfo = tableList[tableName];
    List data = tableInfo[gData];
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
    //tableInfo[gDataSearch] = data;
    tableList[tableName][gAscending] = ascending;
    tableList[tableName][gSortColumnIndex] = columnIndex;
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

  wait(waitSeconds) async {
    await Future.delayed(Duration(seconds: waitSeconds));
  }

  waitmilliseconds(waitMilliSeconds) async {
    await Future.delayed(Duration(milliseconds: waitMilliSeconds));
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

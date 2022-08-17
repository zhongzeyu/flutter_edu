// @dart=2.9
import 'dart:convert';

import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/MyForm.dart';
import 'package:edu_proj/widgets/myButton.dart';
import 'package:edu_proj/widgets/myIcon.dart';
import 'package:edu_proj/widgets/myLabel.dart';
import 'package:edu_proj/widgets/myPaginatedDataTable.dart';
import 'package:edu_proj/widgets/myPic.dart';
import 'package:edu_proj/widgets/textfieldWidget.dart';
//import 'package:edu_proj/widgets/myTab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyItem extends StatelessWidget {
  final dynamic _param;
  final int backcolor;
  MyItem(this._param, this.backcolor);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      if (_param[gType] == null) {
        return null;
      }
      var thisContext = this._param[gContext] ?? context;
      List<Widget> result = [];
      if (_param[gType] == gBtn) {
        result.add(MyButton(_param));
      } else if (_param[gType] == gBtns) {
        if (_param[gAction] == gTable) {
          List detail = _param[gItems];

          List list = datamodel.getButtonsList(thisContext, detail, 0, _param);

          result.add(Wrap(
            spacing: 8.0, //gap between adjacent items
            runSpacing: 4.0, //gap between lines
            direction: Axis.horizontal,
            children: list,
          ));
        }
      } else if (_param[gType] == gForm) {
        dynamic formID = _param[gValue];

        //datamodel.setFormListOne(formID, _param);

        result.add(MyForm(formID, backcolor));
      } else if (_param[gType] == gIcon) {
        result.add(MyIcon(_param));
      } else if (_param[gType] == gImg) {
        //var imgOriginal = _param[gValue];
        var imgOriginal = datamodel.imgList[_param[gValue]] ??
            datamodel.imgList[gNotavailable];
        result.add(MyPic({
          gImg: imgOriginal,
          gHeight: (_param[gHeight] != null) ? _param[gHeight] : null,
          gWidth: (_param[gWidth] != null) ? _param[gWidth] : null,
        }));
        /*result.add(Image.memory(
          base64.decode(imgOriginal),
          fit: BoxFit.fill,
          gaplessPlayback: true,
          height: (_param[gHeight] != null) ? _param[gHeight] : null,
          width: (_param[gWidth] != null) ? _param[gWidth] : null,
        ));*/
        if (_param[gLabel] != null) {
          result.add(SizedBox(width: gDefaultPaddin));
          result.add(MyLabel(_param, backcolor));
        }
      } else if (_param[gType] == gLabel) {
        result.add(MyLabel(_param, backcolor));
      } else if (_param[gType] == gTableEditor) {
        /*dynamic tableName = _param[gName];
        dynamic data = datamodel.tableList[tableName][gData]
            [datamodel.tableList[tableName][gTabIndex]];*/
        result.add(MyPaginatedDataTable(_param));
      } else if (_param[gType] == gSearch) {
        dynamic tableName = _param[gTableID];
        Map tableInfo = datamodel.tableList[tableName];

        MapEntry searchItem = datamodel.getTableItemByName(
            tableInfo, gSearch, tableInfo[gSearch] ?? '');
        Map searchItemValue = searchItem.value;
        searchItemValue.putIfAbsent(gAction, () => gLocalAction);
        searchItemValue.putIfAbsent(gWidth, () => 250.0);
        searchItemValue.putIfAbsent(gContext, () => thisContext);
        searchItemValue.putIfAbsent(gTableID, () => tableName);
        searchItemValue.putIfAbsent(gOldvalue, () => tableInfo[gSearch] ?? '');
        result.add(TextFieldWidget(item: searchItem));
      } else if (_param[gType] == gTextLink) {
        _param[gAction1] = _param[gAction];
        //_param[gAction] = gTextLink;
        _param[gAction] = gLocalAction;
        _param[gColor] = Colors.transparent.value;
        result.add(MyButton(_param));
      } else if (_param[gType] == gSizedbox) {
        result.add(SizedBox(height: _param[gValue]));
      } else if (_param[gType] == gTab) {
        dynamic tabID = _param[gValue];
        var tab = datamodel.getTab(tabID, thisContext);
        if (tab == null) {
          result.add(SizedBox());
          return result[0];
        }
        //var tabData = tab[gData];
        final double _screenHeight = MediaQuery.of(thisContext).size.height;
        result.add(Column(
          children: [
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tab[gData].length,
                itemBuilder: (context, index) =>
                    datamodel.getTabByIndex(index, tabID),
              ),
            ),
            SizedBox(
              height: _screenHeight - 200.0,
              child: datamodel.getTabBody(tabID, thisContext, backcolor),
            )
          ],
        ));
        //result.add(Expanded(child: datamodel.getTabBody(tabID, context)));
      } else {
        result.add(
            MyLabel({gLabel: "not available", gFontSize: 20.0}, backcolor));
      }

      if (result.length > 1) {
        result[0] = Expanded(child: result[0]);
        Widget aRow = Column(
            mainAxisAlignment: MainAxisAlignment.center, children: result);
        return aRow;
      }
      return result[0];
    });
    //return Image.asset('/images/' + _param['img'], package: packageName);

    /*return Image(
      image: NetworkImage(_param[gImg]),
      fit: BoxFit.fitWidth,
    );*/
    //return Image.network(_param[gImg]);
    //return FittedBox(child: Image.network(_param[gImg]), fit: BoxFit.fitHeight);
  }
}

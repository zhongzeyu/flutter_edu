// @dart=2.9
//import 'dart:convert';

import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/MyForm.dart';
import 'package:edu_proj/widgets/myButton.dart';
import 'package:edu_proj/widgets/myIcon.dart';
import 'package:edu_proj/widgets/myLabel.dart';
import 'package:edu_proj/widgets/myPaginatedDataTable.dart';
import 'package:edu_proj/widgets/myPic.dart';
import 'package:edu_proj/widgets/textfieldWidget.dart';
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
          //print('============== param is ' + _param.toString());
          List list = datamodel.getButtonsList(thisContext, detail, 0, _param);

          result.add(Wrap(
            spacing: 8.0, //gap between adjacent items
            runSpacing: 4.0, //gap between lines
            direction: Axis.horizontal,
            children: list,
          ));
        }
      } else if (_param[gType] == gForm) {
        /*dynamic formID = _param[gValue];
        dynamic id = _param[gId];*/
        //datamodel.setFormListOne(formID, _param);

        result.add(MyForm(_param, backcolor));
      } else if (_param[gType] == gIcon) {
        result.add(MyIcon(_param));
      } else if (_param[gType] == gImg) {
        //var imgOriginal = _param[gValue];
        var imgOriginal = datamodel.imgList[_param[gValue]] ??
            datamodel.imgList[gNotavailable];
        Widget myPic = MyPic({
          gImg: imgOriginal,
          gHeight: _param[gHeight] ?? null,
          gWidth: _param[gWidth] ?? null,
        });
        if (myPic != null) {
          result.add(myPic);
        }

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
        //if is parent self table, use tree
        dynamic tableName = _param[gName];

        Map tableInfo = datamodel.tableList[tableName];
        List columns = tableInfo[gColumns];
        bool isTreeview = false;
        for (int i = 0; i < columns.length; i++) {
          if (columns[i][gId] == gParentid) {
            var droplistName = columns[i][gDroplist] ?? '';
            var droplistNameTable = droplistName;
            if (droplistName.indexOf('[') > 0) {
              droplistNameTable =
                  droplistName.substring(0, droplistName.indexOf('['));
            }
            if (droplistNameTable == tableName) {
              isTreeview = true;
              for (int j = 0; j < columns.length; j++) {
                if (columns[j][gType] == gIcon) {
                  result.add(datamodel.getTreeViewTable(
                      droplistName, columns[j], context, backcolor));
                  break;
                }
              }
            }
          }
        }
        if (!isTreeview) {
          result.add(MyPaginatedDataTable(_param));
        }
      } else if (_param[gType] == gSearch) {
        dynamic tableName = _param[gTableID];

        Map item = {
          //gWidth: 150.0,
          gId: gSearchZzy,
          gLabel: gSearch,
          //gFocus: false,
          gInputType: gSearch,
          gType: gSearch,

          //gTxtEditingController: searchController
        };

        Map searchItemValue = item;
        searchItemValue.putIfAbsent(gAction, () => gLocalAction);
        //searchItemValue.putIfAbsent(gWidth, () => 250.0);
        searchItemValue.putIfAbsent(gContext, () => thisContext);
        searchItemValue.putIfAbsent(gTableID, () => tableName);

        /*if (item[gTxtEditingController] == null) {
          item[gTxtEditingController] = new TextEditingController();
          item[gTxtEditingController].text =
              datamodel.getValue(tableName, item[gId], null, gTable)[gValue];
        }
        TextEditingController txtController = item[gTxtEditingController];*/

        result.add(TextFieldWidget(
            item: item,
            typeOwner: gTable,
            name: tableName,
            backcolor: backcolor));
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
              height: 60.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tab[gData].length,
                itemBuilder: (context, index) =>
                    datamodel.getTabByIndex(index, tabID, context),
              ),
            ),
            SizedBox(
              height: _screenHeight - 200.0,
              child: datamodel.getTabBody(tabID, thisContext, backcolor),
            )
          ],
        ));
      } else {
        result.add(datamodel.notAvailable(backcolor));
      }

      if (result.length > 1) {
        result[0] = Expanded(child: result[0]);
        Widget aRow = Column(
            mainAxisAlignment: MainAxisAlignment.center, children: result);
        return aRow;
      }
      return result[0];
    });
  }
}

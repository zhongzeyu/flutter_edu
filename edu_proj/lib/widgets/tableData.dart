import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/widgets/myButton.dart';
import 'package:edu_proj/widgets/textfieldWidget.dart';
import 'package:flutter/material.dart';

import '../models/DataModel.dart';
import 'myLabel.dart';

class TableData extends DataTableSource {
  final Map _param;
  final BuildContext _context;
  final DataModel _dataModel;
  int _selectRowCount = 0;

  TableData(this._param, this._context, this._dataModel);

  bool get isRowCountApproximate => false;

  int get rowCount => (_param[gDataSearch] ?? _param[gData]).length;
  int get selectedRowCount => _selectRowCount;

  DataRow getRow(int index) {
    List<DataCell> dataCellList = [];
    dynamic dataRow = (_param[gDataSearch] ?? _param[gData])[index];
    List<Widget> actionList = [];
    if (_param[gAttr][gCanEdit]) {
      var labelValue = gEdit;
      if (!_dataModel.isNull(_param[gDataModified]) &&
          !_dataModel.isNull(_param[gDataModified][dataRow[gId]])) {
        labelValue = gSave;
      }
      actionList.add(MyButton({
        gLabel: labelValue,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: dataRow,
        gContext: _context,
        gWidth: 50.0
      }));
    }
    if (_param[gAttr][gCanDelete]) {
      actionList.add(MyButton({
        gLabel: gDelete,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: dataRow,
        gContext: _context,
        gWidth: 50.0
      }));
    }
    if ((_param[gAttr][gDetail] ?? "") != "") {
      actionList.add(MyButton({
        gLabel: gDetail,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: dataRow,
        gContext: _context,
        gWidth: 50.0
      }));
    }
    if (actionList.length > 0) {
      dataCellList.add(DataCell(Row(
        children: actionList,
      )));
    }
    for (int i = 0; i < _param[gColumns].length; i++) {
      if (_param[gColumns][i][gInputType] == gHidden) {
        continue;
      }

      /*print('======= items[' +
          i.toString() +
          '] is ' +
          items.entries.elementAt(i).toString());*/
      var colname = _param[gColumns][i][gId];
      var dataI = dataRow[colname];
      //var value = _dataModel.getValueByType(dataI, _param[gColumns][i]);
      int backColorValue = Colors.white.value;
      var originalValue = _dataModel.getValueByType(dataI, _param[gColumns][i]);
      bool isModified = true;
      var value = _dataModel.getTableModifiedValue(
          _param[gTableID], colname, dataRow[gId]);
      if (_dataModel.isNull(value)) {
        value = originalValue;
        isModified = false;
      }
      //dataCellList.add(DataCell(Text(dataI.toString())));
      bool needi10n = false;
      if (!_dataModel.isNull(_param[gColumns][i][gDroplist])) {
        needi10n = true;
      }
      Widget w;

      if (!_dataModel.isNull(_param[gTableItemRow]) &&
          dataRow[gId] == _param[gTableItemRow] &&
          colname == _param[gTableItemColName]) {
        //_dataModel.showFormEdit(data, context)

        var tableName = _param[gTableID];
        MapEntry item;
        Map<dynamic, dynamic> formDefine = _dataModel.formLists[tableName];
        Map<dynamic, dynamic> items = formDefine[gItems];
        items.entries.forEach((itemOne) {
          if (itemOne.value[gId] == colname) {
            item = itemOne;
            item.value[gOldvalue] =
                (dataRow == null) ? null : dataRow[item.value[gId]];
            item.value[gShowDetail] = false;
            //if is address
            if (item.value[gType] == gAddress) {
              _dataModel.dpList[
                  gAddress + '_' + tableName + '_' + item.value[gId]] = null;
            }

            item.value[gValue] = item.value[gOldvalue];
            item.value[gTxtEditingController]
              ..text = (dataRow == null)
                  ? null
                  : dataRow[item.value[gId]].toString();
            item.value[gPlaceHolder] =
                isModified ? originalValue.toString() : value.toString();
          }
        });

        //MapEntry item = _dataModel.getTableItemByName(_param, colname, value);
        w = TextFieldWidget(
            item: item,
            backcolor: backColorValue,
            formname: null,
            tablename: tableName,
            id: dataRow[gId]);
      } else {
        /*
         检查该字段是否有修改，如果有，显示修改值，并标记为红色
        */

        w = needi10n
            ? MyLabel({
                gLabel: value,
                gOriginalValue: isModified ? originalValue : null
              }, backColorValue)
            : (isModified
                ? Text.rich(TextSpan(text: originalValue,
                    //style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                        TextSpan(
                            text: ' -> ',
                            style: TextStyle(fontStyle: FontStyle.italic)),
                        TextSpan(
                            text: value,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ]))
                : Text(value));
        w = InkWell(
            child: w,
            onTap: () {
              if (!_param[gAttr][gCanEdit]) {
                return;
              }

              if (_param[gColumns][i][gType] == gLabel) {
                return;
              }

              _param[gLabel] = gTableItem;
              _param[gTableItemRow] = dataRow[gId];
              _param[gTableItemColName] = colname;
              this._dataModel.myNotifyListeners();
            });
      }
      dataCellList.add(DataCell(w));
    }
    return DataRow(cells: dataCellList);
  }
}

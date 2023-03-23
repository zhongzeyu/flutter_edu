import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/widgets/myButton.dart';
//import 'package:edu_proj/widgets/textfieldWidget.dart';
import 'package:flutter/material.dart';

import '../models/DataModel.dart';
//import 'myLabel.dart';

class TableData extends DataTableSource {
  final Map _param;
  final BuildContext _context;
  final DataModel _dataModel;
  int _selectRowCount = 0;

  TableData(this._param, this._context, this._dataModel);

  bool get isRowCountApproximate => false;

  int get rowCount => (_param[gDataSearch] ?? _param[gData]).length;
  int get selectedRowCount => _selectRowCount;
  getOneItem(
      items, colname, dataRow, tableName, value, isModified, originalValue) {
    Map item;
    items.entries.forEach((itemOne) {
      item = itemOne.value;
      if (item[gId] == colname) {
        item[gOldvalue] = (dataRow == null) ? null : dataRow[item[gId]];
        item[gShowDetail] = false;

        item[gValue] = value;
        item[gTxtEditingController]..text = (dataRow == null) ? null : value;
        item[gPlaceHolder] =
            isModified ? originalValue.toString() : value.toString();
        return item;
      }
    });
    return item;
  }

  DataRow getRow(int index) {
    List<DataCell> dataCellList = [];
    dynamic dataRow = (_param[gDataSearch] ?? _param[gData])[index];

    List<Widget> actionList = [];
    double size = 25.0;
    int backgroundcolor = Colors.white.value;
    if (_param[gAttr][gCanEdit]) {
      var labelValue = gEdit;
      var icon = 61453;

      if (!_dataModel.isNull(_param[gDataModified]) &&
          !_dataModel.isNull(_param[gDataModified][dataRow[gId]])) {
        labelValue = gSave;
        icon = 62260;
        actionList.add(MyButton({
          gLabel: gCancel,
          gAction: gLocalAction,
          gTableID: _param[gTableID],
          gRow: dataRow,
          gContext: _context,
          gIconSize: size,
          gIcon: 62575,
          gBackgroundColor: backgroundcolor
        }));
      }
      actionList.add(MyButton({
        gLabel: labelValue,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: dataRow,
        gContext: _context,
        gIconSize: size,
        gIcon: icon,
        gBackgroundColor: backgroundcolor
      }));
    }
    if (_param[gAttr][gCanDelete]) {
      actionList.add(MyButton({
        gLabel: gDelete,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: dataRow,
        gContext: _context,
        gIconSize: size,
        gIcon: 57787,
        gBackgroundColor: backgroundcolor
      }));
    }
    if ((_param[gAttr][gDetail] ?? "") != "") {
      actionList.add(MyButton({
        gLabel: gDetail,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: dataRow,
        gContext: _context,
        gIconSize: size,
        gIcon: 0xe246,
        gBackgroundColor: backgroundcolor
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

      var colname = _param[gColumns][i][gId];

      int backColorValue = Colors.white.value;
      Widget w = _dataModel.getRowItemOne(
          false, _param[gTableID], index, i, _context, backColorValue);

      dataCellList.add(DataCell(w, onTap: () {
        _param[gLabel] = gTableItem;
        _param[gTableItemRow] = dataRow[gId];
        _param[gTableItemColName] = colname;
        this._dataModel.myNotifyListeners();
      }));
    }
    return DataRow(cells: dataCellList);
  }
}

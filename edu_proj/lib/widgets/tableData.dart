import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/widgets/myButton.dart';
//import 'package:edu_proj/widgets/myButton.dart';
//import 'package:edu_proj/widgets/myIcon.dart';
import 'package:flutter/material.dart';

class TableData extends DataTableSource {
  final Map _param;
  final BuildContext _context;
  int _selectRowCount = 0;

  TableData(this._param, this._context);

  bool get isRowCountApproximate => false;

  int get rowCount => (_param[gDataSearch] ?? _param[gData]).length;
  int get selectedRowCount => _selectRowCount;

  DataRow getRow(int index) {
    List<DataCell> dataCellList = [];
    List<Widget> actionList = [];
    if (_param[gAttr][gCanEdit]) {
      actionList.add(MyButton({
        gLabel: gEdit,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: (_param[gDataSearch] ?? _param[gData])[index],
        gContext: _context,
        gWidth: 50.0
      }));
    }
    if (_param[gAttr][gCanDelete]) {
      actionList.add(MyButton({
        gLabel: gDelete,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: (_param[gDataSearch] ?? _param[gData])[index],
        gContext: _context,
        gWidth: 50.0
      }));
    }
    if ((_param[gAttr][gDetail] ?? "") != "") {
      actionList.add(MyButton({
        gLabel: gDetail,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: (_param[gDataSearch] ?? _param[gData])[index],
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
      var colname = _param[gColumns][i][gId];
      var dataI = (_param[gDataSearch] ?? _param[gData])[index][colname];
      dataCellList.add(DataCell(Text(dataI.toString())));
    }
    return DataRow(cells: dataCellList);
  }
}

import 'package:edu_proj/config/constants.dart';
import 'package:flutter/material.dart';

import '../models/DataModel.dart';

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
    dynamic dataRow = _dataModel.getTableData(_param[gTableID])[index];

    List<Widget> actionList = [];

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
      Widget w = _dataModel.getRowItemOne(_param[gTableID], dataRow[gId],
          _param[gColumns][i], _context, backColorValue, null);

      dataCellList.add(DataCell(w, onTap: () {
        _param[gLabel] = gTableItem;
        _dataModel.setFocus(_param[gTableID], colname, dataRow[gId], false);
        _dataModel.getTableFloatingBtns(_param[gTableID], _context);
        _dataModel.myNotifyListeners();
      }));
    }

    var isSelected = dataRow[gId] == _dataModel.mFocusNode[gId];
    return DataRow(cells: dataCellList, selected: isSelected);
  }
}

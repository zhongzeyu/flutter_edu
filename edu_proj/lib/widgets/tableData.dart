import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/widgets/myButton.dart';
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
      var value = _dataModel.getValueByType(dataI, _param[gColumns][i]);
      //dataCellList.add(DataCell(Text(dataI.toString())));
      bool needi10n = false;
      if (!_dataModel.isNull(_param[gColumns][i][gDroplist])) {
        needi10n = true;
      }
      Widget w = needi10n
          ? MyLabel({
              gLabel: value,
            }, Colors.white.value)
          : Text(value.toString());
      dataCellList.add(DataCell(w));
    }
    return DataRow(cells: dataCellList);
  }
}

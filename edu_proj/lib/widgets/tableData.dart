import 'package:edu_proj/config/constants.dart';
//import 'package:edu_proj/widgets/myButton.dart';
import 'package:edu_proj/widgets/myIcon.dart';
import 'package:flutter/material.dart';

class TableData extends DataTableSource {
  final Map _param;
  final BuildContext _context;
  int _selectRowCount = 0;

  TableData(this._param, this._context);
  // Generate some made-up data
  /*final List<Map<String, dynamic>> _data = List.generate(
      200,
      (index) => {
            "id": index,
            "title": "Item $index",
            "price": Random().nextInt(10000)
          });
*/
  bool get isRowCountApproximate => false;
  //int get rowCount => _data.length;

  int get rowCount => (_param[gDataSearch] ?? _param[gData]).length;
  int get selectedRowCount => _selectRowCount;

  DataRow getRow(int index) {
    List<DataCell> dataCellList = [];
    if (_param[gAttr][gCanEdit]) {
      dataCellList.add(DataCell(MyIcon({
        gValue: 0xf00d,
        gLabel: gEdit,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: index,
        gContext: _context
      })));

      /*dataCellList.add(DataCell(MyButton({
        gLabel: gEdit,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: index,
        gContext: _context
      })));*/
    }
    if (_param[gAttr][gCanDelete]) {
      dataCellList.add(DataCell(MyIcon({
        gValue: 0xefaa,
        gLabel: gDelete,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: index,
        gContext: _context
      })));

      /*dataCellList.add(DataCell(MyButton({
        gLabel: gDelete,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: index
      })));*/
    }
    if ((_param[gAttr][gDetail] ?? "") != "") {
      dataCellList.add(DataCell(MyIcon({
        gValue: 0xee90,
        gLabel: gDetail,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: index,
        gContext: _context
      })));
    }

    for (int i = 0; i < _param[gColumns].length; i++) {
      var colname = _param[gColumns][i][gId];
      var dataI = (_param[gDataSearch] ?? _param[gData])[index][colname];
      dataCellList.add(DataCell(Text(dataI.toString())));
    }
    return DataRow(cells: dataCellList);
  }
}

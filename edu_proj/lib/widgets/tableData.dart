import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/widgets/myButton.dart';
import 'package:flutter/material.dart';

class TableData extends DataTableSource {
  final Map _param;
  int _selectRowCount = 0;

  TableData(this._param);
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
  int get rowCount => _param[gData].length;
  int get selectedRowCount => _selectRowCount;

  DataRow getRow(int index) {
    List<DataCell> dataCellList = [];
    if (_param[gAttr][gCanEdit]) {
      dataCellList.add(DataCell(MyButton({
        gLabel: gEdit,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: index
      })));
    }
    if (_param[gAttr][gCanDelete]) {
      dataCellList.add(DataCell(MyButton({
        gLabel: gDelete,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: index
      })));
    }

    for (int i = 0; i < _param[gColumns].length; i++) {
      var colname = _param[gColumns][i][gId];
      var dataI = _param[gData][index][colname];
      dataCellList.add(DataCell(Text(dataI.toString())));
    }
    return DataRow(cells: dataCellList);
  }
}

import 'package:edu_proj/config/constants.dart';
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
    for (int i = 0; i < _param[gColumns].length; i++) {
      dataCellList.add(
          DataCell(Text(_param[gData][_param[gColumns][i][gId]].toString())));
    }
    return DataRow(cells: dataCellList);
  }
}

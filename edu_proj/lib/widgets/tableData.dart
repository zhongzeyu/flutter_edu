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
  // Generate some made-up data
  /*final List<Map<dynamic, dynamic>> _data = List.generate(
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
    List<Widget> actionList = [];
    /*Map aparam = {
      //gValue: 0xf00d,
      //gLabel: gEdit,
      gAction: gLocalAction,
      gPadding: 0.0,
      gWidth: 50.0,
      gTableID: _param[gTableID],
      gRow: (_param[gDataSearch] ?? _param[gData])[index],
      gContext: _context
    };*/
    if (_param[gAttr][gCanEdit]) {
      /*Map thisParam = new Map.from(aparam);
      thisParam[gLabel] = gEdit;
      thisParam[gValue] = 0xe21a;
      
      actionList.add(MyIcon(thisParam));*/
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
      /*Map thisParam = new Map.from(aparam);
      thisParam[gLabel] = gDelete;
      thisParam[gValue] = 0xe1b9;
      actionList.add(MyIcon(thisParam));*/

      actionList.add(MyButton({
        gLabel: gDelete,
        gAction: gLocalAction,
        gTableID: _param[gTableID],
        gRow: (_param[gDataSearch] ?? _param[gData])[index],
        gContext: _context,
        gWidth: 50.0
      }));

      //dataCellList.add(DataCell(MyIcon(thisParam)));
    }
    if ((_param[gAttr][gDetail] ?? "") != "") {
      /*Map thisParam = new Map.from(aparam);
      thisParam[gLabel] = gDetail;
      thisParam[gValue] = 0xe1ff;
      actionList.add(MyIcon(thisParam));*/

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

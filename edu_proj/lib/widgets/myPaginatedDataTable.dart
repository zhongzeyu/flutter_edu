// @dart=2.9
import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/myLabel.dart';
import 'package:edu_proj/widgets/tableData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPaginatedDataTable extends StatelessWidget {
  final dynamic _param;
  const MyPaginatedDataTable(
    this._param,
  );

  @override
  Widget build(BuildContext context) {
    DataTableSource tabledata;
    int actionBtnCnts = 0;
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      dynamic tableName = _param[gName];

      Map tableInfo = datamodel.tableList[tableName];
      List columns = tableInfo[gColumns];
      datamodel.setTableDataSearch(tableName, context, _param[gOther]);

      tabledata = TableData(tableInfo, context, datamodel);

      sortTable(int columnIndex, bool ascending) {
        int sortIndex = columnIndex - actionBtnCnts;
        datamodel.tableSort(tableName, sortIndex, ascending, context);
        datamodel.myNotifyListeners();
      }

      getTableColumns() {
        List<DataColumn> result = [];
        actionBtnCnts = 0;
        /*if (tableInfo[gAttr][gCanEdit] ||
            tableInfo[gAttr][gCanDelete] ||
            (tableInfo[gAttr][gDetail] ?? "") != "") {
          result.add(DataColumn(label: Text("")));
          actionBtnCnts = 1;
        }*/
        for (int i = 0; i < columns.length; i++) {
          if (datamodel.isHiddenColumn(columns, i)) {
            continue;
          }
          result.add(DataColumn(
              label: MyLabel({gLabel: columns[i][gLabel]}, Colors.white.value),
              onSort: sortTable));
        }
        return result;
      }

      getShowIndex(sortColumnIndex) {
        int result = 0;
        for (int i = 0; i < columns.length; i++) {
          if (datamodel.isHiddenColumn(columns, i)) {
            continue;
          }
          if (result == sortColumnIndex) {
            return result;
          }
          result++;
        }
        return result;
      }

      return PaginatedDataTable(
        key: tableInfo[gKey],
        rowsPerPage: datamodel.getRowsPerPage(tableInfo, context),
        availableRowsPerPage: [5, 10, 15, 20, 50],
        onPageChanged: (e) {
          tableInfo[gRowCurrent] = e;
        },
        initialFirstRowIndex: tableInfo[gRowCurrent],
        //actions: [Text('action0'), Text('action1')],
        onRowsPerPageChanged: (int v) {
          //widget.onRowsPerPageChanged?.call(v ?? 10);
          //datamodel.setRowsPerPage(tableInfo, v);
        },
        columns: getTableColumns(),
        columnSpacing: 15,
        //horizontalMargin: 5,
        source: tabledata,
        showCheckboxColumn: true,
        sortAscending: tableInfo[gAscending],
        sortColumnIndex:
            actionBtnCnts + getShowIndex(tableInfo[gSortColumnIndex]),
        //header: datamodel.getTableHeader(tableName, context),
      );
    });
  }
}

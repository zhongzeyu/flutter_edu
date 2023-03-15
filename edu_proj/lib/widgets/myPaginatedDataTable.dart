// @dart=2.9
//import 'package:edu_proj/common/theme.dart';
import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
//import 'package:edu_proj/screens/myDetail.dart';
import 'package:edu_proj/widgets/myLabel.dart';
import 'package:edu_proj/widgets/tableData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'textfieldWidget.dart';

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
      List tableData = tableInfo[gData];
      List columns = tableInfo[gColumns];
      dynamic searchValue = tableInfo[gSearch] ?? '';
      List newData = [];

      for (int i = 0; i < tableData.length; i++) {
        Map dataRow = tableData[i];
        //get updated value
        Map ti = datamodel.getTableRowShowValueFilter(
            dataRow, columns, context, searchValue);
        if (ti != null) {
          newData.add(ti);
        }
      }
      //get where
      dynamic other = _param[gOther] ?? null;
      if (other != null) {
        other = Map.of(other);
        dynamic aTitle = other[gOther] ?? null;
        if (aTitle != null) {
          Map data0 = datamodel.whereList[aTitle] ?? null;
          if (data0 != null) {
            dynamic aWhere = data0[gWhere] ?? '';
            if (aWhere.indexOf("=") > 0) {
              newData = datamodel.getDataWhere(newData, aWhere);
            }
          }
        }
      }

      tableInfo[gDataSearch] = newData;

      tabledata = TableData(tableInfo, context, datamodel);

      sortTable(int columnIndex, bool ascending) {
        int sortIndex = columnIndex - actionBtnCnts;
        datamodel.tableSort(tableName, sortIndex, ascending, context);
        datamodel.myNotifyListeners();
      }

      getTableColumns() {
        List<DataColumn> result = [];
        actionBtnCnts = 0;
        if (tableInfo[gAttr][gCanEdit] ||
            tableInfo[gAttr][gCanDelete] ||
            (tableInfo[gAttr][gDetail] ?? "") != "") {
          result.add(DataColumn(label: Text("")));
          actionBtnCnts = 1;
        }
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
        rowsPerPage: datamodel.getRowsPerPage(tableInfo),
        availableRowsPerPage: [5, 10, 15, 20, 50],
        onPageChanged: (e) {},
        onRowsPerPageChanged: (int v) {
          //widget.onRowsPerPageChanged?.call(v ?? 10);
          datamodel.setRowsPerPage(tableInfo, v);
        },
        columns: getTableColumns(),
        columnSpacing: 30,
        horizontalMargin: 5,
        source: tabledata,
        showCheckboxColumn: true,
        sortAscending: tableInfo[gAscending],
        sortColumnIndex:
            actionBtnCnts + getShowIndex(tableInfo[gSortColumnIndex]),
      );
    });
  }
}

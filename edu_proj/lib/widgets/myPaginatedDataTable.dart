// @dart=2.9
import 'package:edu_proj/common/theme.dart';
import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
//import 'package:edu_proj/screens/myDetail.dart';
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
      String tableName = _param[gData][gActionid] ?? _param[gData][gTableID];

      Map tableInfo = datamodel.tableList[tableName];
      //tableInfo.[gData].length;
      tabledata = TableData(tableInfo, context);

      sortTable(int columnIndex, bool ascending) {
        int sortIndex = columnIndex - actionBtnCnts;
        datamodel.tableSort(tableName, sortIndex, ascending);

        print('============columnIndex is $sortIndex, ascending is $ascending');
        datamodel.notifyListeners();
      }

      getTableColumns() {
        List columns = tableInfo[gColumns];
        List<DataColumn> result = [];
        actionBtnCnts = 0;
        if (tableInfo[gAttr][gCanEdit]) {
          result.add(DataColumn(label: Text("")));
          actionBtnCnts++;
        }
        if (tableInfo[gAttr][gCanDelete]) {
          result.add(DataColumn(label: Text("")));
          actionBtnCnts++;
        }
        if ((tableInfo[gAttr][gDetail] ?? "") != "") {
          result.add(DataColumn(label: Text("")));
          actionBtnCnts++;
        }
        columns.forEach((element) {
          result.add(DataColumn(
              label: MyLabel({gLabel: element[gLabel]}), onSort: sortTable));
        });
        return result;
      }

      getTableBtns(tableInfo, datamodel, context) {
        Map attr = tableInfo[gAttr];
        List<Widget> items = [];
        if (attr[gCanInsert]) {
          items.add(ElevatedButton(
              onPressed: () {
                datamodel.showTableForm(_param[gData], context);
                //tableAddNew(tableName);
              },
              child: MyLabel({gLabel: gAddnew})));
        }
        if (attr[gCanDelete]) {
          items.add(ElevatedButton(
              onPressed: () {
                //tableAddNew(tableName);
              },
              child: MyLabel({gLabel: gDelete})));
        }
        return items;
      }

      //datamodel.initPaginateDataTable(tableName,actionBtnCnts, tabledata, getTableColumns());

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: tableTheme,
        home: Scaffold(
          appBar: AppBar(
            /*IconButton(
              icon: Icon(Icons.menu),
              onPressed: null,
            ),*/

            actions: getTableBtns(tableInfo, datamodel, context),
          ),
          body: SingleChildScrollView(
            child: //tableInfo[gPagetable]
                PaginatedDataTable(
              //header: MyLabel(data),
              key: tableInfo[gKey],
              rowsPerPage: 5,
              availableRowsPerPage: [5, 10, 20, 50],
              onPageChanged: (e) {},
              onRowsPerPageChanged: (int v) {
                //widget.onRowsPerPageChanged?.call(v ?? 10);
              },
              columns: getTableColumns(),
              columnSpacing: 30,
              horizontalMargin: 5,
              source: tabledata,
              showCheckboxColumn: true,
              sortAscending: tableInfo[gAscending],
              sortColumnIndex: tableInfo[gSortColumnIndex] + actionBtnCnts,
            ),
          ),
        ),
      );
    });
  }
}

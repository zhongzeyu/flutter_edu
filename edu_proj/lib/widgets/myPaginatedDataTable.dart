// @dart=2.9
//import 'package:edu_proj/common/theme.dart';
import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
//import 'package:edu_proj/screens/myDetail.dart';
import 'package:edu_proj/widgets/myLabel.dart';
import 'package:edu_proj/widgets/tableData.dart';
//import 'package:edu_proj/widgets/textfieldWidgetOne.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'textfieldWidget.dart';

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
      List tableData = tableInfo[gData];
      List columns = tableInfo[gColumns];
      String searchValue = tableInfo[gSearch] ?? '';
      List newData = [];

      for (int i = 0; i < tableData.length; i++) {
        Map dataRow = tableData[i];
        //get updated value
        Map ti = datamodel.getTableRowShowValueFilter(
            dataRow, columns, context, searchValue);
        if (ti != null) {
          newData.add(ti);
        }
        /*bool searchTxtExists = false;
        for (MapEntry element in ti.entries) {
          var elementKey = element.key;

          if (searchValue == '' ||
              (element.value ?? '').indexOf(searchValue) > -1) {
            searchTxtExists = true;
            break;
          }
        }
        if (searchTxtExists) {
          newData.add(ti);
        }*/
      }

      tableInfo[gDataSearch] = newData;

      tabledata = TableData(tableInfo, context);

      sortTable(int columnIndex, bool ascending) {
        int sortIndex = columnIndex - actionBtnCnts;
        /*int index = 0;
        for (int i = 0; i < columns.length; i++) {
          if (datamodel.isHiddenColumn(columns, i)) {
            continue;
          }
          if (index == sortIndex) {
            sortIndex = i;
            break;
          }
          index++;
        }*/

        datamodel.tableSort(tableName, sortIndex, ascending, context);

        print('============columnIndex is $sortIndex, ascending is $ascending');
        datamodel.myNotifyListeners();
      }

      getTableColumns() {
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
        for (int i = 0; i < columns.length; i++) {
          if (datamodel.isHiddenColumn(columns, i)) {
            continue;
          }
          result.add(DataColumn(
              label: MyLabel({gLabel: columns[i][gLabel]}), onSort: sortTable));
        }
        return result;
      }

      getTableBtns(tableInfo, datamodel, context) {
        Map attr = tableInfo[gAttr];
        var value = tableInfo[gSearch] ?? '';

        MapEntry searchItem =
            datamodel.getTableItemByName(tableInfo, gSearch, value);
        Map searchItemValue = searchItem.value;
        searchItemValue.putIfAbsent(gAction, () => gLocalAction);
        searchItemValue.putIfAbsent(gContext, () => context);
        searchItemValue.putIfAbsent(gTableID, () => tableInfo[gTableID]);
        searchItemValue.putIfAbsent(gOldvalue, () => value);
        /*searchItem.value[gAction] = gLocalAction;
        searchItem.value[gContext] = context;
        searchItem.value[gTableID] = tableInfo[gTableID];*/
        List<Widget> items = [];
        items.add(TextFieldWidget(item: searchItem));

        if (attr[gCanInsert]) {
          items.add(ElevatedButton(
              onPressed: () {
                _param[gData][gRow] = datamodel.newForm(_param[gData], context);
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
        //String tableName = _param[gData][gActionid] ?? _param[gData][gTableID];

        return items;
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

      //datamodel.initPaginateDataTable(tableName,actionBtnCnts, tabledata, getTableColumns());
      //dynamic item = datamodel.getTableSearchItem(tableInfo);

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        //theme: tableTheme,
        home: Scaffold(
          appBar: AppBar(
            /*title: TextFieldWidgetOne(
              item: item,
            ),
            title: const TextField(
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: 'Search'),
            ),*/

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
            ),
          ),
        ),
      );
    });
  }
}

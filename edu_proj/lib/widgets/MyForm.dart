// @dart=2.9
import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/textfieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyForm extends StatelessWidget {
  final String _param;
  final int _tableIndex;

  MyForm(this._param, this._tableIndex);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(
      builder: (context, datamodel, child) {
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
        final String _formName = _param;
        //['name'];
        Map<String, dynamic> formDefine = datamodel.formLists[_formName];
        Map<dynamic, dynamic> items = formDefine[gItems];

        //Size size = MediaQuery.of(context).size;
        //double _top = 10.0;
        List<Widget> _showItems() {
          List<Widget> result = [];
          dynamic dataRow;
          if (_tableIndex != null && _tableIndex > -1) {
            //get table data by index
            dataRow = datamodel.getTableByIndex(_tableIndex, _formName);
          }

          items.entries.forEach((item) {
            item.value[gOldvalue] =
                (dataRow == null) ? null : dataRow[item.value[gId]];

            item.value[gValue] = item.value[gOldvalue];
            item.value[gTxtEditingController]
              ..text = (dataRow == null)
                  ? null
                  : dataRow[item.value[gId]].toString();
            if (item.value[gIsHidden] != gTrue &&
                item.value[gType] != gHidden) {
              //_top += 10;
              if (item.value[gType] == gLabel) {
                dynamic aDvalue = (item.value[gValue] == null)
                    ? item.value[gDefaultValue].toString()
                    : item.value[gValue].toString();
                // if (item.value[gDefaultValue] != null &&
                //    item.value[gDefaultValue] != '') {
                result.add(
                  Text(
                    datamodel.getSCurrent(item.value[gLabel]) +
                        ":" +
                        aDvalue.toString()
                    /*+
                            (item.value[gValue] == null)
                        ? item.value[gDefaultValue].toString()
                        : item.value[gValue].toString()*/
                    ,

                    /*
                onTab: () => {_onTab(item.value['id'], size)},
                onChanged: (String value) =>
                    {_onChange(item.value['id'], value)},
                textFieldController: item.value['txtEditingController'],
                */
                  ),
                );
                //}
              } else {
                result.add(
                  TextFieldWidget(
                    item: item,
                    /*
                onTab: () => {_onTab(item.value['id'], size)},
                onChanged: (String value) =>
                    {_onChange(item.value['id'], value)},
                textFieldController: item.value['txtEditingController'],
                */
                  ),
                );
              }
            }
          });
          //_top += 30;

          result.add(
            SizedBox(
              height: 24.0,
            ),
          );
          datamodel.beforeSubmit(context, _formName, result);
          result.add(
            ElevatedButton(
              child: Text(datamodel.getSCurrent(formDefine[gSubmit])),
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                }
                _formKey.currentState.save();
                datamodel.formSubmit(context, _formName);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.yellow,
              ),
            ),
          );

          datamodel.afterSubmit(context, _formName, result);
          return result;
        }

        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _showItems(),
            ),
          ),
        );
      },
    );
  }
}

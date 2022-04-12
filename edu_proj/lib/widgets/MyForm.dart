// @dart=2.9
import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/textfieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'myDropdown.dart';

class MyForm extends StatelessWidget {
  final String _param;
  //final Map _paramData;

  //MyForm(this._param, this._paramData);
  MyForm(this._param);

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
          //dynamic dataRow;
          //dataRow = _paramData[gData];
          items.entries.forEach((item) {
            /*item.value[gOldvalue] =
                (dataRow == null) ? null : dataRow[item.value[gId]];

            item.value[gValue] = item.value[gOldvalue];
            item.value[gTxtEditingController]
              ..text = (dataRow == null)
                  ? null
                  : dataRow[item.value[gId]].toString();*/

            //datamodel.setFormValue(_formName, item.value[gId], itemValue);
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
                //if had droplist, use dropdown
                if (!datamodel.isNull(item.value[gDroplist])) {
                  /*result.add(DropdownButton<String>(
                    value: 'One',
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {},
                    items: <String>['One', 'Two', 'Free', 'Four']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ));*/
                  result.add(
                    MyDropdown(item.value, _formName),
                  );
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
            }
          });
          //_top += 30;

          result.add(
            SizedBox(
              height: 24.0,
            ),
          );
          datamodel.beforeSubmit(context, _formName, result);
          /*if (_formKey == null ||
              _formKey.currentState == null ||
              !(_formKey.currentState.validate() ?? true)) {
            result.add(
              ElevatedButton(
                child: Text(datamodel.getSCurrent(formDefine[gSubmit])),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                ),
                onPressed: () {},
              ),
            );
          } else {*/
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
          //}

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

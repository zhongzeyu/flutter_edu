// @dart=2.9

import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/myLabel.dart';
import 'package:edu_proj/widgets/myPinCode.dart';
import 'package:edu_proj/widgets/textfieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'myDropdown.dart';
import 'myGlass.dart';

class MyForm extends StatelessWidget {
  final dynamic _param;
  final int backcolor;
  //final FocusNode focusNode = new FocusNode();
  //final _debouncer = Debouncer(milliseconds: 1000);
  //final Map _paramData;

  //MyForm(this._param, this._paramData);
  MyForm(this._param, this.backcolor);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(
      builder: (context, datamodel, child) {
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
        final dynamic _formName = _param;
        //['name'];
        if (datamodel.formLists[_formName] == null) {
          return MyLabel({gLabel: gNotavailable, gFontSize: 20.0}, backcolor);
        }
        Map<dynamic, dynamic> formDefine = datamodel.formLists[_formName];
        Map<dynamic, dynamic> items = formDefine[gItems];
        Color cBackColor = datamodel.fromBdckcolor(backcolor);
        //Size size = MediaQuery.of(context).size;
        //double _top = 10.0;
        List<Widget> _showItems() {
          List<Widget> result = [];
          //dynamic dataRow;
          //dataRow = _paramData[gData];
          datamodel.setFormFocus(_formName, null);
          items.entries.forEach((item) {
            /*item.value[gOldvalue] =
                (dataRow == null) ? null : dataRow[item.value[gId]];

            item.value[gValue] = item.value[gOldvalue];
            item.value[gTxtEditingController]
              ..text = (dataRow == null)
                  ? null
                  : dataRow[item.value[gId]].toString();*/

            //datamodel.setFormValue(_formName, item.value[gId], itemValue);
            if ((item.value[gIsHidden] ?? "false") != gTrue &&
                (item.value[gType] ?? "") != gHidden) {
              //_top += 10;
              if ((item.value[gType] ?? "") == gLabel) {
                dynamic aDvalue = (item.value[gValue] == null)
                    ? item.value[gDefaultValue].toString()
                    : item.value[gValue].toString();
                // if (item.value[gDefaultValue] != null &&
                //    item.value[gDefaultValue] != '') {
                result.add(
                  Text(
                    datamodel.getSCurrent(item.value[gLabel]) +
                        ":" +
                        aDvalue.toString(),
                    style: TextStyle(
                      color: cBackColor,
                      //backgroundColor: _param[gBackgroundColor]
                    )
                    /*+
                            (item.value[gValue] == null)
                        ? item.value[gDefaultValue].toString()
                        : item.value[gValue].toString()*/
                    ,

                    /*
                onTab: () => {_onTab(item.value['id'], size)},
                onChanged: (dynamic value) =>
                    {_onChange(item.value['id'], value)},
                textFieldController: item.value['txtEditingController'],
                */
                  ),
                );
                //}
              } else if ((item.value[gType] ?? "") == gPincode) {
                result.add(
                  MyPinCode(item.value, _formName),
                );
              } else {
                //if had droplist, use dropdown
                if (!datamodel.isNull(item.value[gDroplist])) {
                  /*datamodel.getDropdownMenuItem(
                      item.value[gDroplist], null, context, backcolor);*/
                  if (datamodel.dpList[item.value[gDroplist]] != null) {
                    List itemList = datamodel.dpList[item.value[gDroplist]];
                    if (itemList != null) {
                      result.add(DropdownButton<dynamic>(
                        value: item.value[gValue],
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (dynamic newValue) {},
                        items: itemList
                            .map<DropdownMenuItem<dynamic>>((dynamic value) {
                          return DropdownMenuItem<dynamic>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ));
                    }
                  }

                  /*datamodel.getDropdownMenuItem(
                      item.value[gDroplist], null, context, backcolor);

                  result.add(
                    MyDropdown(item, _formName, backcolor),
                  );*/
                } else {
                  result.add(
                    TextFieldWidget(
                        item: item, backcolor: backcolor, formname: _formName
                        /*
                onTab: () => {_onTab(item.value['id'], size)},
                onChanged: (dynamic value) =>
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
          Map paramSubmit = {
            gWidth: 200,
            gHeight: 40,
            gBorderRadius: 10.0,
            gMargin: const EdgeInsets.all(1.5),
            gPadding: const EdgeInsets.all(1.5),
            //gMargin: const EdgeInsets.all(0.5),
            //gPadding: const EdgeInsets.all(0.5),
            gBlur: 10.0,
            gAlignment: Alignment.topLeft,
            gBorder: 2.0,
            gColor: Colors.blue,
            gBackgroundColor: Colors.white, //Color.fromARGB(255, 218, 165, 32),
            gChild: MyLabel({gLabel: formDefine[gSubmit]}, Colors.blue.value)
          };

          result.add(InkWell(
            child: MyGlass(paramSubmit),
            onTap: () {
              if (!_formKey.currentState.validate()) {
                return;
              }
              _formKey.currentState.save();
              datamodel.formSubmit(context, _formName);
            },
          ));

          /*ElevatedButton(
              child: Text(datamodel.getSCurrent(formDefine[gSubmit])),
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                }
                _formKey.currentState.save();
                datamodel.formSubmit(context, _formName);
              },
              style: ElevatedButton.styleFrom(
                //primary: Colors.yellow,
                //primary: Colors.green,
                //onPrimary: Colors.white,
                //shadowColor: Colors.greenAccent,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                minimumSize: Size(200, 40),
              ),
            ),
          );*/
          //}

          datamodel.afterSubmit(context, _formName, result);
          return result;
        }

        return Form(
          key: _formKey,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: _showItems(),
          ),
        );
      },
    );
  }

  /*void onLoad(BuildContext context) {
    Future.delayed(Duration(seconds: 3),
        () => FocusScope.of(context).requestFocus(focusNode));
  }*/
}

/*class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}*/

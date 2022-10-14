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
    int thisbackcolor = backcolor ?? Colors.black.value;
    return Consumer<DataModel>(
      builder: (context, datamodel, child) {
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
        final dynamic _formName = _param;
        //['name'];
        if (datamodel.formLists[_formName] == null) {
          return MyLabel(
              {gLabel: gNotavailable, gFontSize: 20.0}, thisbackcolor);
        }
        Map<dynamic, dynamic> formDefine = datamodel.formLists[_formName];
        Map<dynamic, dynamic> items = formDefine[gItems];
        //Color cBackColor = datamodel.fromBdckcolor(backcolor);
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
              if ((item.value[gType] ?? "") == gPincode) {
                result.add(
                  MyPinCode(item.value, _formName),
                );
              } else {
                //if had droplist, use dropdown
                if (!datamodel.isNull(item.value[gDroplist])) {
                  //if (datamodel.dpList[item.value[gDroplist]] != null) {
                  result.add(
                    MyDropdown(item, _formName, thisbackcolor),
                  );
                  //}
                } else {
                  result.add(
                    TextFieldWidget(
                        item: item,
                        backcolor: thisbackcolor,
                        formname: _formName
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
}

// @dart=2.9

import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/myLabel.dart';
import 'package:edu_proj/widgets/myPinCode.dart';
//import 'package:edu_proj/widgets/textfieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'myDropdown.dart';
import 'myGlass.dart';

class MyForm extends StatelessWidget {
  final dynamic _param;
  final int backcolor;
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

        //datamodel.dpList[gYear] = [];
        Map<dynamic, dynamic> formDefine = datamodel.formLists[_formName];
        formDefine[gKey] = _formKey;
        Map<dynamic, dynamic> items = formDefine[gItems];
        //Color cBackColor = datamodel.fromBdckcolor(backcolor);
        //Size size = MediaQuery.of(context).size;
        //double _top = 10.0;
        List<Widget> _showItems() {
          List<Widget> result = [];
          //dynamic dataRow;
          //dataRow = _paramData[gData];
          datamodel.setFormFocus(_formName, null);
          items.entries.forEach((itemOne) {
            Map item = itemOne.value;
            if ((item[gIsHidden] ?? "false") != gTrue &&
                (item[gType] ?? "") != gHidden) {
              if ((item[gInputType] ?? "") == gCode) {
                result.add(
                  MyPinCode(item, _formName),
                );
              } else {
                Widget w = datamodel.getRowItemOne(
                    true, _formName, -1, item, context, thisbackcolor);
                w = InkWell(
                    onTap: () {
                      datamodel.setFormFocus(_formName, item[gId]);
                      datamodel.myNotifyListeners();
                    },
                    child: w);
                result.add(w);
                result.add(SizedBox(
                  height: 10.0,
                ));
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

        Form form = Form(
          key: _formKey,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: _showItems(),
          ),
        );
        //_formKey.currentState.validate();
        return form;
      },
    );
  }
}

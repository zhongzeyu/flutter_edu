// @dart=2.9
import 'dart:async';

import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  final MapEntry<dynamic, dynamic> item;
  final int backcolor;
  final dynamic formname;
  final _debouncer = Debouncer(milliseconds: 500);
  TextFieldWidget({this.item, this.backcolor, this.formname});
  _getWidth() {
    return null;
    //item.value[gWidth] ?? null;
  }

  textChange(
      dynamic text, MapEntry item, DataModel datamodel, BuildContext context) {
    if (item.value[gType] == gAddress) {
      item.value[gAction] = gLocalAction;
    }
    if ((item.value[gAction] ?? '') == '') {
      return;
    }
    item.value[gSearch] = text;
    datamodel.sendRequestOne(
        item.value[gAction], item, item.value[gContext] ?? context);
  }

  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      bool isPassword = (item.value[gType] == gPassword);

      if (isPassword) {
        item.value[gPasswordShow] = item.value[gPasswordShow] ?? true;

        item.value[gSuffixIcon] = IconButton(
            icon: Icon(
              item.value[gPasswordShow]
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Theme.of(context).disabledColor,
            ),
            onPressed: () {
              item.value[gPasswordShow] = !item.value[gPasswordShow];
              datamodel.myNotifyListeners();
            });
      }
      item.value[gTxtEditingController].selection = TextSelection.fromPosition(
          TextPosition(offset: item.value[gTxtEditingController].text.length));
      Color cBackColor = datamodel.fromBdckcolor(backcolor);
      TextEditingController txtController = item.value[gTxtEditingController];
      if (datamodel.isNull(txtController.text)) {
        txtController.text = "";
      }

      return Container(
        width: _getWidth(),
        child: TextFormField(
            controller: txtController,
            autofocus: item.value[gFocus] ?? false,
            //focusNode: item.value[gFocusNode],
            keyboardType: item.value[gInputType],
            maxLength: item.value[gLength],
            style: TextStyle(
              color: cBackColor,
              fontSize: item.value[gFontSize],
              fontStyle: item.value[gFontStyle],
              fontWeight: item.value[gFontWeight],
              letterSpacing: item.value[gLetterSpacing],
            ),
            decoration: InputDecoration(
                labelText: datamodel.getSCurrent(item.value[gLabel]),
                labelStyle: TextStyle(
                  color: cBackColor,
                  fontSize: item.value[gFontSize],
                  fontStyle: item.value[gFontStyle],
                  fontWeight: item.value[gFontWeight],
                  letterSpacing: item.value[gLetterSpacing],
                ),
                hintText: item.value[gPlaceHolder],
                hintStyle: TextStyle(
                  color: cBackColor,
                  fontSize: item.value[gFontSize],
                  fontStyle: item.value[gFontStyle],
                  fontWeight: item.value[gFontWeight],
                  letterSpacing: item.value[gLetterSpacing],
                ),
                suffixIcon: item.value[gSuffixIcon],
                //prefixIcon: item.value['prefixIcon'],
                enabled: ((item.value[gType] ?? "") != gLabel)),
            obscureText: isPassword && item.value[gPasswordShow],
            validator: (dynamic value) {
              if (item.value[gRequired] && value.isEmpty) {
                return datamodel
                    .getSCurrent(gIsrequired + "{" + item.value[gLabel] + "}");
              }
              if (item.value[gType] == gEmail &&
                  !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                return datamodel.getSCurrent(gInvalidname + "{" + gEmail + "}");
              }
              if (item.value[gMinLength] != null &&
                  item.value[gMinLength] != '0' &&
                  value.length < item.value[gMinLength]) {
                return datamodel.getSCurrent(gMininput +
                    "{" +
                    item.value[gMinLength] +
                    "}{" +
                    item.value[gUnit] +
                    "}");
              }
              if (item.value[gLength] != null &&
                  item.value[gLength] != '0' &&
                  value.length > item.value[gLength]) {
                return datamodel.getSCurrent(gMaxinput +
                    "{" +
                    item.value[gLength] +
                    "}{" +
                    item.value[gUnit] +
                    "}");
              }
              return null;
            },
            onSaved: (dynamic value) {
              item.value[gValue] = value;
            },
            onChanged: (text) {
              _debouncer.run(() => textChange(text, item, datamodel, context));
            },
            onTap: () {
              if (datamodel.isNull(formname)) {
                return;
              }
              //set focus
              datamodel.setFormFocus(formname, item.value[gId]);
            }),
      );
    });
  }
}

class Debouncer {
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
}

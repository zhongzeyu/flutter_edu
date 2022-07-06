// @dart=2.9
import 'dart:async';

import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  final MapEntry<dynamic, dynamic> item;
  final _debouncer = Debouncer(milliseconds: 500);
  TextFieldWidget({
    this.item,
  });
  _getWidth() {
    return null;
    //item.value[gWidth] ?? null;
  }

  textChange(
      String text, MapEntry item, DataModel datamodel, BuildContext context) {
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
      return Container(
        width: _getWidth(),
        child: TextFormField(
            controller: item.value[gTxtEditingController],
            autofocus: item.value[gFocus] ?? true,
            keyboardType: item.value[gInputType],
            maxLength: item.value[gLength],
            style: TextStyle(
              //color: item.value[gTextFontColor],
              fontSize: item.value[gFontSize],
              fontStyle: item.value[gFontStyle],
              fontWeight: item.value[gFontWeight],
              letterSpacing: item.value[gLetterSpacing],
            ),
            decoration: InputDecoration(
              labelText: datamodel.getSCurrent(item.value[gLabel]),
              labelStyle: TextStyle(
                //color: item.value[gTextFontColor],
                fontSize: item.value[gFontSize],
                fontStyle: item.value[gFontStyle],
                fontWeight: item.value[gFontWeight],
                letterSpacing: item.value[gLetterSpacing],
              ),
              hintText: item.value[gPlaceHolder],
              hintStyle: TextStyle(
                //color: item.value[gTextFontColor],
                fontSize: item.value[gFontSize],
                fontStyle: item.value[gFontStyle],
                fontWeight: item.value[gFontWeight],
                letterSpacing: item.value[gLetterSpacing],
              ),
              suffixIcon: item.value[gSuffixIcon],
              //prefixIcon: item.value['prefixIcon'],
            ),
            obscureText: isPassword && item.value[gPasswordShow],
            validator: (String value) {
              if (item.value[gRequired] && value.isEmpty) {
                return datamodel
                    .getSCurrent(gIsrequired + "{" + item.value[gLabel] + "}");
                //return S.of(context).isrequired(item.value['label']);
              }
              if (item.value[gType] == gEmail &&
                  !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                return datamodel.getSCurrent(gInvalidname + "{" + gEmail + "}");
                //return S.of(context).invalidname(S.of(context).email);
              }
              if (item.value[gMinLength] != null &&
                  item.value[gMinLength] != '0' &&
                  value.length < item.value[gMinLength]) {
                /*return S
                  .of(context)
                  .mininput(item.value[gMinLength], item.value[gUnit]);*/
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
                /*return S
                  .of(context)
                  .maxinput(item.value[gLength], item.value[gUnit]);*/
              }
              return null;
            },
            /*initialValue: item.value[gValue] != null
              ? item.value[gValue]
              : (item.value[gDefaultValue] != null
                  ? item.value[gDefaultValue]
                  : ""),*/
            onSaved: (String value) {
              item.value[gValue] = value;
            },
            onChanged: (text) {
              _debouncer.run(() => textChange(text, item, datamodel, context));
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

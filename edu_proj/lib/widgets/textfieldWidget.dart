// @dart=2.9
import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  final MapEntry<dynamic, dynamic> item;

  TextFieldWidget({
    this.item,
  });

  _getWidth() {
    return item.value[gWidth];
  }

  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return Container(
        width: _getWidth(),
        child: TextFormField(
          controller: item.value[gTxtEditingController],
          autofocus: true,
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
          obscureText: (item.value[gType] == gPassword),
          validator: (String value) {
            if (item.value[gRequired] && value.isEmpty) {
              return datamodel.getSCurrent([gIsrequired, item.value[gLabel]]);
              //return S.of(context).isrequired(item.value['label']);
            }
            if (item.value[gType] == gEmail &&
                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
              return datamodel.getSCurrent([gInvalidname, gEmail]);
              //return S.of(context).invalidname(S.of(context).email);
            }
            if (item.value[gMinLength] != '0' &&
                value.length < item.value[gMinLength]) {
              /*return S
                  .of(context)
                  .mininput(item.value[gMinLength], item.value[gUnit]);*/
              return datamodel.getSCurrent(
                  [gMininput, item.value[gMinLength], item.value[gUnit]]);
            }
            if (item.value[gLength] != '0' &&
                value.length > item.value[gLength]) {
              return datamodel.getSCurrent(
                  [gMaxinput, item.value[gLength], item.value[gUnit]]);
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
        ),
      );
    });
  }
}

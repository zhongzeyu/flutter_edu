import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'myLabel.dart';

class MyDropdown extends StatelessWidget {
  final MapEntry<dynamic, dynamic> item;
  final dynamic _formName;
  final int backcolor;
  MyDropdown(this.item, this._formName, this.backcolor);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      //List itemList = datamodel.dpList[item.value[gDroplist]];
      dynamic itemvalue = item.value[gValue];
      Color cBackColor = datamodel.fromBdckcolor(backcolor);
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InputDecorator(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(12, 12, 8, 0),
                labelText: datamodel.getSCurrent(item.value[gLabel]),
                filled: true,
                labelStyle: TextStyle(
                  color: cBackColor,
                  fontSize: item.value[gFontSize],
                  fontStyle: item.value[gFontStyle],
                  fontWeight: item.value[gFontWeight],
                  letterSpacing: item.value[gLetterSpacing],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<dynamic>(
                    isExpanded: true,
                    hint: MyLabel({
                      gLabel: "Please select",
                    }, backcolor),
                    style: TextStyle(
                      color: cBackColor,
                      fontSize: item.value[gFontSize],
                      fontStyle: item.value[gFontStyle],
                      fontWeight: item.value[gFontWeight],
                      letterSpacing: item.value[gLetterSpacing],
                    ),
                    value: itemvalue,
                    icon: Icon(
                      Icons.arrow_downward,
                      color: cBackColor,
                    ),
                    onChanged: (dynamic newValue) {
                      datamodel.setDropdownMenuItem(
                          item.value, newValue, context, _formName);
                    },
                    items: datamodel
                        .getDpListByKey(
                            item.value[gDroplist], context, item.value[gValue])
                        .map<DropdownMenuItem<dynamic>>((dynamic value) {
                      return DropdownMenuItem<dynamic>(
                        value: value,
                        child: MyLabel({
                          gLabel: datamodel.getSCurrent(value),
                        }, cBackColor.value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      );
    });
  }
}

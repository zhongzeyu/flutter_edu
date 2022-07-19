import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLabel extends StatelessWidget {
  final dynamic _param;
  final int backcolor;
  MyLabel(this._param, this.backcolor);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      if (_param != null && (_param[gLabel] ?? _param[gValue]) != null) {
        Color labelColor = Colors.black;
        if (backcolor != null) {
          labelColor = datamodel.fromBdckcolor(backcolor);
        }
        Text text = Text(
          datamodel.getSCurrent(_param[gLabel] ?? _param[gValue]),
          //textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: _param[gFontWeight], //FontWeight.bold,
            fontSize: _param[gFontSize],
            color: labelColor,
            //backgroundColor: _param[gBackgroundColor]
          ),
        );
        if (_param[gAction] == null || _param[gAction] != gTextLink) {
          return text;
        }
        return Material(
          child: InkWell(
            child: text,
            onTap: () {
              datamodel.sendRequestOne(
                  gLocalAction, _param, this._param[gContext] ?? context);
            },
          ),
        );
      }
      return Text("");
    });
  }
}

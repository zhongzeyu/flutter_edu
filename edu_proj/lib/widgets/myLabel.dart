import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLabel extends StatelessWidget {
  final dynamic _param;
  MyLabel(this._param);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      if (_param != null && (_param[gLabel] ?? _param[gValue]) != null) {
        Text text = Text(
          datamodel.getSCurrent(_param[gLabel] ?? _param[gValue]),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _param[gFontSize],
              color: _param[gColor],
              backgroundColor: _param[gBackgroundColor]),
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

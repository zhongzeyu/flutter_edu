// @dart=2.9
import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextFieldWidgetOne extends StatelessWidget {
  final dynamic _param;
  TextFieldWidgetOne(this._param);

  _getWidth() {
    return _param[gValue][gWidth];
  }

  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return SizedBox(
        width: _getWidth(),
        child: TextField(
          controller: _param[gValue][gTxtEditingController],
          autofocus: _param[gValue][gFocus] ?? true,
          decoration: InputDecoration(
            //border: OutlineInputBorder(),
            labelText: datamodel.getSCurrent(_param[gValue][gLabel]),
          ),
        ),
      );
    });
  }
}

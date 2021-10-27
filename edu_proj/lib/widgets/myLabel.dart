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
      return Text(
        datamodel.getSCurrent(_param[gLabel]),
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _param[gFontSize],
            color: _param[gColor],
            backgroundColor: _param[gBackgroundColor]),
      );
    });
  }
}

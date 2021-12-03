import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyIcon extends StatelessWidget {
  final dynamic _param;
  MyIcon(this._param);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return IconButton(
        icon: Icon(IconData(_param[gValue], fontFamily: 'MaterialIcons')),
        tooltip: (_param[gLabel] != null)
            ? (datamodel.getSCurrent(_param[gLabel]))
            : "",
        //  _param[gLabel] ? (datamodel.getSCurrent(_param[gLabel]) ?? "") : "",
        onPressed: () {
          if (_param[gAction] != null &&
              _param[gAction].toString().length > 0) {
            datamodel.sendRequestOne(
                _param[gAction], _param, this._param[gContext] ?? context);
          }
        },
      );
    });
  }
}

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
        icon: Icon(IconData(_param['value'], fontFamily: 'MaterialIcons')),
        onPressed: () {
          if (_param['action'] != null &&
              _param['action'].toString().length > 0) {
            datamodel.sendRequestOne(_param['action'], '', context);
          }
        },
      );
    });
  }
}

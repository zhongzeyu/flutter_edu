import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'myLabel.dart';

class MyButton extends StatelessWidget {
  final dynamic _param;
  MyButton(this._param);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return Padding(
        padding: EdgeInsets.all(this._param[gPadding] ?? 18.0),
        child: SizedBox(
          child: /*OutlinedButton(
            onPressed: () {
              datamodel.sendRequestOne(
                  _param[gAction], _param, this._param[gContext] ?? context);
            },
            child: MyLabel(_param),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              minimumSize:
                  Size(this._param[gWidth] ?? 200, this._param[gHeight] ?? 40),
            ),
          ),*/
              ElevatedButton(
            onPressed: () {
              datamodel.sendRequestOne(
                  _param[gAction], _param, this._param[gContext] ?? context);
            },
            child: MyLabel(_param),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              minimumSize:
                  Size(this._param[gWidth] ?? 200, this._param[gHeight] ?? 40),
            ),
          ),
        ),
      );
    });
  }
}

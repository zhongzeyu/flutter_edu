import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/myGlass.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'myLabel.dart';

class MyButton extends StatelessWidget {
  final Map _param;
  MyButton(this._param);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      int btnColorValue = _param[gColor] ?? Colors.blue.value;
      Color btnColor = Color(btnColorValue);
      Color backColor = datamodel.fromBdckcolor(btnColorValue);
      if (btnColor == Colors.transparent) {
        backColor = btnColor;
      }

      Map param = {
        gWidth: _param[gWidth] ?? 200.0,
        gHeight: _param[gHeight] ?? 40.0,
        gBorderRadius: _param[gBorderRadius] ?? 10.0,
        gMargin: _param[gMargin] ?? const EdgeInsets.all(1.5),
        gPadding: _param[gPadding] ?? const EdgeInsets.all(1.5),
        //gMargin: const EdgeInsets.all(0.5),
        //gPadding: const EdgeInsets.all(0.5),
        gBlur: _param[gBlur] ?? 10.0,
        gAlignment: _param[gAlignment] ?? Alignment.topLeft,
        gBorder: _param[gBorder] ?? 2.0,
        gColor: btnColor,
        gBackgroundColor: backColor, //Color.fromARGB(255, 218, 165, 32),
        gChild: MyLabel(_param, btnColor.value)
      };
      return InkWell(
        child: MyGlass(param),
        onTap: () {
          if (_param[gType].toString().startsWith(gTab)) {
            datamodel.processTapBasic(
                this._param[gContext] ?? context, _param, _param[gName], true);
            //} else if (_param[gAction] == null || _param[gAction] != gTextLink) {
          } else if (!datamodel.isNull(this._param[gAction] ?? '')) {
            datamodel.sendRequestOne(
                _param[gAction], _param, this._param[gContext] ?? context);
          } else {
            datamodel.sendRequestOne(
                gLocalAction, _param, this._param[gContext] ?? context);
          }
        },
      );
      /*Map param = {
        gWidth: this._param[gWidth] ?? 200,
        gHeight: this._param[gHeight] ?? 30,
        gBorderRadius: _param[gBorderRadius] ?? 10.0,
        gMargin: _param[gMargin] ?? const EdgeInsets.all(1.5),
        gPadding: _param[gPadding] ?? const EdgeInsets.all(1.5),
        gBlur: _param[gBlur] ?? 10.0,
        gAlignment: _param[gAlignment] ?? Alignment.center,
        gBorder: _param[gBorder] ?? 2.0,
        gColor: Colors.blue,
        gBackgroundColor: _param[gBackgroundColor] ??
            Colors.white.value, //Color.fromARGB(255, 218, 165, 32),
        gChild: Text("test"), //MyLabel(_param)
      };
      return MyGlass(param);*/

      /*return Padding(
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
              /*datamodel.sendRequestOne(
                  _param[gAction], _param, this._param[gContext] ?? context);*/
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
      );*/
    });
  }
}

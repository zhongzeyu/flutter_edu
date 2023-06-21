import 'package:edu_proj/config/constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/myGlass.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'myIcon.dart';
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

      int icon = 0;
      if (!datamodel.isNull(_param[gIcon])) {
        icon = _param[gIcon];
      }
      double iconSize = _param[gIconSize] ?? 60.0;
      Map param = {
        gWidth: (icon > 0) ? iconSize : _param[gWidth] ?? 200.0,
        gHeight: (icon > 0) ? iconSize : _param[gHeight] ?? 40.0,
        gBorderRadius: _param[gBorderRadius] ?? 10.0,
        gMargin: _param[gMargin] ?? const EdgeInsets.all(1.5),
        gPadding: _param[gPadding] ?? const EdgeInsets.all(1.5),
        //gMargin: const EdgeInsets.all(0.5),
        //gPadding: const EdgeInsets.all(0.5),
        gBlur: _param[gBlur] ?? 10.0,
        gAlignment: _param[gAlignment] ?? Alignment.topLeft,
        gBorder: _param[gBorder] ?? 0.5,
        gColor: btnColor,
        gBackgroundColor: backColor,
        //gBackgroundColor: Colors.transparent.value,
        gChild: (icon > 0)
            ? Icon(
                IconData(
                  icon,
                  fontFamily: 'MaterialIcons',
                ),
                //color: Colors.green
              )
            : MyLabel(_param, btnColor.value)
      };
      return InkWell(
        child: (icon > 0)
            ? Column(
                children: [
                  MyGlass(param),
                  MyLabel({
                    gLabel: _param[gLabel] ?? _param[gValue],
                    gFontSize: 12.0
                  }, _param[gBackgroundColor] ?? Colors.black.value),
                  (_param[gIconSize] == null)
                      ? SizedBox(height: 10.0)
                      : SizedBox(height: 0.5)
                ],
              )
            : MyGlass(param),
        onTap: () {
          print('===========   myButton click');
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
    });
  }
}

import 'package:edu_proj/config/constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLabel extends StatelessWidget {
  final dynamic _param;
  final int backcolor;
  MyLabel(this._param, this.backcolor);

  @override
  Widget build(BuildContext context) {
    int thisbackcolor = backcolor;
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      if (_param != null && (_param[gLabel] ?? _param[gValue]) != null) {
        Color labelColor = Colors.black;
        labelColor = datamodel.fromBdckcolor(thisbackcolor);
        /*if (backcolor == Colors.transparent.value) {
          labelColor = Colors.black;
        }*/
        Text text;
        var value = _param[gLabel] ?? _param[gValue] ?? "";

        var showValue =
            (_param[gNeedi10n] ?? true) ? datamodel.getSCurrent(value) : value;
        if (datamodel.isNull(_param[gOriginalValue]) ||
            (_param[gOriginalValue] ?? "") == value) {
          text = Text(
            showValue,
            textAlign: _param[gAlign] ?? TextAlign.center,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: (datamodel.isNull(_param[gIsBold]))
                    ? _param[gFontWeight]
                    : FontWeight.bold, //FontWeight.bold,
                fontSize: _param[gFontSize] ?? datamodel.defaultFontSize,
                color: _param[gColorLabel] ?? labelColor,
                decoration: _param[gTextDecoration]

                //backgroundColor: Colors.transparent
                ),
          );
        } else {
          text = Text.rich(TextSpan(
              text: (_param[gNeedi10n] ?? true)
                  ? datamodel.getSCurrent(_param[gOriginalValue])
                  : _param[gOriginalValue],
              style: TextStyle(
                color: labelColor,
                decoration: _param[gTextDecoration],
                fontSize: _param[gFontSize] ?? datamodel.defaultFontSize,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: ' -> \r\n',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: labelColor,
                      fontSize: _param[gFontSize] ?? datamodel.defaultFontSize,
                    )),
                TextSpan(
                    text: showValue,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _param[gColorLabel] ?? labelColor,
                      fontSize: _param[gFontSize] ?? datamodel.defaultFontSize,
                    )),
              ]));
        }
        //if (_param[gAction] == null || _param[gAction] != gTextLink) {
        return text;
        //}
        /*return Material(
          child: InkWell(
            child: text,
            onTap: () {
              datamodel.sendRequestOne(
                  gLocalAction, _param, this._param[gContext] ?? context);
            },
          ),
        );*/
      }
      return Text("");
    });
  }
}

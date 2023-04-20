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
    int thisbackcolor = backcolor ?? Colors.black.value;
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      if (_param != null && (_param[gLabel] ?? _param[gValue]) != null) {
        Color labelColor = Colors.black;
        if (thisbackcolor != null) {
          labelColor = datamodel.fromBdckcolor(thisbackcolor);
        }
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
            //textAlign: TextAlign.left,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: (datamodel.isNull(_param[gIsBold]))
                  ? _param[gFontWeight]
                  : FontWeight.bold, //FontWeight.bold,
              fontSize: _param[gFontSize],
              color: _param[gColorLabel] ?? labelColor,
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
              ),
              children: <TextSpan>[
                TextSpan(
                    text: ' -> \r\n',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: labelColor,
                    )),
                TextSpan(
                    text: showValue,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _param[gColorLabel] ?? labelColor,
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

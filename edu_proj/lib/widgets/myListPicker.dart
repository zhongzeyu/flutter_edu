import 'package:edu_proj/config/constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyListPicker extends StatelessWidget {
  final Map _param;
  /*
  param = {
      gHeight: 200.0,
      gSelectedList: selectedIndex,
      gData: sListValue
    };
    ex:
    gHeight: 200.0,
    gSelectedList: [52,1,17],
    gData:[gYear, gMonth, gDay]
   ,
  */
  int backcolor;

  MyListPicker(this._param, this.backcolor);

  @override
  Widget build(BuildContext context) {
    /*Map param = {
      gHeight: 200.0,
      gSelectedList: [10, 10, 10],
      gData: [gYear, gMonth, gDay],
      gWidth: [100.0, 50.0, 50.0]
    };*/

    return Consumer<DataModel>(builder: (context, datamodel, child) {
      double height =
          (_param[gHeight]) ?? MediaQuery.of(context).size.height * 0.4;
      double width = MediaQuery.of(context).size.width * 0.9;
      //print('========== dplist is ' +          datamodel.dpList[_param[gData][0]].toString());

      Color labelColor = Colors.black;
      labelColor = datamodel.fromBdckcolor(backcolor);

      List selectedList = _param[gSelectedList];

      List<Widget> widgetList = [];
      for (int i = 0; i < selectedList.length; i++) {
        if (i != 0) {
          widgetList.add(SizedBox(
            width: 10.0,
          ));
        }

        Widget picker = datamodel.getPicker(_param, i, labelColor, backcolor);
        widgetList.add(SizedBox(
          height: height,
          width: _param[gWidth][i] ?? width,
          child: picker,
        ));
      }
      return SizedBox(height: height, child: Row(children: widgetList));

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

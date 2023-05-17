import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'myLabel.dart';

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
  final int backcolor;
  final List actions;
  MyListPicker(this._param, this.backcolor, this.actions);

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
      bool isLabel = false;
      if (_param[gIsLabel] ?? false) {
        isLabel = true;
      }
      bool isIcon = false;
      if (_param[gIsIcon] ?? false) {
        isIcon = true;
      }

      Color labelColor = Colors.black;
      if (backcolor != null) {
        labelColor = datamodel.fromBdckcolor(backcolor);
      }

      List selectedList = _param[gSelectedList];
      List<Widget> widgetList = [];
      for (int i = 0; i < selectedList.length; i++) {
        if (i != 0) {
          widgetList.add(SizedBox(
            width: 10.0,
          ));
        }
        List dataList = List.of(datamodel.dpList[_param[gData][i]]);
        widgetList.add(SizedBox(
          height: height,
          width: _param[gWidth][i] ?? width,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
                initialItem: _param[gSelectedList][i]),
            //diameterRatio: 1.5,
            //offAxisFraction: 0.2, //轴偏离系数
            //useMagnifier: false, //使用放大镜
            //magnification: 1.5, //当前选中item放大倍数
            itemExtent: 40.0, //行高
            onSelectedItemChanged: (value) {
              datamodel.dpListDefaultIndex[_param[gData][i]] = value;
              /*_param[gRow] = i;
              _param[gIndex] = value;
              _param[gSelectedList][i] = value;
              datamodel.sendRequestOne(
                  _param[gAction], _param, this._param[gContext] ?? context);*/
            },
            //children: datamodel.dpList[param[gData][i]].map((data) {
            children: (dataList).map((data) {
              return isLabel
                  ? Text(data,
                      style: TextStyle(
                        fontWeight: (datamodel.isNull(_param[gIsBold]))
                            ? _param[gFontWeight]
                            : FontWeight.bold, //FontWeight.bold,
                        fontSize: _param[gFontSize],
                        color: labelColor,
                        //backgroundColor: Colors.transparent
                      ))
                  : isIcon
                      ? Row(children: [
                          SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                              child:
                                  MyLabel({gLabel: data[gLabel]}, backcolor)),
                          Icon(
                              IconData(
                                data[gValue],
                                fontFamily: 'MaterialIcons',
                              ),
                              size: 36.0,
                              color: Colors.white),
                          SizedBox(
                            width: 5.0,
                          )
                        ])
                      : MyLabel({gLabel: data}, backcolor);
            }).toList(),
          ),
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

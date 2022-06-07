// @dart=2.9
import 'dart:convert';

import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/MyForm.dart';
import 'package:edu_proj/widgets/myButton.dart';
import 'package:edu_proj/widgets/myIcon.dart';
import 'package:edu_proj/widgets/myLabel.dart';
//import 'package:edu_proj/widgets/myTab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyItem extends StatelessWidget {
  final dynamic _param;
  MyItem(this._param);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      if (_param[gType] == null) {
        return null;
      }
      List<Widget> result = [];
      if (_param[gType] == gBtn) {
        result.add(MyButton(_param));
      } else if (_param[gType] == gForm) {
        String formID = _param[gValue];

        //datamodel.setFormListOne(formID, _param);

        result.add(Expanded(child: MyForm(formID)));
      } else if (_param[gType] == gIcon) {
        result.add(MyIcon(_param));
      } else if (_param[gType] == gImg) {
        //var imgOriginal = _param[gValue];
        var imgOriginal = datamodel.imgList[_param[gValue]] ??
            datamodel.imgList[gNotavailable];
        result.add(Image.memory(
          base64.decode(imgOriginal),
          fit: BoxFit.fill,
          gaplessPlayback: true,
          height: (_param[gHeight] != null) ? _param[gHeight] : null,
          width: (_param[gWidth] != null) ? _param[gWidth] : null,
        ));
        if (_param[gLabel] != null) {
          result.add(SizedBox(width: gDefaultPaddin));
          result.add(MyLabel(_param));
        }
      } else if (_param[gType] == gLabel) {
        result.add(MyLabel(_param));
      } else if (_param[gType] == gTextLink) {
        _param[gAction1] = _param[gAction];
        _param[gAction] = gTextLink;
        result.add(MyLabel(_param));
      } else if (_param[gType] == gSizedbox) {
        result.add(SizedBox(height: _param[gValue]));
      } else if (_param[gType] == gTab) {
        String tabID = _param[gValue];
        var tab = datamodel.getTab(tabID, context);
        if (tab == null) {
          result.add(SizedBox(width: 100.0));
          return result[0];
        }
        //var tabData = tab[gData];
        result.add(Expanded(
          //height: 50,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tab[gData].length,
                  itemBuilder: (context, index) =>
                      datamodel.getTabByIndex(index, tabID),
                ),
              ),
              Expanded(child: datamodel.getTabBody(tabID, context))
            ],
          ),
        ));
        //result.add(Expanded(child: datamodel.getTabBody(tabID, context)));
      } else {
        result.add(MyLabel({gLabel: "not available", gFontSize: 20.0}));
      }

      if (result.length > 1) {
        Widget aRow =
            Row(mainAxisAlignment: MainAxisAlignment.center, children: result);
        return aRow;
      }
      return result[0];
    });
    //return Image.asset('/images/' + _param['img'], package: packageName);

    /*return Image(
      image: NetworkImage(_param[gImg]),
      fit: BoxFit.fitWidth,
    );*/
    //return Image.network(_param[gImg]);
    //return FittedBox(child: Image.network(_param[gImg]), fit: BoxFit.fitHeight);
  }
}

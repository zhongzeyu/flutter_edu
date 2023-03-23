// @dart=2.9
import 'dart:convert';

import 'package:edu_proj/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/MyConfig.dart';
import '../models/DataModel.dart';

class MyPic extends StatelessWidget {
  final dynamic _param;
  MyPic(this._param);

  @override
  Widget build(BuildContext context) {
    //return Image.asset('/images/' + _param['img'], package: packageName);
    if (_param[gImg] == null) {
      return null;
    }
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      if (_param[gImg].toString().toLowerCase().indexOf('http') > -1) {
        var imgName = _param[gImg]
            .toString()
            .substring(_param[gImg].toString().lastIndexOf('/') + 1);
        var imgUrl = 'http://' + MyConfig.URL.name + '/images/' + imgName;
        if (!datamodel.imgCache.containsKey(imgName)) {
          print('=================' + imgUrl);
          datamodel.imgCache[imgName] = Image(
            image: NetworkImage(imgUrl),
            fit: BoxFit.fitWidth,
          );
        }

        return datamodel.imgCache[imgName];
      }
      print('=================img height is ' + _param[gHeight] ?? null);
      return Image.memory(
        base64.decode(_param[gImg]),
        fit: BoxFit.fill,
        gaplessPlayback: true,
        height: _param[gHeight] ?? null,
        width: _param[gWidth] ?? null,
      );
    });

    /*return Image(
      image: NetworkImage(_param[gImg]),
      fit: BoxFit.fitWidth,
    );*/
    //return Image.network(_param[gImg]);
    //return FittedBox(child: Image.network(_param[gImg]), fit: BoxFit.fitHeight);
  }
}

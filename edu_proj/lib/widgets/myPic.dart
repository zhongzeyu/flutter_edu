import 'dart:convert';

import 'package:edu_proj/config/constants.dart';
import 'package:flutter/material.dart';

class MyPic extends StatelessWidget {
  final dynamic _param;
  MyPic(this._param);

  @override
  Widget build(BuildContext context) {
    //return Image.asset('/images/' + _param['img'], package: packageName);
    if (_param[gImg] == null) {
      return null;
    }
    return Image.memory(base64.decode(_param[gImg]),
        fit: BoxFit.fill, gaplessPlayback: true);
    /*return Image(
      image: NetworkImage(_param[gImg]),
      fit: BoxFit.fitWidth,
    );*/
    //return Image.network(_param[gImg]);
    //return FittedBox(child: Image.network(_param[gImg]), fit: BoxFit.fitHeight);
  }
}

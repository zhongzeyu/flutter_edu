import 'package:edu_proj/business/businessConfig.dart';
import 'package:flutter/material.dart';

class MyPic extends StatelessWidget {
  final dynamic _param;
  MyPic(this._param);

  @override
  Widget build(BuildContext context) {
    return Image.asset('/images/' + _param['img'], package: packageName);
  }
}

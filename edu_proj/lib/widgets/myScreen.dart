import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyScreen extends StatelessWidget {
  final Map _param;
  final int _backcolor;
  MyScreen(this._param, this._backcolor);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      List screenItems = datamodel.getScreenItems(_param, context, _backcolor);

      //return SingleChildScrollView(
      Widget w = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: screenItems,
      );

      return w;
    });
  }
}

import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDynamicBody extends StatelessWidget {
  final dynamic _param;
  MyDynamicBody(this._param);
  //final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: datamodel.getDynamicWidgets(_param, context, null),
        ),
      );
    });
  }
}

import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Radios extends StatelessWidget {
  final List _param;
  Radios(this._param);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: datamodel.getRadios(_param, context),
        ),
      );
    });
  }
}

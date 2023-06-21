// ignore: import_of_legacy_library_into_null_safe
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PicsAndLabels extends StatelessWidget {
  final dynamic _param;
  final int backcolor;
  PicsAndLabels(this._param, this.backcolor);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return Column(
        children: datamodel.getPics(_param, backcolor),
      );
    });
  }
}

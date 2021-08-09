import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/myLabel.dart';
import 'package:edu_proj/widgets/picsAndLabels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PicsAndButtons extends StatelessWidget {
  final Map _param;
  PicsAndButtons(this._param);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PicsAndLabels(_param),
          SizedBox(height: 120),
          MyLabel(datamodel.getParamTypeValue(_param['title'])),
          SizedBox(height: 150),
          datamodel.getButtons(Map.of(_param)),
          SizedBox(height: gDefaultPaddin),
        ],
      );
    });
  }
}

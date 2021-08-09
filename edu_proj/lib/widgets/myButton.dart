import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'myLabel.dart';

class MyButton extends StatelessWidget {
  final dynamic _param;
  MyButton(this._param);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () {
                datamodel.sendRequestOne(_param['action'], '', context);
              },
              child: MyLabel(_param)),
        ),
      );
    });
  }
}

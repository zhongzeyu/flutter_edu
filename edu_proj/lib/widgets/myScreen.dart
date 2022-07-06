import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import '../config/constants.dart';

class MyScreen extends StatelessWidget {
  final Map _param;
  MyScreen(this._param);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      List screenItems = datamodel.getScreenItems(_param, context);
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: screenItems,
          ),
        ),
      );
    });
  }
}

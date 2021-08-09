import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatelessWidget {
  final String _name;
  FirstPage(this._name);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      Widget aScreen = datamodel.getFirstPage(_name);
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [datamodel.getLocalComponents()]),
          ),
          //Expanded(child: PicsAndButtons(datamodel.screenLists[_name])),
          Expanded(child: aScreen),
        ],
      );
    });
  }
}

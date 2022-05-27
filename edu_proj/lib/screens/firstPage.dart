import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/myScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatelessWidget {
  final MyScreen _aScreen;
  FirstPage(this._aScreen);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      //Widget aScreen = datamodel.getFirstPage(_name);
      return SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [datamodel.getLocalComponents(context)]),
            ),
            //Expanded(child: PicsAndButtons(datamodel.screenLists[_name])),
            Expanded(child: _aScreen),
          ],
        ),
      );
    });
  }
}

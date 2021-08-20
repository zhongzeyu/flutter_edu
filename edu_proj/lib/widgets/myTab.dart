import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyTab extends StatelessWidget {
  final dynamic _param;
  MyTab(this._param);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: datamodel.tabList[_param]['data'].length,
                itemBuilder: (context, index) =>
                    datamodel.getTabByIndex(index, _param),
              ),
            ),
          ),
          Expanded(
            child: datamodel.getTabBody(_param, context),
          ),
        ],
      );
    });
  }
}

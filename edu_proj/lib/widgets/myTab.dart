import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyTab extends StatelessWidget {
  final dynamic _param;
  final int backcolor;
  MyTab(this._param, this.backcolor);
  //final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: datamodel.tabList[_param][gData].length,
                  itemBuilder: (context, index) =>
                      datamodel.getTabByIndex(index, _param),
                ),
              ),
            ),
          ),
          Expanded(
            child: datamodel.getTabBody(_param, context, backcolor),
          ),
        ],
      );
    });
  }
}

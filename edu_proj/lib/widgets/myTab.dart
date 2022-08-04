import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MyTab extends StatelessWidget {
  final dynamic _param;
  final int backcolor;
  final ItemScrollController itemScrollController = ItemScrollController();

  /// Listener that reports the position of items when the list is scrolled.
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  MyTab(this._param, this.backcolor);
  //final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      datamodel.tabList[_param][gController] = itemScrollController;
      datamodel.tabList[_param][gControllerListener] = itemPositionsListener;
      return Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40.0,

                //child: ListView.builder(
                child: ScrollablePositionedList.builder(
                  itemCount: datamodel.tabList[_param][gData].length,
                  itemBuilder: (context, index) =>
                      datamodel.getTabByIndex(index, _param),
                  itemScrollController: datamodel.tabList[_param][gController],
                  itemPositionsListener: datamodel.tabList[_param]
                      [gControllerListener],
                  scrollDirection: Axis.horizontal,
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

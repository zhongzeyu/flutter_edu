// @dart=2.9
import 'package:edu_proj/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_proj/models/DataModel.dart';

class MyMain extends StatefulWidget {
  const MyMain({key}) : super(key: key);

  @override
  _MyMainState createState() => _MyMainState();
}

class _MyMainState extends State<MyMain> with TickerProviderStateMixin {
  /*TabController _tabController;
  @protected
  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(initialIndex: 0, length: 1, vsync: this); // 直接传this

    print("---->${_tabController.previousIndex}");

    if (_tabController.indexIsChanging) {
      print("---->indexch");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    /*getMenuItems(List mainItem, DataModel datamodel) {
      List<Widget> items = [];
      mainItem.forEach((element) {
        Map<String, String> map = {};
        element.entries.forEach((e) {
          map[e.key] = e.value;
        });
        items.add(ListTile(
          leading: Icon(datamodel.getIconsByName(map['icon'])),
          title: MyLabel({gLabel: map[gLabel] + '', 'fontSize': 20.0}),
          onTap: () {
            datamodel.onTap(context, map);
          },
          //onTap: datamodel.onTap(context, map),
        ));
      });
      return items;
    }*/

    getItemActions(List actionItem, DataModel datamodel) {
      if (actionItem == null) {
        return null;
      }
      List<Widget> items = [];
      items.add(datamodel.getLocalComponents(context));
      actionItem.forEach((element) {
        Map<String, dynamic> map = Map.of(element);
        /*{};
        element.entries.forEach((e) {
          map[e.key] = e.value;
        });*/
        items.add(IconButton(
          icon: Icon(datamodel.getIconsByName(map[gIcon])),
          tooltip: map[gLabel] + '',
          onPressed: () {
            datamodel.onTap(context, map);
          },
          //onTap: datamodel.onTap(context, map),
        ));
      });
      return items;
    }

    return Consumer<DataModel>(
      builder: (context, datamodel, child) {
        Map<String, dynamic> formDefine = datamodel.formLists[gLogin];
        //datamodel.setTabParent(this);
        //datamodel.initTabController(context);
        /*String myTitle =
            datamodel.getSCurrent(datamodel.systemParams['systemTitle']);*/

        return Scaffold(
          backgroundColor: Colors.red,
          appBar: AppBar(
            title: Text(
                datamodel.getSCurrent(datamodel.systemParams[gSystemTitle])),
            actions: getItemActions(datamodel.actionLists[gMain], datamodel),
          ),
          drawer: Drawer(
            child: MediaQuery.removePadding(
              context: context,
              // DrawerHeader consumes top MediaQuery padding.
              removeTop: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 38.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ClipOval(
                            child: Icon(Icons.person_outline),
                          ),
                        ),
                        Text(
                          formDefine[gItems][gEmail][gDefaultValue],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: datamodel.getMenuItems(gMain, context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: datamodel.getMyBody(gMain),
        );
      },
    );
  }
}

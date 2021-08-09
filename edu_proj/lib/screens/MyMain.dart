import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_proj/models/DataModel.dart';

class MyMain extends StatefulWidget {
  const MyMain({key}) : super(key: key);

  @override
  _MyMainState createState() => _MyMainState();
}

class _MyMainState extends State<MyMain> with TickerProviderStateMixin {
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
          title: MyLabel({'label': map['label'] + '', 'fontSize': 20.0}),
          onTap: () {
            datamodel.onTap(context, map);
          },
          //onTap: datamodel.onTap(context, map),
        ));
      });
      return items;
    }*/

    getItemActions(List actionItem, DataModel datamodel) {
      List<Widget> items = [];
      items.add(datamodel.getLocalComponents());
      actionItem.forEach((element) {
        Map<String, String> map = {};
        element.entries.forEach((e) {
          map[e.key] = e.value;
        });
        items.add(IconButton(
          icon: Icon(datamodel.getIconsByName(map['icon'])),
          tooltip: map['label'] + '',
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
        Map<String, dynamic> formDefine = datamodel.formLists['login'];
        //datamodel.setTabParent(this);
        //datamodel.initTabController(context);
        /*String myTitle =
            datamodel.getSCurrent(datamodel.systemParams['systemTitle']);*/

        return Scaffold(
          appBar: AppBar(
            /*IconButton(
              icon: Icon(Icons.menu),
              onPressed: null,
            ),*/
            title: Text(
                datamodel.getSCurrent(datamodel.systemParams['systemTitle'])),
            actions: getItemActions(datamodel.actionLists['main'], datamodel),
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
                            child: Icon(Icons.person),
                          ),
                        ),
                        Text(
                          formDefine['items']['email']['defaultValue'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: datamodel.getMenuItems(
                          datamodel.menuLists['main'], context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            //padding: EdgeInsets.all(5.0),
            child: Text(
                datamodel.getSCurrent("changepassword")), //datamodel.tabWidget,
          ),
        );
      },
    );
  }
}

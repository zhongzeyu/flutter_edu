import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/myScreen.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDetailNew extends StatelessWidget {
  final Map _param;
  MyDetailNew(this._param);

  @override
  Widget build(BuildContext context) {
    List mapActions = [];
    List mapBottoms = [];
    _param.forEach((key, value) {
      if (value == null) {
        return;
      }
      Map mapItem = Map.of(value);
      if (mapItem == null) {
        return;
      }

      mapItem.forEach((key1, value1) {
        if (key1 == gActions) {
          mapActions = value1;
          /*for (int i = 0; i < value1.length; i++) {
            mapActions.add(Map.of(value1[i]));
          }*/
        } else if (key1 == gBottoms) {
          mapBottoms = value1;
          /*for (int i = 0; i < value1.length; i++) {
            mapBottoms.add(Map.of(value1[i]));
          }*/
        }
      });
    });
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      //Size size = MediaQuery.of(context).size;
      var aTxt = "";
      if (!datamodel.isNull(datamodel.formLists[gLogin])) {
        aTxt = datamodel.formLists[gLogin][gItems][gEmail][gDefaultValue];
      }
      Widget aWidget = Text(
        aTxt,
        style: TextStyle(fontWeight: FontWeight.bold),
      );
      return Scaffold(
          //backgroundColor: _param[gBackgroundColor],
          appBar: AppBar(
            //backgroundColor: _param[gColor],
            //elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: datamodel.getTitle(_param, context),

            //title: const TextBox(),
            actions:
                //other icons
                //datamodel.getScreenItems(mapActions,context),
                datamodel.getActions(mapActions, context),
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
                        aWidget
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
          body: SafeArea(
            child: Column(
              children: [
                //Expanded(child: PicsAndButtons(datamodel.screenLists[_name])),
                Expanded(child: MyScreen(_param)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: datamodel.getScreenItemsList(mapBottoms, context)
                    //datamodel.getActions({gActions: mapBottoms}, context)),
                    ),
              ],
            ),
          )
          /*Stack(
            //clipBehavior: Clip.none,
            //fit: StackFit.expand,
            alignment: AlignmentDirectional.topEnd,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 9,
                child: MyScreen(_param),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  //color: Colors.blueGrey,
                  //child: datamodel.getDetailBottom(mapBottoms, context),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          datamodel.getScreenItemsList(mapBottoms, context)
                      //datamodel.getActions({gActions: mapBottoms}, context)),
                      ),
                ),
              ),
            ],
          )*/
          );
    });
  }
}

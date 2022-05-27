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
      Map mapItem = Map.of(value);
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
      return Scaffold(
          //backgroundColor: _param[gBackgroundColor],

          appBar: AppBar(
            //backgroundColor: _param[gColor],
            elevation: 0,
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
          body: Stack(
            //clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 82,
                child: Container(
                  //color: Colors.yellow,
                  child: MyScreen(_param),
                ),
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
          ));
    });
  }
}

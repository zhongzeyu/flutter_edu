import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/myGlass.dart';
import 'package:edu_proj/widgets/myScreen.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/myPic.dart';

class MyDetailNew extends StatelessWidget {
  final Map _param;
  final int backcolor;
  MyDetailNew(this._param, this.backcolor);

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
      /*var aTxt = "";
      if (!datamodel.isNull(datamodel.formLists[gLogin])) {
        aTxt = datamodel.formLists[gLogin][gItems][gEmail][gDefaultValue];
      }
      Widget aWidget = Text(
        aTxt,
        style: TextStyle(fontWeight: FontWeight.bold),
      );*/

      //Widget aScreen = datamodel.getFirstPage(_name);
      Map param0 = {
        gWidth: MediaQuery.of(context).size.width,
        gHeight: 45,
        gBorderRadius: 10.0,
        gMargin: const EdgeInsets.all(1.5),
        gPadding: const EdgeInsets.all(5.5),
        gBlur: 10.0,
        gAlignment: Alignment.center,
        gBorder: 2.0,
        gColor: Colors.blue,
        gBackgroundColor: Colors.white, //Color.fromARGB(255, 218, 165, 32),
        gChild: Row(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(child: datamodel.getTitle(_param, context, backcolor)),
              Row(
                  children:
                      datamodel.getActions(mapActions, context, backcolor)),
            ])
      };

      Map param1 = {
        gWidth: MediaQuery.of(context).size.width,
        gHeight: MediaQuery.of(context).size.height - 65,
        gBorderRadius: 10.0,
        gMargin: const EdgeInsets.all(1.5),
        gPadding: const EdgeInsets.all(5.5),
        gBlur: 10.0,
        gAlignment: Alignment.center,
        gBorder: 2.0,
        gColor: Colors.green,
        gBackgroundColor: Colors.white, //Color.fromARGB(255, 218, 165, 32),
        gChild: Column(
          children: [
            //Expanded(child: PicsAndButtons(datamodel.screenLists[_name])),
            Expanded(child: MyScreen(_param, backcolor)),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    datamodel.getScreenItemsList(mapBottoms, context, backcolor)
                //datamodel.getActions({gActions: mapBottoms}, context)),
                ),
          ],
        )
      };

      Map param = {
        gWidth: MediaQuery.of(context).size.width,
        gHeight: MediaQuery.of(context).size.height,
        gBorderRadius: 10.0,
        gMargin: const EdgeInsets.all(1.5),
        gPadding: const EdgeInsets.all(5.5),
        //gMargin: const EdgeInsets.all(0.5),
        //gPadding: const EdgeInsets.all(0.5),
        gBlur: 10.0,
        gAlignment: Alignment.topLeft,
        gBorder: 2.0,
        gColor: Colors.black,
        gBackgroundColor: Colors.white, //Color.fromARGB(255, 218, 165, 32),
        gChild: Column(
          children: [
            MyGlass(param0),
            Expanded(child: MyGlass(param1)),
          ],
        )
      };

      return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Stack(children: [
            Center(
              child: MyPic({gImg: datamodel.imgList[gMain]}),
              //Image.network(datamodel.imgList[gMain]),
            ),
            SafeArea(
              child: MyGlass(param),
            )
          ]),
        ),
      );

      /*return Scaffold(
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
            title: datamodel.getTitle(_param, context, backcolor),

            //title: const TextBox(),
            actions:
                //other icons
                //datamodel.getScreenItems(mapActions,context),
                datamodel.getActions(mapActions, context, backcolor),
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
                      children:
                          datamodel.getMenuItems(gMain, context, backcolor),
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
                Expanded(child: MyScreen(_param, backcolor)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: datamodel.getScreenItemsList(
                        mapBottoms, context, backcolor)
                    //datamodel.getActions({gActions: mapBottoms}, context)),
                    ),
              ],
            ),
          )
          
          );*/
    });
  }
}

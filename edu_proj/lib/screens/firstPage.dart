import 'package:edu_proj/config/constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/myScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/myGlass.dart';
// ignore: import_of_legacy_library_into_null_safe
import '../widgets/myPic.dart';

class FirstPage extends StatelessWidget {
  FirstPage();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      if (datamodel.myDetailIDCurrent != 0) {
        return SizedBox();
      }
      MyScreen _aScreen =
          MyScreen(datamodel.screenLists[gFirstPage], Colors.black.value);

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
              Expanded(child: Text("")),
              datamodel.getLocalComponents(context, Colors.blue.value)
            ])
      };

      /*Map param1 = {
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
        gChild: _aScreen
      };*/

      /*Map param = {
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
      };*/

      return Scaffold(
        body: Stack(children: [
          Center(
            child: MyPic({
              gImg: datamodel.imgList[gMain],
              //gHeight: 30.0,
              gHeight: MediaQuery.of(context).size.height,
              gWidth: MediaQuery.of(context).size.width
            }),
            //Image.network(datamodel.imgList[gMain]),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyGlass(param0),
                  Expanded(child: SingleChildScrollView(child: _aScreen)),
                ],
              ),
            ),
          )
        ]),
      );
    });
  }
}

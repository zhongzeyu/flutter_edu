import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import '../config/constants.dart';

class MyScreen extends StatelessWidget {
  final Map _param;
  final int _backcolor;
  MyScreen(this._param, this._backcolor);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      List screenItems = datamodel.getScreenItems(_param, context, _backcolor);
      //_param[gWidth] = _param[gWidth] ?? MediaQuery.of(context).size.width;
      /*Map param = {
        gWidth: MediaQuery.of(context).size.width,
        gHeight: MediaQuery.of(context).size.height,
        gBorderRadius: 10.0,
        gMargin: const EdgeInsets.all(0.0),
        gPadding: const EdgeInsets.all(0.0),
        gBlur: 10.0,
        gAlignment: Alignment.topLeft,
        gBorder: 2.0,
        gColor: Colors.green,
        gsBackgroundColor: Colors.white, //Color.fromARGB(255, 218, 165, 32),
        gChild: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: screenItems,
          ),
        )
      };
      return MyGlass(param);*/

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: screenItems,
          ),
        ),
      );
    });
  }
}

import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/myLabel.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDetail extends StatelessWidget {
  final Map _param;
  final int backcolor;
  MyDetail(this._param, this.backcolor);

  @override
  Widget build(BuildContext context) {
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
          title: MyLabel(_param, backcolor),
          //title: const TextBox(),
          actions:
              //other icons
              datamodel.getActionIcons(_param, context, backcolor),
        ),
        body: datamodel.getDetailWidget(_param, context, backcolor),
      );
    });
  }
}

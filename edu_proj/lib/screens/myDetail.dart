//import 'package:edu_proj/config/constants.dart';
//import 'package:edu_proj/generated/l10n.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDetail extends StatelessWidget {
  final Map _param;
  MyDetail(this._param);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      //Size size = MediaQuery.of(context).size;
      return Scaffold(
        //backgroundColor: _param['backgroundColor'],
        appBar: AppBar(
          //backgroundColor: _param['color'],
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions:
              //other icons
              datamodel.getActionIcons(_param, context),
        ),
        body: datamodel.getDetailWidget(_param),

        /*SingleChildScrollView(
          //类似于scroll view,只允许一个组件
          child: Stack(
            //层叠布局
            children: <Widget>[
              Container(
                height: size.height - _param['top'] - gDefaultPaddin - 35,
                margin:
                    EdgeInsets.only(top: _param['top'], left: 5.0, right: 5.0),
                decoration: BoxDecoration(
                  //装饰，背景，边框，渐变等
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24), //左上角圆弧
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 0.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: Offset(
                        2.0, // Move to right 10  horizontally
                        2.0, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xf2f2f2f2), _param['backgroundColor']],
                  ),
                ),
              ),
              _param['title'],
              datamodel.getDetailWidget(_param),
            ],
          ),
        ),*/
      );
    });
  }
}

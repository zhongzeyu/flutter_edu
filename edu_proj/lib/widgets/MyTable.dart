//import 'package:edu_proj/config/MyConfig.dart';
import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyTable extends StatelessWidget {
  final Map _param;

  MyTable(this._param);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(
      builder: (context, datamodel, child) {
        final String _tableid = _param['tableid'];
        Map<String, dynamic> tableDefine = datamodel.tableList[_tableid];

        Size size = MediaQuery.of(context).size;
        //double _top = 10.0;

        return Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: tableDefine[
                  'height'], //size.height * formDefine['heightPercent'],
              child: Container(
                //padding: EdgeInsets.all(gDefaultPaddin),
                padding: EdgeInsets.only(
                    left: gDefaultPaddin,
                    right: gDefaultPaddin,
                    bottom: gDefaultPaddin),
                child: Stack(
                  children: [
                    //Column
                    //(
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    //children: [
                    Container(
                      width: size.width - 5,
                      height: tableDefine['height'] -
                          tableDefine['top'] -
                          gDefaultPaddin,

                      margin: EdgeInsets.only(top: tableDefine['top']),
                      padding: EdgeInsets.only(
                          top: gDefaultPaddin,
                          left: gDefaultPaddin,
                          right: gDefaultPaddin),
                      decoration: BoxDecoration(
                        //color: formDefine['backgroundColor'],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
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
                          colors: [
                            Color(0xf2f2f2f2),
                            tableDefine['backgroundColor']
                          ],
                        ),
                      ),

                      //),
                      //),
                      //],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

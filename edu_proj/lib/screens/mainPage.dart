// @dart=2.9
import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      datamodel.setScreenSize(size);
      return Center(
        child: Image.network(datamodel.imgList[gMain]),
      );
    });
  }
}

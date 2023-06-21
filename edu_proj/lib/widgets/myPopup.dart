import 'package:edu_proj/config/constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/myGlass.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:edu_proj/widgets/textfieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'myLabel.dart';

class MyPopup extends StatelessWidget {
  final Map _param;
  MyPopup(this._param);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      int btnColorValue = _param[gColor] ?? Colors.blue.value;
      Color btnColor = Color(btnColorValue);
      Color backColor = datamodel.fromBdckcolor(btnColorValue);
      if (btnColor == Colors.transparent) {
        backColor = btnColor;
      }
      getActions(context, backcolor) {
        List<Widget> actions =
            datamodel.getActionsBasic(_param[gActions], context, backcolor);
        return actions;
      }

      /*Map item = {
          //gWidth: 150.0,
          gId: gSearchZzy,
          gLabel: gSearch,
          //gFocus: false,
          gInputType: gSearch,
          gType: gSearch,

          //gTxtEditingController: searchController
        };

        Map searchItemValue = item;
        searchItemValue.putIfAbsent(gAction, () => gLocalAction);
        //searchItemValue.putIfAbsent(gWidth, () => 250.0);
        searchItemValue.putIfAbsent(gContext, ()=>context);
        searchItemValue.putIfAbsent(gTableID, () => tableName);*/
      Widget wSearch = SizedBox();
      if (_param[gSearch] ?? false) {
        var dpid = datamodel.getDPidfromItem(_param[gActions][0][gItem]);
        Map item = {
          //gWidth: 150.0,
          gId: gSearchZzy,
          gLabel: gSearch,
          //gFocus: false,
          gInputType: gSearch,
          gType: gSearch,

          //gTxtEditingController: searchController
        };

        wSearch = SizedBox(
          width: 180.0,
          child: TextFieldWidget(
              item: item,
              typeOwner: gDroplist,
              name: dpid,
              backcolor: btnColorValue),
        );
      }
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
                icon: Icon(Icons.close_outlined),
                tooltip: datamodel.getSCurrent(gClose),
                onPressed: () {
                  datamodel.removeOverlay();
                  //Navigator.pop(context);
                  //Navigator.removeRoute(context, datamodel.lastRoute);
                },
              ),
              wSearch,
              Expanded(
                  child: datamodel.getTitle(_param, context, backColor.value)),
              Row(children: getActions(context, backColor.value)),
            ])
      };

      Map param = {
        gWidth: _param[gWidth] ?? MediaQuery.of(context).size.width - 12.0,
        gHeight: datamodel.isNull(_param[gHeight])
            ? MediaQuery.of(context).size.height * 0.6
            : _param[gHeight],
        gBorderRadius: _param[gBorderRadius] ?? 10.0,
        gMargin: _param[gMargin] ?? const EdgeInsets.all(1.5),
        gPadding: _param[gPadding] ?? const EdgeInsets.all(1.5),
        gBlur: _param[gBlur] ?? 10.0,
        gAlignment: _param[gAlignment] ?? Alignment.topLeft,
        gBorder: _param[gBorder] ?? 2.0,
        gColor: btnColor,
        gOpacity: 1.0,
        gBackgroundColor: backColor, //Color.fromARGB(255, 218, 165, 32),
        //gBackgroundColor: Color.fromARGB(255, 29, 1, 1),

        gChild: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MyGlass(param0),
            Divider(),
            SizedBox(
                height: datamodel.isNull(_param[gHeight])
                    ? MediaQuery.of(context).size.height * 0.5
                    : _param[gHeight] - 60.0,
                //constraints: BoxConstraints(maxHeight: _scrollHeight),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: _param[gWidget] ?? MyLabel(_param, btnColor.value),
                )),
            //MyGlass(param0),
            /*Container(
              //constraints: BoxConstraints(maxHeight: _scrollHeight),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: _param[gWidget] ?? MyLabel(_param, btnColor.value),
              ),
            ),*/
          ],
        )
      };
      /*final double _screenHeight = MediaQuery.of(context).size.height;
      var _screenPadding = MediaQuery.of(context).viewPadding;

      final double _scrollHeight =
          (_screenHeight - _screenPadding.top - kToolbarHeight) * 0.7;*/
      return Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 1.0,
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyGlass(param),
              ),
            ),
          ),
        ),
      );
    });
  }
}

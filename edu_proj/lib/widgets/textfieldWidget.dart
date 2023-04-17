// @dart=2.9
import 'dart:async';

import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'myLabel.dart';

class TextFieldWidget extends StatelessWidget {
  //final MapEntry<dynamic, dynamic> item;
  final Map item;
  final int backcolor;
  final dynamic typeOwner;
  final dynamic name;
  final dynamic id;
  //final _debouncer = Debouncer(milliseconds: 2000);

  TextFieldWidget(
      {this.item,
      this.backcolor,
      this.typeOwner,
      this.name,
      this.id,
      int gBackgroundColor});
  /*_getWidth() {
    return null;
    //item[gWidth] ?? null;
  }*/

  textChange(text, Map item, DataModel datamodel, BuildContext context, type) {
    datamodel.textChange(text, item, context, type, name, id);
  }

  Widget build(BuildContext context) {
    dynamic thistext;

    return Consumer<DataModel>(builder: (context, datamodel, child) {
      item[gType] = item[gType] ?? '';
      bool isPassword = (item[gType] == gPassword);
      if (item[gType] == gAddress || item[gType] == gSearch) {
        item[gSuffixIconLocal] = IconButton(
            icon: Icon(((item[gType] == gSearch)
                    ? Icons.content_paste_search_outlined
                    : Icons.expand_more)

                //color: Theme.of(context).disabledColor,
                ),
            onPressed: () async {
              item[gShowDetail] = true;
              if (typeOwner == gForm) {
                datamodel.setFocus(name, item[gId], null, typeOwner);
              } else if (item[gType] == gSearch) {
                textChange(thistext, item, datamodel, context, false);
                return;
              } else {
                datamodel.setFocusItem(name, item, item[gId], typeOwner);
              }

              if (item[gType] == gAddress) {
                var searchTxt = thistext ?? item[gSearch] ?? item[gValue];
                datamodel.showPopupItem(
                    item, typeOwner, name, searchTxt, id, backcolor, context);

                return;
              }
              List actions = [];
              actions.add({
                gType: gIcon,
                gValue: 0xef49,
                gLabel: gConfirm,
                gAction: gLocalAction,
                gItem: item,
                gTypeOwner: typeOwner,
                gName: name,
                gId: id,
              });
              Widget w = await datamodel.getItemSubWidget(
                  item, typeOwner, name, context, id, backcolor, actions);

              //}
              datamodel.showPopup(context, w, null, actions);
              //}

              //datamodel.myNotifyListeners();
            });
      }
      //datamodel.getItemIcon(item, context);
      if ((item[gIsFile] ?? false) == true) {
        item[gSuffixIconLocal] = IconButton(
            icon: Icon(Icons.file_upload_outlined
                //color: Theme.of(context).disabledColor,
                ),
            onPressed: () {
              datamodel.loadFile(name, item, typeOwner);
            });
      }

      Color cBackColor = datamodel.fromBdckcolor(backcolor);
      if (item[gTxtEditingController] == null) {
        item[gTxtEditingController] = new TextEditingController();
        item[gTxtEditingController].text =
            datamodel.getValue(name, item[gId], id, typeOwner);
      }
      TextEditingController txtController = item[gTxtEditingController];
      var showValue = txtController.text ?? "";

      if (datamodel.isNull(showValue)) {
        txtController.text = "";
      } else {
        var modifiedValue = datamodel.getValue(name, item[gId], id, typeOwner);
        //dynamic aValue = datamodel.getValueGUI(item[gValue], item);
        dynamic aValue = datamodel.getValueGUI(modifiedValue, item);
        txtController.text = aValue;
      }
      bool autofocus = datamodel.getFocus(
        typeOwner,
        name,
        item,
      );

      /*if (autofocus && datamodel.isPopOpen()) {
        autofocus = false;
      }*/
      var labeltext = item[gLabel];
      /*print('======= txtFieldwidget ' +
          labeltext +
          ' autofocus is ' +
          autofocus.toString());*/
      Widget w = TextFormField(
        controller: txtController,
        autofocus: autofocus,
        //focusNode: _focusNode,
        keyboardType: datamodel.getInputType(item[gInputType]),
        maxLength: item[gLength],
        style: TextStyle(
          color: cBackColor,
          fontSize: item[gFontSize],
          fontStyle: item[gFontStyle],
          fontWeight: item[gFontWeight],
          letterSpacing: item[gLetterSpacing],
        ),
        decoration: InputDecoration(
            border: new OutlineInputBorder(
              //添加边框
              gapPadding: 0.0,
              borderRadius: BorderRadius.circular(2.0),
            ),
            hintText: datamodel
                .getSCurrent('Please enter ' + labeltext), //item[gPlaceHolder],
            hintStyle: TextStyle(
              color: cBackColor,
              fontSize: item[gFontSize],
              fontStyle: item[gFontStyle],
              fontWeight: item[gFontWeight],
              letterSpacing: item[gLetterSpacing],
            ),
            isDense: true, // Added this
            enabled: ((item[gType] ?? "") != gLabel)),
        obscureText: isPassword && item[gPasswordShow],
        inputFormatters: datamodel.getItemFormatters(item),
        validator: (dynamic value) {
          var validResult = datamodel.isItemValueValidStr(item, value);
          if (validResult != '') {
            return validResult;
          }

          return null;
        },
        onSaved: (dynamic value) {
          textChange(value, item, datamodel, context, typeOwner);
        },
        onChanged: (text) {
          //如果是表字段，检查状态是否改变
          //  如果状态变true,检查form的状态

          if (typeOwner == gForm) {
            datamodel.checkFormStatus(name, item, text);
          }
          thistext = text;
          textChange(thistext, item, datamodel, context, typeOwner);
        },
        onTap: () {
          //FocusScope.of(context).requestFocus(_commentFocus);
          //set focus
          datamodel.setFocus(name, item[gId], null, typeOwner);
        },
        onEditingComplete: () {
          textChange(thistext, item, datamodel, context, typeOwner);
          datamodel.setFocusNext(name, item[gId], null);
          datamodel.myNotifyListeners();
        },
      );
      if (item[gId] != gSearchZzy) {
        w = Expanded(
          child: Focus(
              onKey: (node, event) {
                String keyLabel = event.logicalKey.keyLabel;
                if (keyLabel == 'Tab') {
                  datamodel.setFocusNext(name, item[gId], null);

                  datamodel.myNotifyListeners();
                } else {}
                return KeyEventResult.ignored;
              },
              child: w),
        );
      }

      if (item[gSuffixIconLocal] != null) {
        w = Expanded(child: w);
        w = Row(
          children: [w, item[gSuffixIconLocal]],
        );
      }
      txtController.selection = TextSelection.fromPosition(
          TextPosition(offset: txtController.text.length));
      return w;
    });
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

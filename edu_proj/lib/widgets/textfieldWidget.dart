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
  final dynamic isForm;
  final dynamic name;
  final dynamic id;
  final _debouncer = Debouncer(milliseconds: 2000);
  TextFieldWidget({this.item, this.backcolor, this.isForm, this.name, this.id});
  /*_getWidth() {
    return null;
    //item[gWidth] ?? null;
  }*/

  textChange(
      text, Map item, DataModel datamodel, BuildContext context, bool isForm) {
    datamodel.textChange(text, item, context, isForm, name, id);
    /*if (!isForm && item[gType] != gSearch) {
      datamodel.setTableValueItem(name, item[gId], id, text);
      datamodel.myNotifyListeners();

      //print('--------------  textChange 0 1');
      return;
    }
    //print('--------------  textChange 1');
    if (item[gDroplist] == '') {
      item[gValue] = text;
    }
    item[gSearch] = text;
    //print('--------------  textChange 2');
    if (item[gType] == gAddress) {
      return;
    }
    //print('--------------  textChange 3');
    if ((item[gAction] ?? '') == '') {
      //print('--------------  textChange 3 0');
      return;
    }
    //print('--------------  textChange 4');
    //print('--------------  textChange 2');

    datamodel.sendRequestOne(item[gAction], item, item[gContext] ?? context);*/
  }

  Widget build(BuildContext context) {
    dynamic thistext;

    return Consumer<DataModel>(builder: (context, datamodel, child) {
      bool isPassword = (item[gType] == gPassword);
      if (isPassword) {
        item[gPasswordShow] = item[gPasswordShow] ?? true;

        item[gSuffixIcon] = IconButton(
            icon: Icon(
              item[gPasswordShow]
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Theme.of(context).disabledColor,
            ),
            onPressed: () {
              item[gPasswordShow] = !item[gPasswordShow];
              datamodel.myNotifyListeners();
            });
      }
      if (item[gType] == gAddress || item[gType] == gSearch) {
        item[gSuffixIcon] = IconButton(
            icon: Icon(((item[gType] == gSearch)
                    ? Icons.content_paste_search_outlined
                    : Icons.expand_more)

                //color: Theme.of(context).disabledColor,
                ),
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              item[gShowDetail] = true;
              if (isForm) {
                datamodel.setFormFocus(name, item[gId]);
              } else if (item[gType] == gSearch) {
                textChange(thistext, item, datamodel, context, false);
                return;
              } else {
                datamodel.setTableFocusItem(name, item, item[gId]);
              }

              if (item[gType] == gAddress) {
                var searchTxt = thistext ?? item[gSearch] ?? item[gValue];
                datamodel.showPopupItem(
                    item, isForm, name, searchTxt, id, backcolor, context);

                return;
              }
              List actions = [];
              actions.add({
                gType: gIcon,
                gValue: 0xef49,
                gLabel: gConfirm,
                gAction: gLocalAction,
                gItem: item,
                gIsForm: isForm,
                gName: name,
                gId: id,
              });
              Widget w = await datamodel.getItemSubWidget(
                  item, isForm, name, context, id, backcolor, actions, null);

              //}
              datamodel.showPopup(context, w, null, actions);
              //}

              //datamodel.myNotifyListeners();
            });
      }
      datamodel.getItemIcon(item, context);
      if (item[gIsFile] == true) {
        item[gSuffixIcon] = IconButton(
            icon: Icon(Icons.file_upload_outlined
                //color: Theme.of(context).disabledColor,
                ),
            onPressed: () {
              datamodel.loadFile(name, item);
            });
      }

      item[gTxtEditingController].selection = TextSelection.fromPosition(
          TextPosition(offset: item[gTxtEditingController].text.length));
      Color cBackColor = datamodel.fromBdckcolor(backcolor);
      TextEditingController txtController = item[gTxtEditingController];
      if (datamodel.isNull(txtController.text)) {
        txtController.text = "";
      } else {
        dynamic aValue = datamodel.getValueByType(item[gValue], item);
        txtController.text = aValue;
      }
      bool autofocus = item[gFocus] ?? false;

      /*if (autofocus && datamodel.isPopOpen()) {
        autofocus = false;
      }*/
      print('======= txtFieldwidget autofocus is ' + autofocus.toString());
      var labeltext = item[gLabel];
      Widget w = TextFormField(
        controller: txtController,
        autofocus: autofocus,
        keyboardType: datamodel.getInputType(item[gInputType]),
        maxLength: isForm ? item[gLength] : null,
        style: TextStyle(
          color: cBackColor,
          fontSize: item[gFontSize],
          fontStyle: item[gFontStyle],
          fontWeight: item[gFontWeight],
          letterSpacing: item[gLetterSpacing],
        ),
        decoration: isForm
            ? InputDecoration(
                labelText: labeltext,
                labelStyle: TextStyle(
                  color: cBackColor,
                  fontSize: item[gFontSize],
                  fontStyle: item[gFontStyle],
                  fontWeight: item[gFontWeight],
                  letterSpacing: item[gLetterSpacing],
                ),
                hintText: item[gPlaceHolder],
                hintStyle: TextStyle(
                  color: cBackColor,
                  fontSize: item[gFontSize],
                  fontStyle: item[gFontStyle],
                  fontWeight: item[gFontWeight],
                  letterSpacing: item[gLetterSpacing],
                ),
                enabled: ((item[gType] ?? "") != gLabel))
            : InputDecoration(
                border: new OutlineInputBorder(
                  //添加边框
                  gapPadding: 0.0,
                  borderRadius: BorderRadius.circular(2.0),
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
          textChange(value, item, datamodel, context, isForm);
        },
        onChanged: (text) {
          thistext = text;
          _debouncer
              .run(() => textChange(text, item, datamodel, context, isForm));
        },
        onTap: () {
          if (!isForm) {
            return;
          }
          //set focus
          datamodel.setFormFocus(name, item[gId]);
        },
        onEditingComplete: () {
          textChange(thistext, item, datamodel, context, isForm);
          if (isForm) {
            datamodel.setFormNextFocus(name, item[gId]);
          } else {
            datamodel.setTableNextFocus(name, item[gId], id);
          }
          datamodel.myNotifyListeners();
        },
      );
      w = Expanded(
        child: Focus(
            onKey: (node, event) {
              String keyLabel = event.logicalKey.keyLabel;
              if (keyLabel == 'Tab') {
                if (isForm) {
                  datamodel.setFormNextFocus(name, item[gId]);
                } else {
                  datamodel.setTableNextFocus(name, item[gId], id);
                }

                datamodel.myNotifyListeners();
              } else {}
              return KeyEventResult.ignored;
            },
            child: w),
      );
      if (item[gSuffixIcon] != null) {
        w = Row(
          children: [w, item[gSuffixIcon]],
        );
      }
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

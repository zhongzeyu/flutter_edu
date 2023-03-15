// @dart=2.9
import 'dart:async';

import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'myLabel.dart';

class TextFieldWidget extends StatelessWidget {
  final MapEntry<dynamic, dynamic> item;
  final int backcolor;
  final dynamic formname;
  final dynamic tablename;
  final dynamic id;
  //final _debouncer = Debouncer(milliseconds: 1000);
  TextFieldWidget(
      {this.item, this.backcolor, this.formname, this.tablename, this.id});
  _getWidth() {
    return null;
    //item.value[gWidth] ?? null;
  }

  textChange(dynamic text, MapEntry item, DataModel datamodel,
      BuildContext context, bool isForm) {
    //item.value[gValue] = text;
    print('--------------  textChange 0');
    if (!isForm) {
      datamodel.setTableValueItem(tablename, item.value[gId], id, text);
      datamodel.myNotifyListeners();
      return;
    }
    print('--------------  textChange 1');
    if (item.value[gDroplist] == '') {
      item.value[gValue] = text;
    }
    item.value[gSearch] = text;
    print('--------------  textChange 2');
    if (item.value[gType] == gAddress) {
      return;
      /*item.value[gAction] = gLocalAction;
      item.value[gFormName] = formname;*/
    }
    print('--------------  textChange 3');
    if ((item.value[gAction] ?? '') == '') {
      return;
    }
    print('--------------  textChange 4');
    //print('--------------  textChange 2');

    datamodel.sendRequestOne(
        item.value[gAction], item, item.value[gContext] ?? context);
  }

  setItemI(item, value, DataModel datamodel) {
    bool isForm = !datamodel.isNull(formname);
    dynamic name = formname;
    if (!isForm) {
      name = tablename;
    }
    if (isForm) {
      datamodel.setFormValue(name, item.value[gId], value);
      //datamodel.setFormValueShow(formname, item.value[gId]);
      datamodel.setFormNextFocus(name, item.value[gId]);
    } else {
      datamodel.setTableValue(name, item.value[gId], id, value);
      //datamodel.setFormValueShow(formname, item.value[gId]);
      datamodel.setTableNextFocus(name, item.value[gId], id);
    }

    datamodel.dpList[gAddress + '_' + name + '_' + item.value[gId]] = null;

    datamodel.myNotifyListeners();
  }

  Widget build(BuildContext context) {
    dynamic thistext;
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      bool isPassword = (item.value[gType] == gPassword);
      bool isForm = !datamodel.isNull(formname);
      if (isPassword) {
        item.value[gPasswordShow] = item.value[gPasswordShow] ?? true;

        item.value[gSuffixIcon] = IconButton(
            icon: Icon(
              item.value[gPasswordShow]
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Theme.of(context).disabledColor,
            ),
            onPressed: () {
              item.value[gPasswordShow] = !item.value[gPasswordShow];
              datamodel.myNotifyListeners();
            });
      }
      if ((item.value[gType] == gDate ||
              item.value[gType] == gAddress ||
              item.value[gDroplist] != '') &&
          (item.value[gType] ?? "") != gLabel) {
        item.value[gSuffixIcon] = IconButton(
            icon: Icon((item.value[gType] == gDate)
                    ? Icons.date_range_outlined
                    : Icons.arrow_drop_down_circle_sharp

                //color: Theme.of(context).disabledColor,
                ),
            onPressed: () async {
              item.value[gShowDetail] = true;
              if (isForm) {
                datamodel.setFormFocus(formname, item.value[gId]);
              } else {
                datamodel.setTableFocusItem(tablename, item, item.value[gId]);
              }

              if (item.value[gType] == gAddress) {
                var searchTxt = item.value[gSearch] ?? item.value[gValue];
                if (datamodel.isNull(searchTxt)) {
                  return;
                }
                if ((searchTxt.toString()).length < 3) {
                  return;
                }
                item.value[gFormName] = formname ?? tablename;
              }
              List actions = [];
              //if (item.value[gType] == gDate) {
              actions.add({
                gType: gIcon,
                gValue: 0xef49,
                gLabel: gConfirm,
                gAction: gLocalAction,
                gItem: item,
                gFormid: formname,
                gTableID: tablename,
                gId: id,
              });
              Widget w = await datamodel.getItemSubWidget(
                  item, formname, context, tablename, id, backcolor, actions);

              //}
              datamodel.showPopup(context, w, null, actions);
              //}

              //datamodel.myNotifyListeners();
            });
      }
      if (item.value[gType] == gEmail) {
        item.value[gSuffixIcon] = IconButton(
            icon: Icon(Icons.email_outlined
                //color: Theme.of(context).disabledColor,
                ),
            onPressed: () {
              //datamodel.setFormFocus(formname, item.value[gId]);
              datamodel.sendEmail(item.value[gValue]);
            });
      }
      if (item.value[gType] == gPhone) {
        item.value[gSuffixIcon] = IconButton(
            icon: Icon(Icons.phone_outlined
                //color: Theme.of(context).disabledColor,
                ),
            onPressed: () {
              //datamodel.setFormFocus(formname, item.value[gId]);
              datamodel.phonecall(item.value[gValue]);
            });
      }
      if (item.value[gType] == gUrl) {
        item.value[gSuffixIcon] = IconButton(
            icon: Icon(Icons.web_outlined
                //color: Theme.of(context).disabledColor,
                ),
            onPressed: () {
              //datamodel.setFormFocus(formname, item.value[gId]);
              datamodel.loadUrl(item.value[gValue]);
            });
      }
      if (item.value[gIsFile] == true) {
        item.value[gSuffixIcon] = IconButton(
            icon: Icon(Icons.file_upload_outlined
                //color: Theme.of(context).disabledColor,
                ),
            onPressed: () {
              datamodel.loadFile(formname, item);
            });
      }

      item.value[gTxtEditingController].selection = TextSelection.fromPosition(
          TextPosition(offset: item.value[gTxtEditingController].text.length));
      Color cBackColor = datamodel.fromBdckcolor(backcolor);
      TextEditingController txtController = item.value[gTxtEditingController];
      if (datamodel.isNull(txtController.text)) {
        txtController.text = "";
      } else {
        dynamic aValue =
            datamodel.getValueByType(item.value[gValue], item.value);
        /*if (item.value[gDroplist] != '') {
          aValue = datamodel.getSCurrent(aValue);
        }*/
        txtController.text = aValue;
      }

      return Container(
        width: _getWidth(),
        child: Column(
          children: [
            Focus(
              onKey: (node, event) {
                String keyLabel = event.logicalKey.keyLabel;
                if (keyLabel == 'Tab') {
                  if (isForm) {
                    datamodel.setFormNextFocus(formname, item.value[gId]);
                  } else {
                    datamodel.setTableNextFocus(tablename, item.value[gId], id);
                  }

                  datamodel.myNotifyListeners();
                } else {}
                return KeyEventResult.ignored;
              },
              child: TextFormField(
                controller: txtController,
                autofocus: item.value[gFocus] ?? false,
                //focusNode: item.value[gFocusNode],
                keyboardType: datamodel.getInputType(item.value[gInputType]),
                maxLength: isForm ? item.value[gLength] : null,
                style: TextStyle(
                  color: cBackColor,
                  fontSize: item.value[gFontSize],
                  fontStyle: item.value[gFontStyle],
                  fontWeight: item.value[gFontWeight],
                  letterSpacing: item.value[gLetterSpacing],
                ),
                decoration: isForm
                    ? InputDecoration(
                        labelText: datamodel.getSCurrent(item.value[gLabel]),
                        labelStyle: TextStyle(
                          color: cBackColor,
                          fontSize: item.value[gFontSize],
                          fontStyle: item.value[gFontStyle],
                          fontWeight: item.value[gFontWeight],
                          letterSpacing: item.value[gLetterSpacing],
                        ),
                        hintText: item.value[gPlaceHolder],
                        hintStyle: TextStyle(
                          color: cBackColor,
                          fontSize: item.value[gFontSize],
                          fontStyle: item.value[gFontStyle],
                          fontWeight: item.value[gFontWeight],
                          letterSpacing: item.value[gLetterSpacing],
                        ),
                        suffixIcon: item.value[gSuffixIcon],
                        //prefixIcon: item.value['prefixIcon'],
                        enabled: ((item.value[gType] ?? "") != gLabel))
                    : InputDecoration(
                        border: new OutlineInputBorder(
                          //添加边框
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        isDense: true, // Added this
                        //contentPadding: EdgeInsets.all(2.0),
                        suffixIcon: item.value[gSuffixIcon],
                        enabled: ((item.value[gType] ?? "") != gLabel)),
                obscureText: isPassword && item.value[gPasswordShow],
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
                  //item.value[gValue] = value;
                },
                onChanged: (text) {
                  thistext = text;
                  /*_debouncer.run(
                      () => textChange(text, item, datamodel, context, isForm));*/
                },
                onTap: () {
                  if (!isForm) {
                    return;
                  }
                  //set focus
                  datamodel.setFormFocus(formname, item.value[gId]);
                },
                onEditingComplete: () {
                  textChange(thistext, item, datamodel, context, isForm);
                  if (isForm) {
                    datamodel.setFormNextFocus(formname, item.value[gId]);
                  } else {
                    datamodel.setTableNextFocus(tablename, item.value[gId], id);
                  }
                  datamodel.myNotifyListeners();
                },
              ),
            ),
          ],
        ),
      );
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
